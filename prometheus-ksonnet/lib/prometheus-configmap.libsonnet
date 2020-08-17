{
  prometheus+:: {
    name:: error 'must specify name',

    // We bounce through various layers of indirection so user can:
    // a) override config for all Prometheus' by merging into $.prometheus_config,
    // b) override config for a specific Prometheus instance by merging in here.
    prometheus_config:: $.prometheus_config,
    prometheusAlerts:: $.prometheusAlerts,
    prometheusRules:: $.prometheusRules,

    local configMap = $.core.v1.configMap,

    prometheus_config_maps:
      // Can't reference self.foo below as we're in a map context, so
      // need to capture reference to the configs in scope here.
      local prometheus_config = self.prometheus_config;
      local prometheusAlerts = self.prometheusAlerts;
      local prometheusRules = self.prometheusRules;
      [
        configMap.new('%s-config' % self.name) +
        configMap.withData({
          'prometheus.yml': $.util.manifestYaml(prometheus_config),
        }),

        configMap.new('%s-alerts' % self.name) +
        configMap.withData({
          'alerts.rules': $.util.manifestYaml(prometheusAlerts),
        }),

        configMap.new('%s-rules' % self.name) +
        configMap.withData({
          'recording.rules': $.util.manifestYaml(prometheusRules),
        }),
      ],
  },
}
