{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'ClickHouseAlerts',
        rules: [
          {
            alert: 'ClickHouseReplicationQueueBackingUp',
            expr: |||
              ClickHouseAsyncMetrics_ReplicasMaxQueueSize > %(alertsReplicasMaxQueueSize)s
            ||| % $._config,
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'ClickHouse replica max queue size backing up.',
              description: |||
                ClickHouse replication tasks are processing slower than expected on {{ $labels.instance }} causing replication queue size to back up at {{ $value }} exceeding the threshold value of %(alertsReplicasMaxQueueSize)s.
              ||| % $._config,
            },
            'for': '5m',
          },
          {
            alert: 'ClickHouseRejectedInserts',
            expr: 'ClickHouseProfileEvents_RejectedInserts > 1',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'ClickHouse has too many rejected inserts.',
              description: 'ClickHouse inserts are being rejected on {{ $labels.instance }} as items are being inserted faster than ClickHouse is able to merge them.',
            },
            'for': '5m',
          },
          {
            alert: 'ClickHouseZookeeperSessions',
            expr: 'ClickHouseMetrics_ZooKeeperSession > 1',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'ClickHouse has too many Zookeeper sessions.',
              description: |||
                ClickHouse has more than one connection to a Zookeeper on {{ $labels.instance }} which can lead to bugs due to stale reads in Zookeepers consistency model.
              |||,
            },
            'for': '5m',
          },
          {
            alert: 'ClickHouseReplicasInReadOnly',
            expr: 'ClickHouseMetrics_ReadonlyReplica > 0',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'ClickHouse has too many replicas in read only state.',
              description: |||
                ClickHouse has replicas in a read only state on {{ $labels.instance }} after losing connection to Zookeeper or at startup.
              |||,
            },
            'for': '5m',
          },
        ],
      },
    ],
  },
}
