  local commonlib = import 'common-lib/common/main.libsonnet';
  local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
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
        bitnami: 'kafka_controller_kafkacontroller_activecontrollercount_value',
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
            bitnami:
              {
                expr: 'kafka_controller_kafkacontroller_activecontrollercount_value{%(queriesSelector)s}',
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
                legendCustomTemplate: '{{ %s }}' % xtd.array.slice(this.instanceLabels, -1),
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
                legendCustomTemplate: '{{ %s }}' % xtd.array.slice(this.instanceLabels, -1),
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
            bitnami:
              {
                expr: 'kafka_controller_kafkacontroller_activecontrollercount_value{%(queriesSelector)s}',
                aggKeepLabels: this.instanceLabels,
                legendCustomTemplate: '{{ %s }}' % xtd.array.slice(this.instanceLabels, -1),
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
              bitnami: 
              {
                expr: 'kafka_server_kafkaserver_total_brokerstate_value{%(queriesSelector)s}'
              }
          },
        },

        clusterMessagesInPerSec: {
          name: 'Cluster messages in',
          description: 'Cluster messages in.',
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
              expr: 'kafka_server_brokertopicmetrics_messagesinpersec_count{%(queriesSelector)s}'
            }
          },
        },
        clusterBytesInPerSec: {
          name: 'Cluster bytes in',
          description: 'Cluster bytes in rate.',
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
        clusterBytesOutPerSec: {
          name: 'Cluster bytes out',
          description: 'Cluster bytes out rate.',
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
