local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector + ', quantile="%s"' % this.zookeeperClientQuantile,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'kafka_server_zookeeperclientmetrics_zookeeperrequestlatencyms',
      grafanacloud: self.prometheus,
    },
    signals: {
      zookeeperRequestLatency: {
        name: 'Zookeeper request latency',
        description: 'Latency in millseconds for ZooKeeper requests from broker.',
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_server_zookeeperclientmetrics_zookeeperrequestlatencyms{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
        },
      },
      zookeeperConnections: {
        name: 'Zookeeper connections',
        description: 'Zookeeper connections rate.',
        type: 'counter',
        unit: 'short',
        sources: {
          grafanacloud: {
            expr: 'kafka_server_sessionexpirelistener_zookeepersyncconnectspersec{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'kafka_server_sessionexpirelistener_zookeepersyncconnects_total{%(queriesSelector)s}',
          },
        },
      },
      zookeeperExpiredConnections: {
        name: 'Zookeeper expired connections',
        description: 'Zookeeper expired connections rate.',
        type: 'counter',
        unit: 'short',
        sources: {
          grafanacloud: {
            expr: 'kafka_server_sessionexpirelistener_zookeeperexpirespersec{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'kafka_server_sessionexpirelistener_zookeeperexpires_total{%(queriesSelector)s}',
          },
        },
      },
      zookeeperDisconnects: {
        name: 'Zookeeper disconnects',
        description: 'Zookeeper disconnects rate.',
        type: 'counter',
        unit: 'short',
        sources: {
          grafanacloud: {
            expr: 'kafka_server_sessionexpirelistener_zookeeperdisconnectspersec{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'kafka_server_sessionexpirelistener_zookeeperdisconnects_total{%(queriesSelector)s}',
          },
        },
      },
      zookeeperAuthFailures: {
        name: 'Zookeeper auth failures',
        description: 'Zookeeper auth failures from Kafka.',
        type: 'counter',
        unit: 'short',
        sources: {
          grafanacloud: {
            expr: 'kafka_server_sessionexpirelistener_zookeeperauthfailurespersec{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'kafka_server_sessionexpirelistener_zookeeperauthfailures_total{%(queriesSelector)s}',
          },
        },
      },


    },
  }
