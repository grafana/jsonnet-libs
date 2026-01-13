{
  new(this): {
    groups: [
      {
        name: 'RedisEnterpriseAlerts',
        rules: [
          {
            alert: 'RedisEnterpriseClusterOutOfMemory',
            expr: |||
              sum(redis_used_memory{%(filteringSelector)s}) by (redis_cluster, node) / sum(node_available_memory{%(filteringSelector)s}) by (redis_cluster, node) * 100 > %(alertsClusterOutOfMemoryThreshold)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Cluster has run out of memory.',
              description:
                (
                  'Memory usage is at {{ printf "%%.0f" $value }} percent on the cluster {{$labels.redis_cluster}}, ' +
                  "which is above the configured threshold of %(alertsClusterOutOfMemoryThreshold)s%% of the cluster's available memory"
                ) % this.config,
            },
          },
          {
            alert: 'RedisEnterpriseNodeNotResponding',
            expr: |||
              node_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A node in the Redis Enterprise cluster is offline or unreachable.',
              description:
                (
                  'The node {{$labels.node}} in {{$labels.redis_cluster}} is offline or unreachable.'
                ) % this.config,
            },
          },
          {
            alert: 'RedisEnterpriseDatabaseNotResponding',
            expr: |||
              bdb_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A database in the Redis Enterprise cluster is offline or unreachable.',
              description:
                (
                  'The database {{$labels.bdb}} in {{$labels.redis_cluster}} is offline or unreachable.'
                ) % this.config,
            },
          },
          {
            alert: 'RedisEnterpriseShardNotResponding',
            expr: |||
              redis_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A shard in the Redis Enterprise cluster is offline or unreachable.',
              description:
                (
                  'The shard {{$labels.redis}} on database {{$labels.bdb}} running on node {{$labels.node}} in the cluster {{$labels.redis_cluster}} is offline or unreachable.'
                ) % this.config,
            },
          },
          {
            alert: 'RedisEnterpriseNodeHighCPUUtilization',
            expr: |||
              (sum(node_cpu_user{%(filteringSelector)s}) by (node, redis_cluster, job) + sum(node_cpu_system{%(filteringSelector)s}) by (node, redis_cluster, job)) * 100 > %(alertsNodeCPUHighUtilizationThreshold)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Node CPU usage is above the configured threshold.',
              description:
                (
                  'The node {{$labels.node}} in cluster {{$labels.redis_cluster}} has a CPU percentage of ${{ printf "%%.0f" $value }}, which exceeds ' +
                  'the threshold %(alertsNodeCPUHighUtilizationThreshold)s%%.'
                ) % this.config,
            },
          },
          {
            alert: 'RedisEnterpriseHighMemUtilization',
            expr: |||
              sum(bdb_used_memory{%(filteringSelector)s}) by (bdb, redis_cluster) / sum(bdb_memory_limit{%(filteringSelector)s}) by (bdb, redis_cluster) * 100 > %(alertsDatabaseHighMemoryUtilization)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Node memory utilization is above the configured threshold.',
              description:
                (
                  'The database {{$labels.bdb}} in cluster {{$labels.redis_cluster}} has a memory utilization of ${{ printf "%%.0f" $value }}, which exceeds ' +
                  'the threshold %(alertsDatabaseHighMemoryUtilization)s%%.'
                ) % this.config,
            },
          },
          {
            alert: 'RedisEnterpriseAverageLatencyIncreasing',
            expr: |||
              bdb_avg_latency{%(filteringSelector)s} * 1000 > %(alertsDatabaseHighLatencyMs)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Operation latency is above the configured threshold.',
              description:
                (
                  'The database {{$labels.bdb}} in cluster {{$labels.redis_cluster}} has high latency of ${{ printf "%%.0f" $value }}, which exceeds ' +
                  'the threshold of %(alertsDatabaseHighLatencyMs)s ms.'
                ) % this.config,
            },
          },
          {
            alert: 'RedisEnterpriseKeyEvictionsIncreasing',
            expr: |||
              bdb_evicted_objects{%(filteringSelector)s} >= %(alertsEvictedObjectsThreshold)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The number of evicted objects is greater than or equal to the configured threshold.',
              description:
                (
                  'The database {{$labels.bdb}} in cluster {{$labels.redis_cluster}} is evicting ${{ printf "%%.0f" $value }} objects, which exceeds ' +
                  'the threshold of %(alertsEvictedObjectsThreshold)s evicted objects.'
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
