{
  prometheusAlerts+:: {
    groups+: [
      {
        name: $._config.uid + '-alerts',
        rules: [
          {
            alert: 'OpenSearchYellowCluster',
            expr: |||
              opensearch_cluster_status{%(filteringSelector)s} == 1
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'At least one of the clusters is reporting a yellow status.',
              description:
                (
                  '{{$labels.cluster}} health status is yellow over the last 5 minutes'
                ) % $._config,
            },
          },
          {
            alert: 'OpenSearchRedCluster',
            expr: |||
              opensearch_cluster_status{%(filteringSelector)s} == 2
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'At least one of the clusters is reporting a red status.',
              description:
                (
                  '{{$labels.cluster}} health status is red over the last 5 minutes'
                ) % $._config,
            },
          },
          {
            alert: 'OpenSearchUnstableShardReallocation',
            expr: |||
              sum without(type) (opensearch_cluster_shards_number{%(filteringSelector)s, type="relocating"}) > %(alertsWarningShardReallocations)s
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A node has gone offline or has been disconnected triggering shard reallocation.',
              description: |||
                {{$labels.cluster}} has had {{ printf "%%.0f" $value }} shard reallocation over the last 1m which is above the threshold of %(alertsWarningShardReallocations)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchUnstableShardUnassigned',
            expr: |||
              sum without(type) (opensearch_cluster_shards_number{%(filteringSelector)s, type="unassigned"}) > %(alertsWarningShardUnassigned)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are shards that have been detected as unassigned.',
              description: |||
                {{$labels.cluster}} has had {{ printf "%%.0f" $value }} shard unassigned over the last 5m which is above the threshold of %(alertsWarningShardUnassigned)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchModerateNodeDiskUsage',
            expr: |||
              100 * sum without(nodeid, path, mount, type) ((opensearch_fs_path_total_bytes{%(filteringSelector)s} - opensearch_fs_path_free_bytes{%(filteringSelector)s}) / opensearch_fs_path_total_bytes{%(filteringSelector)s}) > %(alertsWarningDiskUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The node disk usage has exceeded the warning threshold.',
              description: |||
                {{$labels.node}} has had {{ printf "%%.0f" $value }} disk usage over the last 5m which is above the threshold of %(alertsWarningDiskUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchHighNodeDiskUsage',
            expr: |||
              100 * sum without(nodeid, path, mount, type) ((opensearch_fs_path_total_bytes{%(filteringSelector)s} - opensearch_fs_path_free_bytes) / opensearch_fs_path_total_bytes{%(filteringSelector)s}) > %(alertsCriticalDiskUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The node disk usage has exceeded the critical threshold.',
              description: |||
                {{$labels.node}} has had {{ printf "%%.0f" $value }}%% disk usage over the last 5m which is above the threshold of %(alertsCriticalDiskUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchModerateNodeCpuUsage',
            expr: |||
              sum without(nodeid) (opensearch_os_cpu_percent{%(filteringSelector)s}) > %(alertsWarningCPUUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The node CPU usage has exceeded the warning threshold.',
              description: |||
                {{$labels.node}} has had {{ printf "%%.0f" $value }}%% CPU usage over the last 5m which is above the threshold of %(alertsWarningCPUUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchHighNodeCpuUsage',
            expr: |||
              sum without(nodeid) (opensearch_os_cpu_percent{%(filteringSelector)s}) > %(alertsCriticalCPUUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The node CPU usage has exceeded the critical threshold.',
              description: |||
                {{$labels.node}} has had {{ printf "%%.0f" $value }}%% CPU usage over the last 5m which is above the threshold of %(alertsCriticalCPUUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchModerateNodeMemoryUsage',
            expr: |||
              sum without(nodeid) (opensearch_os_mem_used_percent{%(filteringSelector)s}) > %(alertsWarningMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The node memory usage has exceeded the warning threshold.',
              description: |||
                {{$labels.node}} has had {{ printf "%%.0f" $value }}%% memory usage over the last 5m which is above the threshold of %(alertsWarningMemoryUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchHighNodeMemoryUsage',
            expr: |||
              sum without(nodeid) (opensearch_os_mem_used_percent{%(filteringSelector)s}) > %(alertsCriticalMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The node memory usage has exceeded the critical threshold.',
              description: |||
                {{$labels.node}} has had {{ printf "%%.0f" $value }}%% memory usage over the last 5m which is above the threshold of %(alertsCriticalMemoryUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchModerateRequestLatency',
            expr: |||
              sum without(context) ((increase(opensearch_index_search_fetch_time_seconds{%(filteringSelector)s, context="total"}[5m])+increase(opensearch_index_search_query_time_seconds{context="total"}[5m])+increase(opensearch_index_search_scroll_time_seconds{context="total"}[5m])) / clamp_min(increase(opensearch_index_search_fetch_count{context="total"}[5m])+increase(opensearch_index_search_query_count{context="total"}[5m])+increase(opensearch_index_search_scroll_count{context="total"}[5m]), 1)) > %(alertsWarningRequestLatency)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The request latency has exceeded the warning threshold.',
              description: |||
                {{$labels.index}} has had {{ printf "%%.0f" $value }}s of request latency over the last 5m which is above the threshold of %(alertsWarningRequestLatency)s.
              ||| % $._config,
            },
          },
          {
            alert: 'OpenSearchModerateIndexLatency',
            expr: |||
              sum without(context) (increase(opensearch_index_indexing_index_time_seconds{%(filteringSelector)s, context="total"}[5m]) / clamp_min(increase(opensearch_index_indexing_index_count{context="total"}[5m]), 1)) > %(alertsWarningIndexLatency)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The index latency has exceeded the warning threshold.',
              description: |||
                {{$labels.index}} has had {{ printf "%%.0f" $value }}s of index latency over the last 5m which is above the threshold of %(alertsWarningIndexLatency)s.
              ||| % $._config,
            },
          },
        ],
      },
    ],
  },
}
