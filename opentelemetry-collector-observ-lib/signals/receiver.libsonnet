local common = import './common.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local emptyReceiverQuery = |||
  or
  (
    count by (receiver) ({%(queriesSelector)s,receiver!=""}) * 0
  )
|||;


function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      otelcol: 'otelcol_process_uptime_seconds_total',
    },
    signals: {
      count: {
        name: 'Receiver count',
        description: 'Total number of receivers',
        type: 'raw',
        unit: 'short',
        sources: {
          otelcol: {
            legendCustomTemplate: 'Receivers',
            expr: |||
              count(count by (receiver) ({__name__=~"otelcol_receiver_(accepted|refused)_(log_records|metric_points|spans)_total",%(queriesSelector)s}))
            |||,
          },
        },
      },
    } + std.foldl(
      function(acc, signal)
        acc {
          [signal.plural]: {
            name: signal.capitalized,
            description: 'Total rate of %(plural)s received (incl. failed)' % signal,
            type: 'raw',
            unit: 'cps',
            sources: {
              otelcol: {
                legendCustomTemplate: signal.capitalized,
                expr: |||
                  sum (rate(otelcol_receiver_accepted_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                  + sum (rate(otelcol_receiver_refused_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                ||| % signal,
              },
            },
          },
          ['%(plural)sSuccessRate' % signal]: {
            name: 'Success rate',
            description: 'Proportion of successfully ingested %(plural)s against total received metrics' % signal,
            type: 'raw',
            unit: 'percentunit',
            sources: {
              otelcol: {
                legendCustomTemplate: '%(capitalized) success rate' % signal,
                expr: |||
                  sum(rate(otelcol_receiver_accepted_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                  /
                  (
                  sum(rate(otelcol_receiver_accepted_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                  +
                  sum(rate(otelcol_receiver_refused_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                  )
                ||| % signal,
              },
            },
          },
          ['%(plural)sByReceiver' % signal]: {
            name: 'Ingested %(plural)s' % signal,
            description: 'Total rate of %(plural)s received per receiver' % signal,
            type: 'raw',
            unit: 'cps',
            sources: {
              otelcol: {
                legendCustomTemplate: '{{ receiver }} %(plural)s' % signal,
                expr: (|||
                         (
                           sum by (receiver) (rate(otelcol_receiver_accepted_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                           + sum by (receiver) (rate(otelcol_receiver_refused_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                         )
                         or
                         (
                           sum by (receiver) (rate(otelcol_receiver_accepted_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                           unless sum by (receiver) (rate(otelcol_receiver_refused_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                         )
                         or
                         (
                           sum by (receiver) (rate(otelcol_receiver_refused_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                           unless sum by (receiver) (rate(otelcol_receiver_accepted_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                         )
                       ||| % signal) + emptyReceiverQuery,
              },
            },
          },
          ['%(plural)sRefusalByReceiver' % signal]: {
            name: '%(capitalized)s refusal rate' % signal,
            description: 'Rate of %(plural)s refused' % signal,
            type: 'raw',
            unit: 'cps',
            sources: {
              otelcol: {
                aggKeepLabels: ['receiver'],
                expr: ('sum by (receiver) (rate(otelcol_receiver_refused_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))' % signal) + emptyReceiverQuery,
              },
            },
          },
        },
      common.signalTypes,
      {}
    ),

  }
