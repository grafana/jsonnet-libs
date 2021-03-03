local kausal = import 'ksonnet-util/kausal.libsonnet';

{
  local this = self,
  local _config = self._config,
  local k = kausal {
    _config+:: _config,
  } + (
    // an attempt at providing compat with the original ksonnet-lib
    if std.objectHas(kausal, '__ksonnet')
    then
      {
        core+: { v1+: {
          envVar: kausal.core.v1.container.envType,
        } },
      }
    else {}
  ),

  _config+:: {
    prometheus_config_dir: '/etc/$(POD_NAME)',
  },

  // The '__replica__' label is used by Cortex for deduplication.
  // We add a different one to each HA replica but remove it from
  // alerts to not break deduplication of alerts in the Alertmanager.
  prometheus_config+: {
    alerting+: {
      alert_relabel_configs+: [
        {
          regex: '__replica__',
          action: 'labeldrop',
        },
      ],
    },
  },

  prometheus_zero+:: {
    config+:: this.prometheus_config {
      global+: {
        external_labels+: {
          __replica__: 'prometheus-0',
        },
      },
    },
    alerts+:: this.prometheusAlerts,
    rules+:: this.prometheusRules,
  },

  prometheus_one+:: {
    config+:: this.prometheus_config {
      global+: {
        external_labels+: {
          __replica__: 'prometheus-1',
        },
      },
    },
    alerts+:: this.prometheusAlerts,
    rules+:: this.prometheusRules,
  },

  local configMap = k.core.v1.configMap,

  prometheus_config_maps: [
    configMap.new('%s-0-config' % _config.name) +
    configMap.withData({
      'prometheus.yml': k.util.manifestYaml(this.prometheus_zero.config),
    }),
    configMap.new('%s-0-alerts' % _config.name) +
    configMap.withData({
      'alerts.rules': k.util.manifestYaml(this.prometheus_zero.alerts),
    }),
    configMap.new('%s-0-recording' % _config.name) +
    configMap.withData({
      'recording.rules': k.util.manifestYaml(this.prometheus_zero.rules),
    }),

    configMap.new('%s-1-config' % _config.name) +
    configMap.withData({
      'prometheus.yml': k.util.manifestYaml(this.prometheus_one.config),
    }),
    configMap.new('%s-1-alerts' % _config.name) +
    configMap.withData({
      'alerts.rules': k.util.manifestYaml(this.prometheus_one.alerts),
    }),
    configMap.new('%s-1-recording' % _config.name) +
    configMap.withData({
      'recording.rules': k.util.manifestYaml(this.prometheus_one.rules),
    }),
  ],

  prometheus_config_mount::
    k.util.configVolumeMount('%s-0-config' % _config.name, '/etc/%s-0' % _config.name)
    + k.util.configVolumeMount('%s-0-alerts' % _config.name, '/etc/%s-0/alerts' % _config.name)
    + k.util.configVolumeMount('%s-0-recording' % _config.name, '/etc/%s-0/recording' % _config.name)
    + k.util.configVolumeMount('%s-1-config' % _config.name, '/etc/%s-1' % _config.name)
    + k.util.configVolumeMount('%s-1-alerts' % _config.name, '/etc/%s-1/alerts' % _config.name)
    + k.util.configVolumeMount('%s-1-recording' % _config.name, '/etc/%s-1/recording' % _config.name)
  ,

  local container = k.core.v1.container,
  local envVar = k.core.v1.envVar,

  prometheus_container+::
    container.withEnv([
      envVar.fromFieldPath('POD_NAME', 'metadata.name'),
    ])
    + container.mixin.readinessProbe.httpGet.withPath('%(prometheus_path)s-/ready' % self._config)
    + container.mixin.readinessProbe.httpGet.withPort(self._config.prometheus_port)
    + container.mixin.readinessProbe.withInitialDelaySeconds(15)
    + container.mixin.readinessProbe.withTimeoutSeconds(1)
  ,

  prometheus_watch_container+::
    container.withEnv([
      envVar.fromFieldPath('POD_NAME', 'metadata.name'),
    ]),

  local statefulset = k.apps.v1.statefulSet,

  prometheus_statefulset+:
    statefulset.mixin.spec.withReplicas(2)
    + k.util.antiAffinityStatefulSet,
}
