local g = import 'grafana-builder/grafana.libsonnet';

{
  // The classicNativeHistogramQuantile function is used to calculate histogram quantiles from native histograms or classic histograms.
  // Metric name should be provided without _bucket suffix.
  nativeClassicHistogramQuantile(percentile, metric, selector, sum_by=[], rate_interval='$__rate_interval', multiplier='')::
    local classicSumBy = if std.length(sum_by) > 0 then ' by (%(lbls)s) ' % { lbls: std.join(',', ['le'] + sum_by) } else ' by (le) ';
    local nativeSumBy = if std.length(sum_by) > 0 then ' by (%(lbls)s) ' % { lbls: std.join(',', sum_by) } else ' ';
    local multiplierStr = if multiplier == '' then '' else ' * %s' % multiplier;
    {
      classic: 'histogram_quantile(%(percentile)s, sum%(classicSumBy)s(rate(%(metric)s_bucket{%(selector)s}[%(rateInterval)s])))%(multiplierStr)s' % {
        classicSumBy: classicSumBy,
        metric: metric,
        multiplierStr: multiplierStr,
        percentile: percentile,
        rateInterval: rate_interval,
        selector: selector,
      },
      native: 'histogram_quantile(%(percentile)s, sum%(nativeSumBy)s(rate(%(metric)s{%(selector)s}[%(rateInterval)s])))%(multiplierStr)s' % {
        metric: metric,
        multiplierStr: multiplierStr,
        nativeSumBy: nativeSumBy,
        percentile: percentile,
        rateInterval: rate_interval,
        selector: selector,
      },
    },

  // The classicNativeHistogramSumRate function is used to calculate the histogram sum of rate from native histograms or classic histograms.
  // Metric name should be provided without _sum suffix.
  nativeClassicHistogramSumRate(metric, selector, rate_interval='$__rate_interval')::
    {
      classic: 'rate(%(metric)s_sum{%(selector)s}[%(rateInterval)s])' % {
        metric: metric,
        rateInterval: rate_interval,
        selector: selector,
      },
      native: 'histogram_sum(rate(%(metric)s{%(selector)s}[%(rateInterval)s]))' % {
        metric: metric,
        rateInterval: rate_interval,
        selector: selector,
      },
    },


  // The classicNativeHistogramCountRate function is used to calculate the histogram count of rate from native histograms or classic histograms.
  // Metric name should be provided without _count suffix.
  nativeClassicHistogramCountRate(metric, selector, rate_interval='$__rate_interval')::
    {
      classic: 'rate(%(metric)s_count{%(selector)s}[%(rateInterval)s])' % {
        metric: metric,
        rateInterval: rate_interval,
        selector: selector,
      },
      native: 'histogram_count(rate(%(metric)s{%(selector)s}[%(rateInterval)s]))' % {
        metric: metric,
        rateInterval: rate_interval,
        selector: selector,
      },
    },

  // TODO(krajorama) Switch to histogram_avg function for native histograms later.
  nativeClassicHistogramAverageRate(metric, selector, rate_interval='$__rate_interval', multiplier='')::
    local multiplierStr = if multiplier == '' then '' else '%s * ' % multiplier;
    {
      classic: |||
        %(multiplier)ssum(%(sumMetricQuery)s) /
        sum(%(countMetricQuery)s)
      ||| % {
        sumMetricQuery: $.nativeClassicHistogramSumRate(metric, selector, rate_interval).classic,
        countMetricQuery: $.nativeClassicHistogramCountRate(metric, selector, rate_interval).classic,
        multiplier: multiplierStr,
      },
      native: |||
        %(multiplier)ssum(%(sumMetricQuery)s) /
        sum(%(countMetricQuery)s)
      ||| % {
        sumMetricQuery: $.nativeClassicHistogramSumRate(metric, selector, rate_interval).native,
        countMetricQuery: $.nativeClassicHistogramCountRate(metric, selector, rate_interval).native,
        multiplier: multiplierStr,
      },
    },

  // showClassicHistogramQuery wraps a query defined as map {classic: q, native: q}, and compares the classic query
  // to dashboard variable which should take -1 or +1 as values in order to hide or show the classic query.
  showClassicHistogramQuery(query, dashboard_variable='latency_metrics'):: '%s < ($%s * +Inf)' % [query.classic, dashboard_variable],
  // showNativeHistogramQuery wraps a query defined as map {classic: q, native: q}, and compares the native query
  // to dashboard variable which should take -1 or +1 as values in order to show or hide the native query.
  showNativeHistogramQuery(query, dashboard_variable='latency_metrics'):: '%s < ($%s * -Inf)' % [query.native, dashboard_variable],

  histogramRules(metric, labels, interval='1m', record_native=false)::
    local vars = {
      metric: metric,
      labels_underscore: std.join('_', labels),
      labels_comma: std.join(', ', labels),
      interval: interval,
    };
    [
      {
        record: '%(labels_underscore)s:%(metric)s:99quantile' % vars,
        expr: 'histogram_quantile(0.99, sum(rate(%(metric)s_bucket[%(interval)s])) by (le, %(labels_comma)s))' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s:50quantile' % vars,
        expr: 'histogram_quantile(0.50, sum(rate(%(metric)s_bucket[%(interval)s])) by (le, %(labels_comma)s))' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s:avg' % vars,
        expr: 'sum(rate(%(metric)s_sum[1m])) by (%(labels_comma)s) / sum(rate(%(metric)s_count[%(interval)s])) by (%(labels_comma)s)' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s_bucket:sum_rate' % vars,
        expr: 'sum(rate(%(metric)s_bucket[%(interval)s])) by (le, %(labels_comma)s)' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s_sum:sum_rate' % vars,
        expr: 'sum(rate(%(metric)s_sum[%(interval)s])) by (%(labels_comma)s)' % vars,
      },
      {
        record: '%(labels_underscore)s:%(metric)s_count:sum_rate' % vars,
        expr: 'sum(rate(%(metric)s_count[%(interval)s])) by (%(labels_comma)s)' % vars,
      },
    ] + if record_native then [
      // Native histogram rule, sum_rate contains the following information:
      // - rate of sum,
      // - rate of count,
      // - rate of sum/count aka average,
      // - rate of buckets,
      // - implicitly the quantile information.
      {
        record: '%(labels_underscore)s:%(metric)s:sum_rate' % vars,
        expr: 'sum(rate(%(metric)s[%(interval)s])) by (%(labels_comma)s)' % vars,
      },
    ] else [],


  // latencyRecordingRulePanel - build a latency panel for a recording rule.
  // - metric: the base metric name (middle part of recording rule name)
  // - selectors: list of selectors which will be added to first part of
  //   recording rule name, and to the query selector itself.
  // - extra_selectors (optional): list of selectors which will be added to the
  //   query selector, but not to the beginnig of the recording rule name.
  //   Useful for external labels.
  // - multiplier (optional): assumes results are in seconds, will multiply
  //   by 1e3 to get ms.  Can be turned off.
  // - sum_by (optional): additional labels to use in the sum by clause, will also be used in the legend
  latencyRecordingRulePanel(metric, selectors, extra_selectors=[], multiplier='1e3', sum_by=[])::
    local labels = std.join('_', [matcher.label for matcher in selectors]);
    local selectorStr = $.toPrometheusSelector(selectors + extra_selectors);
    local sb = ['le'];
    local legend = std.join('', ['{{ %(lb)s }} ' % lb for lb in sum_by]);
    local sumBy = if std.length(sum_by) > 0 then ' by (%(lbls)s) ' % { lbls: std.join(',', sum_by) } else '';
    local sumByHisto = std.join(',', sb + sum_by);
    {
      nullPointMode: 'null as zero',
      yaxes: g.yaxes('ms'),
      targets: [
        {
          expr: 'histogram_quantile(0.99, sum by (%(sumBy)s) (%(labels)s:%(metric)s_bucket:sum_rate%(selector)s)) * %(multiplier)s' % {
            labels: labels,
            metric: metric,
            selector: selectorStr,
            multiplier: multiplier,
            sumBy: sumByHisto,
          },
          format: 'time_series',
          legendFormat: '%(legend)s99th percentile' % legend,
          refId: 'A',
        },
        {
          expr: 'histogram_quantile(0.50, sum by (%(sumBy)s) (%(labels)s:%(metric)s_bucket:sum_rate%(selector)s)) * %(multiplier)s' % {
            labels: labels,
            metric: metric,
            selector: selectorStr,
            multiplier: multiplier,
            sumBy: sumByHisto,
          },
          format: 'time_series',
          legendFormat: '%(legend)s50th percentile' % legend,
          refId: 'B',
        },
        {
          expr: '%(multiplier)s * sum(%(labels)s:%(metric)s_sum:sum_rate%(selector)s)%(sumBy)s / sum(%(labels)s:%(metric)s_count:sum_rate%(selector)s)%(sumBy)s' % {
            labels: labels,
            metric: metric,
            selector: selectorStr,
            multiplier: multiplier,
            sumBy: sumBy,
          },
          format: 'time_series',
          legendFormat: '%(legend)sAverage' % legend,
          refId: 'C',
        },
      ],
    },

  selector:: {
    eq(label, value):: { label: label, op: '=', value: value },
    neq(label, value):: { label: label, op: '!=', value: value },
    re(label, value):: { label: label, op: '=~', value: value },
    nre(label, value):: { label: label, op: '!~', value: value },

    // Use with latencyRecordingRulePanel to get the label in the metric name
    // but not in the selector.
    noop(label):: { label: label, op: 'nop' },
  },

  toPrometheusSelector(selector)::
    local pairs = [
      '%(label)s%(op)s"%(value)s"' % matcher
      for matcher in std.filter(function(matcher) matcher.op != 'nop', selector)
    ];
    '{%s}' % std.join(', ', pairs),

  // withRunbookURL - Add/Override the runbook_url annotations for all alerts inside a list of rule groups.
  // - url_format: an URL format for the runbook, the alert name will be substituted in the URL.
  // - groups: the list of rule groups containing alerts.
  // - annotation_key: the key to use for the annotation whose value will be the formatted runbook URL.
  withRunbookURL(url_format, groups, annotation_key='runbook_url')::
    local update_rule(rule) =
      if std.objectHas(rule, 'alert')
      then rule {
        annotations+: {
          [annotation_key]: url_format % rule.alert,
        },
      }
      else rule;
    [
      group {
        rules: [
          update_rule(alert)
          for alert in group.rules
        ],
      }
      for group in groups
    ],

  removeRuleGroup(ruleName):: {
    local removeRuleGroup(rule) = if rule.name == ruleName then null else rule,
    local currentRuleGroups = super.groups,
    groups: std.prune(std.map(removeRuleGroup, currentRuleGroups)),
  },

  removeAlertRuleGroup(ruleName):: {
    prometheusAlerts+:: $.removeRuleGroup(ruleName),
  },

  removeRecordingRuleGroup(ruleName):: {
    prometheusRules+:: $.removeRuleGroup(ruleName),
  },

  overrideAlerts(overrides):: {
    local overrideRule(rule) =
      if 'alert' in rule && std.objectHas(overrides, rule.alert)
      then rule + overrides[rule.alert]
      else rule,
    local overrideInGroup(group) = group { rules: std.map(overrideRule, super.rules) },
    prometheusAlerts+:: {
      groups: std.map(overrideInGroup, super.groups),
    },
  },

  removeAlerts(alerts):: {
    local removeRule(rule) =
      if 'alert' in rule && std.objectHas(alerts, rule.alert)
      then {}
      else rule,
    local removeInGroup(group) = group { rules: std.map(removeRule, super.rules) },
    prometheusAlerts+:: {
      groups: std.prune(std.map(removeInGroup, super.groups)),
    },
  },
}
