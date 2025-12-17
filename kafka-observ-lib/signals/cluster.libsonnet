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
      prometheus: 'kafka_server_brokertopicmetrics_messagesin_total',
      grafanacloud: 'kafka_server_brokertopicmetrics_messagesinpersec',
      bitnami: 'kafka_server_brokertopicmetrics_messagesinpersec_count',
    },
    signals: {
      activeControllers: {
        name: 'Active kafka controllers',
        description: |||
          Number of active controllers in the cluster. Should always be exactly 1.  
          Zero indicates no controller elected, preventing cluster operations.  
          More than one indicates split-brain requiring immediate attention.
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
          Broker's current controller role: 0 indicates follower, 1 indicates active controller.  
          Only one broker should have value 1 at any time.  
          Used to identify which broker is managing cluster metadata and leadership.
          Current controller role: 0 - follower, 1 - controller.
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
      kraftBrokerRole: {
        name: 'Current role (kraft)',
        description: |||
          Broker state in KRaft mode (Kafka without ZooKeeper).  
          Any value indicates the broker is running in KRaft mode.  
          Used to identify KRaft-enabled brokers in the cluster.
        |||,
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          grafanacloud:
            {
              //metric from kafka_exporter
              expr: 'kafka_server_kafkaserver_brokerstate{%(queriesSelector)s}',
              legendCustomTemplate: '{{ %s }}' % xtd.array.slice(this.instanceLabels, -1),
              aggKeepLabels: this.instanceLabels,
              valueMappings: [
                {
                  type: 'range',
                  options: {
                    from: 0,
                    to: 999,
                    result: {
                      text: 'broker(kraft)',
                      color: 'green',
                      index: 0,
                    },
                  },
                },
              ],
            },
          prometheus:
            self.grafanacloud,
          bitnami:
            self.grafanacloud,
        },
      },
      brokersCount: {
        name: 'Brokers count',
        description: |||
          Total number of active brokers currently registered and reporting in the cluster.  
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
              expr: 'kafka_server_kafkaserver_total_brokerstate_value{%(queriesSelector)s}',
            },
        },
      },

      clusterMessagesInPerSec: {
        name: 'Cluster messages in',
        description: |||
          Aggregate rate of incoming messages across all brokers and topics in the cluster.  
          Represents total producer throughput and write workload.  
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
      clusterBytesInPerSec: {
        name: 'Cluster bytes in',
        description: |||
          Aggregate rate of incoming data in bytes across all brokers from producers.  
          Measures total network ingress and storage write load.  
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
      clusterBytesOutPerSec: {
        name: 'Cluster bytes out',
        description: |||
          Aggregate rate of outgoing data in bytes across all brokers to consumers and followers.  
          Measures total network egress load and consumer throughput.  
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
