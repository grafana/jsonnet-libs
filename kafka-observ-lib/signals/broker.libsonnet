local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'kafka_controller_kafkacontroller_activecontrollercount',
      grafanacloud: 'kafka_controller_kafkacontroller_activecontrollercount',
      bitnami: 'kafka_controller_kafkacontroller_activecontrollercount_value',
    },
    signals: {
      brokerMessagesInPerSec: {
        name: 'Broker messages in',
        description: 'Broker messages in.',
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
        description: 'Broker bytes in rate.',
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
        description: 'Broker bytes out rate.',
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
            expr: 'kafka_server_brokertopicmetrics_bytesoutpersec_count{%(queriesSelector)s}'
          }
        },
      },


    },
  }
