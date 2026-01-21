local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: ('quantile="%s"' % this.zookeeperClientQuantile) + ',' + this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'kafka_server_zookeeperclientmetrics_zookeeperrequestlatencyms',
      grafanacloud: self.prometheus,
      bitnami: 'kafka_server_zookeeperclientmetrics_zookeeperrequestlatencyms_count',
    },
    signals: {
      zookeeperRequestLatency: {
        name: 'Zookeeper request latency',
        description: |||
          Latency in milliseconds for ZooKeeper requests from broker to ZooKeeper ensemble.  
          High latency indicates ZooKeeper performance issues or network problems.  
          Critical for broker operations like leader election and metadata updates.
        |||,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_server_zookeeperclientmetrics_zookeeperrequestlatencyms{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_server_zookeeperclientmetrics_zookeeperrequestlatencyms_count{%(queriesSelector)s}',
          },
        },
      },
      zookeeperConnections: {
        name: 'Zookeeper connections',
        description: |||
          Rate of successful ZooKeeper connections established by broker.  
          Frequent connections may indicate session instability or network issues.  
          Should be stable in healthy clusters with occasional reconnections during maintenance.
        |||,
        type: 'counter',
        unit: 'short',
        optional: true,
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
        description: |||
          Rate of ZooKeeper session expirations from broker.  
          Expirations cause broker to lose cluster membership temporarily.  
          Indicates GC pauses, network issues, or ZooKeeper overload requiring investigation.
        |||,
        type: 'counter',
        unit: 'short',
        optional: true,
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
        description: |||
          Rate of ZooKeeper disconnections from broker.  
          Frequent disconnects indicate unstable ZooKeeper connectivity or network problems.  
          Can lead to ISR changes and performance degradation if persistent.
        |||,
        type: 'counter',
        unit: 'short',
        optional: true,
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
        description: |||
          Rate of ZooKeeper authentication failures from broker.  
          Indicates incorrect credentials, ACL issues, or security configuration problems.  
          Prevents broker from accessing ZooKeeper data and requires immediate security review.
        |||,
        type: 'counter',
        unit: 'short',
        optional: true,
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
