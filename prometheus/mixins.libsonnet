{
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

  prometheusAlerts::
    std.foldr(
      function(mixinName, acc)
        local mixin = $.mixins[mixinName] + emptyMixin;
        acc + mixin.prometheusAlerts,
      std.objectFields($.mixins),
      {}
    ),

  prometheusRules::
    std.foldr(
      function(mixinName, acc)
        local mixin = $.mixins[mixinName] + emptyMixin;
        acc + mixin.prometheusRules,
      std.objectFields($.mixins),
      {},
    ),
}
