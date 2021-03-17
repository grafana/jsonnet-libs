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

  // Legacy Extension points for adding alerts, recording rules and prometheus config.
  local emptyMixin = {
    prometheusAlerts+:: {},
    prometheusRules+:: {},
  },

  withMixinsConfigmaps(mixins):: {
    local configMap = k.core.v1.configMap,
    prometheus_config_maps_mixins+: [
      local mixin = mixins[mixinName] + emptyMixin;
      local prometheusAlerts = mixin.prometheusAlerts;
      local prometheusRules = mixin.prometheusRules;
      configMap.new(
        std.strReplace('%s-%s-mixin' % [_config.name, mixinName], '_', '-')
      )
      + configMap.withData({
        'alerts.rules': k.util.manifestYaml(prometheusAlerts),
        'recording.rules': k.util.manifestYaml(prometheusRules),
      })
      for mixinName in std.objectFields(mixins)
    ],

    prometheus_config+: {
      rule_files+:
        std.foldr(
          function(mixinName, acc)
            acc + [
              '%s/mixins/%s/alerts.rules' % [_config.prometheus_config_dir, mixinName],
              '%s/mixins/%s/recording.rules' % [_config.prometheus_config_dir, mixinName],
            ],
          std.objectFields(mixins),
          []
        ),
    },

    prometheus_config_mount+::
      std.foldr(
        function(mixinName, acc)
          acc
          + k.util.configVolumeMount(
            std.strReplace('%s-%s-mixin' % [_config.name, mixinName], '_', '-'),
            '%s/mixins/%s' % [_config.prometheus_config_dir, mixinName]
          ),
        std.objectFields(mixins),
        {}
      ),
  },

  // Extends legacy extension points with the mixins object, adding
  // the alerts and recording rules to root-level. This functions
  // should be applied if you want to retain the legacy behavior.
  withMixinsLegacyConfigmaps(mixins):: {
    prometheusAlerts+::
      std.foldr(
        function(mixinName, acc)
          local mixin = mixins[mixinName] + emptyMixin;
          acc + mixin.prometheusAlerts,
        std.objectFields(mixins),
        {}
      ),

    prometheusRules+::
      std.foldr(
        function(mixinName, acc)
          local mixin = mixins[mixinName] + emptyMixin;
          acc + mixin.prometheusRules,
        std.objectFields(mixins),
        {},
      ),
  },
}
