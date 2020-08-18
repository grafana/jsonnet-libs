local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local statefulset = k.apps.v1.statefulSet;
local configMap = k.core.v1.configMap;

{
  local root = self,

  _config+:: {
    prometheus_config_dir: '/etc/$(POD_NAME)',
  },
  local _config = self._config,

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
    config+:: root.prometheus_config {
      global+: {
        external_labels+: {
          __replica__: 'prometheus-0',
        },
      },
    },
    alerts+:: root.prometheusAlerts,
    rules+:: root.prometheusRules,
  },

  prometheus_one+:: {
    config+:: root.prometheus_config {
      global+: {
        external_labels+: {
          __replica__: 'prometheus-1',
        },
      },
    },
    alerts+:: root.prometheusAlerts,
    rules+:: root.prometheusRules,
  },

  prometheus_config_maps: [
    configMap.new('%s-0-config' % self.name) +
    configMap.withData({
      'prometheus.yml': k.util.manifestYaml(root.prometheus_zero.config),
    }),
    configMap.new('%s-0-alerts' % self.name) +
    configMap.withData({
      'alerts.rules': k.util.manifestYaml(root.prometheus_zero.alerts),
    }),
    configMap.new('%s-0-recording' % self.name) +
    configMap.withData({
      'recording.rules': k.util.manifestYaml(root.prometheus_zero.rules),
    }),

    configMap.new('%s-1-config' % self.name) +
    configMap.withData({
      'prometheus.yml': k.util.manifestYaml(root.prometheus_one.config),
    }),
    configMap.new('%s-1-alerts' % self.name) +
    configMap.withData({
      'alerts.rules': k.util.manifestYaml(root.prometheus_one.alerts),
    }),
    configMap.new('%s-1-recording' % self.name) +
    configMap.withData({
      'recording.rules': k.util.manifestYaml(root.prometheus_one.rules),
    }),
  ],

  prometheus_config_mount::
    k.util.configVolumeMount('%s-0-config' % self.name, '/etc/prometheus-0')
    + k.util.configVolumeMount('%s-0-alerts' % self.name, '/etc/prometheus-0/alerts')
    + k.util.configVolumeMount('%s-0-recording' % self.name, '/etc/prometheus-0/recording')
    + k.util.configVolumeMount('%s-1-config' % self.name, '/etc/prometheus-1')
    + k.util.configVolumeMount('%s-1-alerts' % self.name, '/etc/prometheus-1/alerts')
    + k.util.configVolumeMount('%s-1-recording' % self.name, '/etc/prometheus-1/recording')
  ,

  prometheus_container+:: container.withEnv([
                            container.envType.fromFieldPath('POD_NAME', 'metadata.name'),
                          ])
                          + container.mixin.readinessProbe.httpGet.withPath('%(prometheus_path)s-/ready' % _config)
                          + container.mixin.readinessProbe.httpGet.withPort(_config.prometheus_port)
                          + container.mixin.readinessProbe.withInitialDelaySeconds(15)
                          + container.mixin.readinessProbe.withTimeoutSeconds(1)
  ,

  prometheus_watch_container+:: container.withEnv([
    container.envType.fromFieldPath('POD_NAME', 'metadata.name'),
  ]),

  prometheus_statefulset+:
    statefulset.mixin.spec.withReplicas(2),
}
