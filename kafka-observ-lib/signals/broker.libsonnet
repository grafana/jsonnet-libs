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
    },
    signals: {
      brokerMessagesInPerSec: {
        name: 'Broker messages in',
        description: 'Broker messages in.',
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            legendCustomTemplate: '{{ %s }}: messages in' % this.instanceLabels[0],
            expr: 'kafka_server_brokertopicmetrics_messagesin_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            legendCustomTemplate: '{{ %s }}: messages in' % this.instanceLabels[0],
            expr: 'kafka_server_brokertopicmetrics_messagesinpersec{%(queriesSelector)s}',
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
            legendCustomTemplate: '{{ %s }}: bytes in' % this.instanceLabels[0],
            expr: 'kafka_server_brokertopicmetrics_bytesinpersec_count{%(queriesSelector)s}',
          },
          grafanacloud: {
            legendCustomTemplate: '{{ %s }}: bytes in' % this.instanceLabels[0],
            expr: 'kafka_server_brokertopicmetrics_bytesinpersec{%(queriesSelector)s}',
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
            legendCustomTemplate: '{{ %s }}: bytes out' % this.instanceLabels[0],
            expr: 'kafka_server_brokertopicmetrics_bytesoutpersec_count{%(queriesSelector)s}',
          },
          grafanacloud: {
            legendCustomTemplate: '{{ %s }}: bytes out' % this.instanceLabels[0],
            expr: 'kafka_server_brokertopicmetrics_bytesoutpersec{%(queriesSelector)s}',
          },
        },
      },


    },
  }
