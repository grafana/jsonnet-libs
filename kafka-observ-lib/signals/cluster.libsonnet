local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    // do not add instance selector at all for cluster wide metrics
    instanceLabels: [],
    aggLevel: 'group',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'kafka_controller_kafkacontroller_activecontrollercount',
      grafanacloud: 'kafka_controller_kafkacontroller_activecontrollercount',
    },
    signals: {
      activeControllers: {
        name: 'Active kafka controllers',
        description: |||
          Active kafka controllers count.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              expr: 'kafka_controller_kafkacontroller_activecontrollercount{%(queriesSelector)s}',
            },
          prometheus:
            {
              expr: 'kafka_controller_kafkacontroller_activecontrollercount{%(queriesSelector)s}',
            },
        },
      },
      // used in status map
      role: {
        name: 'Current role',
        description: |||
          0 - follower, 1 - controller.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              expr: 'kafka_controller_kafkacontroller_activecontrollercount{%(queriesSelector)s}',
              legendCustomTemplate: '{{ %s }}' % this.instanceLabels[0],
              aggKeepLabels: this.instanceLabels,
              valueMappings: [{
                type: 'value',
                options: {
                  '0': {
                    text: 'follower',
                    color: 'light-purple',
                    index: 0,
                  },
                  '1': {
                    text: 'controller',
                    color: 'light-blue',
                    index: 1,
                  },
                },
              }],
            },
          prometheus:
            {
              expr: 'kafka_controller_kafkacontroller_activecontrollercount{%(queriesSelector)s}',
              aggKeepLabels: this.instanceLabels,
              legendCustomTemplate: '{{ %s }}' % this.instanceLabels[0],
              valueMappings: [
                {
                  type: 'value',
                  options: {
                    '0': {
                      text: 'follower',
                      color: 'light-purple',
                      index: 0,
                    },
                    '1': {
                      text: 'controller',
                      color: 'light-blue',
                      index: 1,
                    },
                  },
                },
              ],
            },
        },
      },
      brokersCount: {
        name: 'Brokers count',
        description: |||
          Active brokers count.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'count',
        sources: {
          grafanacloud:
            {
              expr: 'kafka_server_kafkaserver_brokerstate{%(queriesSelector)s}',
            },
          prometheus:
            {
              expr: 'kafka_server_kafkaserver_brokerstate{%(queriesSelector)s}',
            },
        },
      },

      clusterMessagesInPerSec: {
        name: 'Cluster messages in',
        description: 'Cluster messages in.',
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            legendCustomTemplate: '%s: messages in' % commonlib.utils.labelsToPanelLegend(this.groupLabels),
            expr: 'kafka_server_brokertopicmetrics_messagesin_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            legendCustomTemplate: '%s: messages in' % commonlib.utils.labelsToPanelLegend(this.groupLabels),
            expr: 'kafka_server_brokertopicmetrics_messagesinpersec{%(queriesSelector)s}',
          },
        },
      },
      clusterBytesInPerSec: {
        name: 'Cluster bytes in',
        description: 'Cluster bytes in rate.',
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            legendCustomTemplate: '%s: bytes in' % commonlib.utils.labelsToPanelLegend(this.groupLabels),
            expr: 'kafka_server_brokertopicmetrics_bytesin_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            legendCustomTemplate: '%s: bytes in' % commonlib.utils.labelsToPanelLegend(this.groupLabels),
            expr: 'kafka_server_brokertopicmetrics_bytesinpersec{%(queriesSelector)s}',
          },
        },
      },
      clusterBytesOutPerSec: {
        name: 'Cluster bytes out',
        description: 'Cluster bytes out rate.',
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            legendCustomTemplate: '%s: bytes out' % commonlib.utils.labelsToPanelLegend(this.groupLabels),
            expr: 'kafka_server_brokertopicmetrics_bytesout_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            legendCustomTemplate: '%s: bytes out' % commonlib.utils.labelsToPanelLegend(this.groupLabels),
            expr: 'kafka_server_brokertopicmetrics_bytesoutpersec{%(queriesSelector)s}',
          },
        },
      },
    },
  }
