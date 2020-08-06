local util = import '_util.libsonnet';

{
  prometheus+:: {
    name:: error 'must specify name',

    // We bounce through various layers of indirection so user can:
    // a) override config for all Prometheus' by merging into $.prometheus_config,
    // b) override config for a specific Prometheus instance by merging in here.
    prometheus_config:: $.prometheus_config {
      rule_files+: std.flattenArrays([
        [
          '%s/alerts.rules' % util.normalise(mixinName),
          '%s/recording.rules' % util.normalise(mixinName),
        ]
        for mixinName in std.objectFields($.mixins)
      ]),
    },

    prometheusAlerts:: $.prometheusAlerts,
    prometheusRules:: $.prometheusRules,

    local prometheus_config = self.prometheus_config,
    local prometheusAlerts = self.prometheusAlerts,
    local prometheusRules = self.prometheusRules,

    local configMap = $.core.v1.configMap,

    prometheus_config_maps: [
                              configMap.new('%s-config' % self.name) +
                              configMap.withData({
                                'prometheus.yml': $.util.manifestYaml(prometheus_config),
                                'alerts.rules': $.util.manifestYaml(prometheusAlerts),
                                'recording.rules': $.util.manifestYaml(prometheusRules),
                              }),
                            ] +
                            [
                              local mixin = $.mixins[mixinName] + util.emptyMixin;
                              configMap.new('%s-%s-config' % [self.name, util.normalise(mixinName)]) +
                              configMap.withData({
                                'alerts.rules': $.util.manifestYaml(mixin.prometheusAlerts),
                                'recording.rules': $.util.manifestYaml(mixin.prometheusRules),
                              },)
                              for mixinName in std.objectFields($.mixins)
                            ],
  },
}
