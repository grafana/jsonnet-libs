local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local statefulset = k.apps.v1.statefulSet;
local configMap = k.core.v1.configMap;

{
  local root = self,

  _config+:: {
    prometheus_config_file: '/etc/$(POD_NAME)/prometheus.yml',
  },

  // The '__replica__' label is used by Cortex for deduplication.
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
    container.envType.fromFieldPath('POD_NAME', 'metadata.name'),
  ]),

  prometheus_watch_container+:: container.withEnv([
    container.envType.fromFieldPath('POD_NAME', 'metadata.name'),
  ]),

  prometheus_statefulset+:
    k.util.configVolumeMount('%s-config-0' % self.name, '/etc/prometheus-0') +
    k.util.configVolumeMount('%s-config-1' % self.name, '/etc/prometheus-1') +
    statefulset.mixin.spec.withReplicas(2),
}
