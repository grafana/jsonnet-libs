local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'ClickHouseMetrics_ZooKeeperWatch',
    },
    signals: {
      zooKeeperWatches: {
        name: 'ZooKeeper watches',
        nameShort: 'Watches',
        type: 'gauge',
        description: 'Current number of watches in ZooKeeper',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_ZooKeeperWatch{%(queriesSelector)s}',
            legendCustomTemplate: 'ZooKeeper watches',
          },
        },
      },
      zooKeeperSessions: {
        name: 'ZooKeeper sessions',
        nameShort: 'Sessions',
        type: 'gauge',
        description: 'Current number of sessions to ZooKeeper',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_ZooKeeperSession{%(queriesSelector)s}',
            legendCustomTemplate: 'ZooKeeper sessions',
          },
        },
      },
      zooKeeperRequests: {
        name: 'ZooKeeper requests',
        nameShort: 'Requests',
        type: 'gauge',
        description: 'Current number of active requests to ZooKeeper',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_ZooKeeperRequest{%(queriesSelector)s}',
            legendCustomTemplate: 'ZooKeeper requests',
          },
        },
      },
      zooKeeperWaitTime: {
        name: 'ZooKeeper wait time',
        nameShort: 'Wait time',
        type: 'counter',
        description: 'Time spent waiting for ZooKeeper request to process',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_ZooKeeperWaitMicroseconds{%(queriesSelector)s}',
            legendCustomTemplate: 'ZooKeeper wait',
            interval: '30s',
          },
        },
      },
    },
  }
