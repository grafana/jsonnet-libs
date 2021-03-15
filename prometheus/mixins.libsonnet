local k = import 'ksonnet-util/kausal.libsonnet';

(import 'config.libsonnet')
+ {
  local _config = self._config,

  mixins+:: {
    base+: {
      prometheusAlerts+: {
        groups+: [
          {
            name: 'prometheus-extra',
            rules: [
              {
                alert: 'PromScrapeFailed',
                expr: |||
                  up != 1
                |||,
                'for': '15m',
                labels: {
                  severity: 'warning',
                },
                annotations: {
                  message: 'Prometheus failed to scrape a target {{ $labels.job }} / {{ $labels.instance }}',
                },
              },
              {
                alert: 'PromScrapeFlapping',
                expr: |||
                  avg_over_time(up[5m]) < 1
                |||,
                'for': '15m',
                labels: {
                  severity: 'warning',
                },
                annotations: {
                  message: 'Prometheus target flapping {{ $labels.job }} / {{ $labels.instance }}',
                },
              },
              {
                alert: 'PromScrapeTooLong',
                expr: |||
                  scrape_duration_seconds > 60
                |||,
                'for': '15m',
                labels: {
                  severity: 'warning',
                },
                annotations: {
                  message: '{{ $labels.job }} / {{ $labels.instance }} is taking too long to scrape ({{ printf "%.1f" $value }}s)',
                },
              },
            ],
          },
        ],
      },
    },
  },

  local configMap = k.core.v1.configMap,
  prometheus_config_maps_mixins+: [
    local mixin = $.mixins[mixinName] {
      prometheusAlerts+:: {},
      prometheusRules+:: {},
    };
    local prometheusAlerts = mixin.prometheusAlerts;
    local prometheusRules = mixin.prometheusRules;
    configMap.new('%s-%s-mixin' % [_config.name, mixinName])
    + configMap.withData({
      'alerts.rules': k.util.manifestYaml(prometheusAlerts),
      'recording.rules': k.util.manifestYaml(prometheusRules),
    })
    for mixinName in std.objectFields($.mixins)
  ],

  prometheus_config+: {
    rule_files+:
      std.foldr(
        function(mixinName, acc)
          acc + [
            'mixins/%s/alerts.rules' % mixinName,
            'mixins/%s/recording.rules' % mixinName,
          ],
        std.objectFields($.mixins),
        []
      ),
  },

  prometheus_config_mount+::
    std.foldr(
      function(mixinName, acc)
        acc
        + k.util.configMapVolumeMount(
          '%s-%s-mixin' % [_config.name, mixinName],
          '%s/mixins/%s' % [_config.prometheus_config_dir, mixinName]
        ),
      std.objectFields($.mixins),
      {}
    ),
}
