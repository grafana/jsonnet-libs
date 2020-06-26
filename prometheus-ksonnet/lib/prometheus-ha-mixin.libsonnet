local k = import 'ksonnet-util/kausal.libsonnet';
local container = k.core.v1.container;
local statefulset = k.apps.v1.statefulSet;
local configMap = k.core.v1.configMap;

{
  prometheus_config_0:: self.prometheus_config,
  prometheus_config_1:: self.prometheus_config,

  prometheusAlerts_0:: self.prometheusAlerts,
  prometheusAlerts_1:: self.prometheusAlerts,

  prometheusRules_0:: self.prometheusRules,
  prometheusRules_1:: self.prometheusRules,

  local prom = self,

  prometheus_config_map:: {},

  prometheus_config_maps: [
    configMap.new('%s-config-0' % self.name) +
    configMap.withData({
      'prometheus.yml': k.util.manifestYaml(prom.prometheus_config_0),
      'alerts.rules': k.util.manifestYaml(prom.prometheusAlerts_0),
      'recording.rules': k.util.manifestYaml(prom.prometheusRules_0),
    }),
    configMap.new('%s-config-1' % self.name) +
    configMap.withData({
      'prometheus.yml': k.util.manifestYaml(prom.prometheus_config_1),
      'alerts.rules': k.util.manifestYaml(prom.prometheusAlerts_1),
      'recording.rules': k.util.manifestYaml(prom.prometheusRules_1),
    }),
  ],

  prometheus_config_mount:: {},

  prometheus_config_file:: '/etc/$(POD_NAME)/prometheus.yml',

  prometheus_container+:: container.withEnv([
    container.envType.fromFieldPath('POD_NAME', 'metadata.name'),
  ]),

  prometheus_statefulset+:
    k.util.configVolumeMount('%s-config-0' % self.name, '/etc/prometheus-0') +
    k.util.configVolumeMount('%s-config-1' % self.name, '/etc/prometheus-1') +
    statefulset.mixin.spec.withReplicas(2),
}
