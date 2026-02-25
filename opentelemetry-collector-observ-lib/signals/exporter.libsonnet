local common = import './common.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';


function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    signals: {
      count: {
        name: 'Exporter count',
        description: 'Total number of exporters',
        type: 'raw',
        unit: 'short',
        sources: {
          otelcol: {
            legendCustomTemplate: 'Exporters',
            expr: |||
              count(count by (exporter) (otelcol_exporter_queue_size{%(queriesSelector)s}))
            |||,
          },
        },
      },
      queueSizeByExporter: {
        name: 'Queue size by exporter',
        description: 'Indicates the current size of the sending queue',
        type: 'gauge',
        unit: 'short',
        sources: {
          otelcol: {
            aggKeepLabels: ['exporter'],
            expr: 'otelcol_exporter_queue_size{%(queriesSelector)s}',
          },
        },
      },
      queueCapacityByExporter: {
        name: 'Queue capacity by exporter',
        description: 'Indicates the maximum number of elements in the exporting queue',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'avg',
        sources: {
          otelcol: {
            aggKeepLabels: ['exporter'],
            expr: 'otelcol_exporter_queue_capacity{%(queriesSelector)s}',
          },
        },
      },
      saturationByCollector: {
        name: 'Queue saturation',
        description: 'Describes how full the sending queue is for a given collector',
        type: 'raw',
        unit: 'percentunit',
        sources: {
          otelcol: {
            legendCustomTemplate: '{{ service_instance_id }} saturation',
            expr: 'max(otelcol_exporter_queue_size{%(queriesSelector)s} / otelcol_exporter_queue_capacity{%(queriesSelector)s}) by (service_instance_id)',
          },
        },
      },
    } + std.foldl(
      function(acc, signal)
        acc {
          [signal.plural]: {
            name: signal.capitalized,
            description: 'Total rate of %(plural)s exported' % signal,
            type: 'counter',
            unit: 'cps',
            sources: {
              otelcol: {
                legendCustomTemplate: signal.capitalized,
                expr: 'otelcol_exporter_sent_' + signal.metric_id + '_total{%(queriesSelector)s}',
              },
            },
          },

          ['%(plural)sSuccessRate' % signal]: {
            name: 'Success rate',
            description: 'Proportion of successfully exported %(plural)s against total %(plural)s' % signal,
            type: 'raw',
            unit: 'percentunit',
            sources: {
              otelcol: {
                legendCustomTemplate: '%(capitalized) success rate' % signal,
                expr: |||
                  sum(rate(otelcol_exporter_sent_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                  /
                  (
                  sum(rate(otelcol_exporter_sent_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s]))
                  +
                  (sum(rate(otelcol_exporter_send_failed_%(metric_id)s_total{%%(queriesSelector)s}[%%(interval)s])) or vector(0))
                  )
                ||| % signal,
              },
            },
          },
          ['%(plural)sByExporter' % signal]: {
            name: 'Exported %(plural)s' % signal,
            description: 'Total rate of exported %(plural)s' % signal,
            type: 'counter',
            unit: 'cps',
            sources: {
              otelcol: {
                aggKeepLabels: ['exporter'],
                exprWrappers: [['', 'or (count by (exporter) ({exporter!="",%(queriesSelector)s})*0)']],
                expr: 'otelcol_exporter_sent_' + signal.metric_id + '_total{%(queriesSelector)s}',
              },
            },
          },
          ['%(plural)sFailedByExporter' % signal]: {
            name: '%(capitalized)s export failure rate' % signal,
            description: 'Total rate of %(plural)s that failed to export' % signal,
            type: 'counter',
            unit: 'cps',
            sources: {
              otelcol: {
                aggKeepLabels: ['exporter'],
                exprWrappers: [['', 'or (count by (exporter) ({exporter!="",%(queriesSelector)s})*0)']],
                expr: 'otelcol_exporter_send_failed_' + signal.metric_id + '_total{%(queriesSelector)s}',
              },
            },
          },
          ['enqueue%(capitalized)sFailedByExporter' % signal]: {
            name: '%(capitalized)s enqueue failures' % signal,
            description: 'Total rate of %(plural)s that failed to be added to the exporter sending queue' % signal,
            type: 'counter',
            unit: 'cps',
            sources: {
              otelcol: {
                aggKeepLabels: ['exporter'],
                exprWrappers: [['', 'or (count by (exporter) ({exporter!="",%(queriesSelector)s})*0)']],
                expr: 'otelcol_exporter_enqueue_failed_' + signal.metric_id + '_total{%(queriesSelector)s}',
              },
            },
          },
        },
      common.signalTypes,
      {}
    ),
  }
