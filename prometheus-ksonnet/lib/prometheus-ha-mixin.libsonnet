{
  prometheus_config_0: $.prometheus_config,
  prometheus_config_1: $.prometheus_config,

  prometheusAlerts_0: $.prometheusAlerts,
  prometheusAlerts_1: $.prometheusAlerts,

  prometheusRules_0: $.prometheusRules,
  prometheusRules_1: $.prometheusRules,

  prometheus+:: {
    local configMap = $.core.v1.configMap,

    prometheus_config_map:: {},

    prometheus_config_maps: [{
      configMap.new('%s-config-0' % self.name) +
      configMap.withData({
        'prometheus.yml': $.util.manifestYaml($.prometheus_config_0),
        'alerts.rules': $.util.manifestYaml($.prometheusAlerts_0),
        'recording.rules': $.util.manifestYaml($.prometheusRules_0),
      }),
      configMap.new('%s-config-1' % self.name) +
      configMap.withData({
        'prometheus.yml': $.util.manifestYaml($.prometheus_config_1),
        'alerts.rules': $.util.manifestYaml($.prometheusAlerts_1),
        'recording.rules': $.util.manifestYaml($.prometheusRules_1),
      }),
    ]},

  prometheus_config_mount:: {},

  prometheus_init_container::
    container.new('prometheus-init', 'busybox') +
    container.withCommand(["ln", "-s", "/etc/$HOSTNAME", "/etc/prometheus"]),

  prometheus_statefulset:
    $.util.configVolumeMount('%s-config-0' % self.name, '/etc/prometheus-0') +
    $.util.configVolumeMount('%s-config-1' % self.name, '/etc/prometheus-1') +
    statefulset.mixin.spec.template.spec.withInitContainers(self.prometheus_init_container) +
    statefulset.mixin.spec.withReplicas(2),
}
