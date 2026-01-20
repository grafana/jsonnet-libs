local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'kafka_server_brokertopicmetrics_messagesin_total',
      grafanacloud: 'kafka_server_brokertopicmetrics_messagesinpersec',
      bitnami: 'kafka_server_brokertopicmetrics_messagesinpersec_count',
    },
    signals: {
      brokerMessagesInPerSec: {
        name: 'Broker messages in',
        description: |||
          Rate of incoming messages published to this broker across all topics.  
          Tracks producer throughput and write workload.  
        |||,
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            expr: 'kafka_server_brokertopicmetrics_messagesin_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'kafka_server_brokertopicmetrics_messagesinpersec{%(queriesSelector)s}',
          },
          bitnami: {
            expr: 'kafka_server_brokertopicmetrics_messagesinpersec_count{%(queriesSelector)s}',
          },
        },
      },
      brokerBytesInPerSec: {
        name: 'Broker bytes in',
        description: |||
          Rate of incoming data in bytes published to this broker from producers.  
          Measures network and storage write load.  
        |||,
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'kafka_server_brokertopicmetrics_bytesin_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'kafka_server_brokertopicmetrics_bytesinpersec{%(queriesSelector)s}',
          },
          bitnami: {
            expr: 'kafka_server_brokertopicmetrics_bytesinpersec_count{%(queriesSelector)s}',
          },
        },
      },
      brokerBytesOutPerSec: {
        name: 'Broker bytes out',
        description: |||
          Rate of outgoing data in bytes sent from this broker to consumers and followers.  
          Measures network read load and consumer throughput.  
        |||,
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'kafka_server_brokertopicmetrics_bytesout_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'kafka_server_brokertopicmetrics_bytesoutpersec{%(queriesSelector)s}',
          },
          bitnami: {
            expr: 'kafka_server_brokertopicmetrics_bytesoutpersec_count{%(queriesSelector)s}',
          },
        },
      },
    },
  }
