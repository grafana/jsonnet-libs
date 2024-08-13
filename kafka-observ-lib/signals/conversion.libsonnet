local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'kafka_server_brokertopicmetrics_producemessageconversions_total',
      grafanacloud: 'kafka_server_brokertopicmetrics_producemessageconversionspersec',
    },
    signals: {
      producerConversion: {
        name: 'Message conversion (producer)',
        description: 'The number of messages produced converted to match the log.message.format.version.',
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'kafka_server_brokertopicmetrics_producemessageconversions_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'kafka_server_brokertopicmetrics_producemessageconversionspersec{%(queriesSelector)s}',
          },
        },
      },
      consumerConversion: {
        name: 'Message conversion (consumer)',
        description: 'The number of messages consumed converted at consumer to match the log.message.format.version.',
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'kafka_server_brokertopicmetrics_fetchmessageconversions_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'kafka_server_brokertopicmetrics_fetchmessageconversionspersec{%(queriesSelector)s}',
          },
        },
      },
    },
  }
