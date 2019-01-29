{
  histogramRules(metric, labels)::
    local vars = {
      metric: metric,
      labels_underscore: std.join('_', labels),
      labels_comma: std.join(', ', labels),
    };
    [
      {
        record: '%(labels_underscore)s:%(metric)s:99quantile' % vars,
        expr: 'histogram_quantile(0.99, sum(rate(%(metric)s_bucket[1m])) by (le, %(labels_comma)s))' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s:50quantile' % vars,
        expr: 'histogram_quantile(0.50, sum(rate(%(metric)s_bucket[1m])) by (le, %(labels_comma)s))' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s:avg' % vars,
        expr: 'sum(rate(%(metric)s_sum[1m])) by (%(labels_comma)s) / sum(rate(%(metric)s_count[1m])) by (%(labels_comma)s)' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s_bucket:sum_rate' % vars,
        expr: 'sum(rate(%(metric)s_bucket[1m])) by (le, %(labels_comma)s)' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s_sum:sum_rate' % vars,
        expr: 'sum(rate(%(metric)s_sum[1m])) by (%(labels_comma)s)' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s_count:sum_rate' % vars,
        expr: 'sum(rate(%(metric)s_count[1m])) by (%(labels_comma)s)' % vars,
      },
    ],


  // latencyRecordingRulePanel - build a latency panel for a recording rule.
  // - metric: the base metric name (middle part of recording rule name)
  // - selectors: list of selectors which will be added to first part of
  //   recording rule name, and to the query selector itself.
  // - extra_selectors (optional): list of selectors which will be added to the
  //   query selector, but not to the beginnig of the recording rule name.
  //   Useful for external labels.
  // - multiplier (optional): assumes results are in seconds, will multiply
  //   by 1e3 to get ms.  Can be turned off.
  latencyRecordingRulePanel(metric, selectors, extra_selectors=[], multiplier='1e3')::
    local labels = std.join('_', [matcher.label for matcher in selectors]);
    local selectorStr = $.toPrometheusSelector(selectors + extra_selectors);
    {
      nullPointMode: 'null as zero',
      yaxes: $.yaxes('ms'),
      targets: [
        {
          expr: 'histogram_quantile(0.99, sum by (le) (%(labels)s:%(metric)s_bucket:sum_rate%(selector)s)) * %(multiplier)s' % {
            labels: labels,
            metric: metric,
            selector: selectorStr,
            multiplier: multiplier,
          },
          format: 'time_series',
          intervalFactor: 2,
          legendFormat: '99th Percentile',
          refId: 'A',
          step: 10,
        },
        {
          expr: 'histogram_quantile(0.50, sum by (le) (%(labels)s:%(metric)s_bucket:sum_rate%(selector)s)) * %(multiplier)s' % {
            labels: labels,
            metric: metric,
            selector: selectorStr,
            multiplier: multiplier,
          },
          format: 'time_series',
          intervalFactor: 2,
          legendFormat: '50th Percentile',
          refId: 'B',
          step: 10,
        },
        {
          expr: '%(multiplier)s * sum(%(labels)s:%(metric)s_sum:sum_rate%(selector)s) / sum(%(labels)s:%(metric)s_count:sum_rate%(selector)s)' % {
            labels: labels,
            metric: metric,
            selector: selectorStr,
            multiplier: multiplier,
          },
          format: 'time_series',
          intervalFactor: 2,
          legendFormat: 'Average',
          refId: 'C',
          step: 10,
        },
      ],
    },
}
