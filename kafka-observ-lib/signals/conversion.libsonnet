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
      bitnami: 'kafka_server_brokertopicmetrics_total_producemessageconversionspersec_count',
    },
    signals: {
      producerConversion: {
        name: 'Message conversion (producer)',
        description: |||
          Rate of producer messages requiring format conversion to match broker's log.message.format.version.  
          Conversions add CPU overhead and latency.  
          Non-zero values suggest producer and broker version mismatches requiring alignment.
        |||,
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'kafka_server_brokertopicmetrics_producemessageconversions_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'kafka_server_brokertopicmetrics_producemessageconversionspersec{%(queriesSelector)s}',
          },
          bitnami: {
            expr: 'kafka_server_brokertopicmetrics_producemessageconversionspersec_count{%(queriesSelector)s}',
          },
        },
      },
      consumerConversion: {
        name: 'Message conversion (consumer)',
        description: |||
          Rate of messages requiring format conversion during consumer fetch to match log.message.format.version.  
          Conversions impact broker CPU and consumer latency.  
          Indicates version mismatch between stored messages and consumer expectations.
        |||,
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'kafka_server_brokertopicmetrics_fetchmessageconversions_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'kafka_server_brokertopicmetrics_fetchmessageconversionspersec{%(queriesSelector)s}',
          },
          bitnami: {
            expr: 'kafka_server_brokertopicmetrics_fetchmessageconversionspersec_count{%(queriesSelector)s}',
          },
        },
      },
    },
  }
