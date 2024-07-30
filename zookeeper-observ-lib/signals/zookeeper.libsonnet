local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'outstanding_requests',
      grafanacloud: 'zookeeper_outstandingrequests',
    },
    signals: {
      znodes: {
        name: 'znodes count',
        description: 'Number of znodes.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'znode_count{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'zookeeper_inmemorydatatree_nodecount{%(queriesSelector)s}',
          },
        },

      },

      outstandingRequests: {
        name: 'Outstanding requests',
        description: 'Outstanding requests to ZooKeeper cluster.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            expr: 'outstanding_requests{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'zookeeper_outstandingrequests{%(queriesSelector)s}',
          },
        },
      },
      aliveConnections: {
        name: 'Alive connections',
        description: 'Number of alive connections.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'num_alive_connections{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'zookeeper_numaliveconnections{%(queriesSelector)s}',
          },
        },
      },
      watchers: {
        name: 'Watchers',
        description: 'Number of watchers.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          grafanacloud: {
            expr: 'zookeeper_inmemorydatatree_watchcount{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'watch_count{%(queriesSelector)s}',
          },
        },
      },
      quorumSize: {
        name: 'Quorum size',
        description: 'Quorum size of ZooKeeper ensemble.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          prometheus: {
            expr: 'quorum_size{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: 'zookeeper_status_quorumsize{%(queriesSelector)s}',
          },
        },
      },
    },
  }
