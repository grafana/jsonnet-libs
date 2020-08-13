local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local envVar = k.core.v1.envVar;
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
          __replica__: 'zero',
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
          __replica__: 'one',
        },
      },
    },
    alerts+:: root.prometheusAlerts,
    rules+:: root.prometheusRules,
  },

  prometheus_config_map:: {},

  prometheus_config_maps: [
    configMap.new('%s-config-0' % self.name) +
    configMap.withData({
      'prometheus.yml': k.util.manifestYaml(root.prometheus_zero.config),
      'alerts.rules': k.util.manifestYaml(root.prometheus_zero.alerts),
      'recording.rules': k.util.manifestYaml(root.prometheus_zero.rules),
    }),
    configMap.new('%s-config-1' % self.name) +
    configMap.withData({
      'prometheus.yml': k.util.manifestYaml(root.prometheus_one.config),
      'alerts.rules': k.util.manifestYaml(root.prometheus_one.alerts),
      'recording.rules': k.util.manifestYaml(root.prometheus_one.rules),
    }),
  ],

  prometheus_config_mount:: {},

  prometheus_container+:: container.withEnv([
                            envVar.fromFieldPath('POD_NAME', 'metadata.name'),
                          ])
                          + container.readinessProbe.httpGet.withPath('%(prometheus_path)s-/ready' % _config)
                          + container.readinessProbe.httpGet.withPort(_config.prometheus_port)
                          + container.readinessProbe.withInitialDelaySeconds(15)
                          + container.readinessProbe.withTimeoutSeconds(1)
  ,

  prometheus_watch_container+:: container.withEnv([
    envVar.fromFieldPath('POD_NAME', 'metadata.name'),
  ]),

  prometheus_statefulset+:
    k.util.configVolumeMount('%s-config-0' % self.name, '/etc/prometheus-0') +
    k.util.configVolumeMount('%s-config-1' % self.name, '/etc/prometheus-1') +
    statefulset.spec.withReplicas(2),
}
