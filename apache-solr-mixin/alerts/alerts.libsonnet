{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'apache-solr',
        rules: [
          {
            alert: 'ApacheSolrZookeeperChangeInEnsembleSize',
            expr: |||
              changes(solr_zookeeper_ensemble_size[5m]) > 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Changes in the ZooKeeper ensemble size can affect the stability and performance of the cluster.',
              description:
                (
                  'Zookeeper host {{$labels.zk_host}} has had an ensemble change of {{ printf "%%.0f" $value }} over the last 5 minutes'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheSolrHighCPUUsageCritical',
            expr: |||
              100 * sum without (base_url, item) (avg_over_time(solr_metrics_jvm_os_cpu_load{item="systemCpuLoad"}[5m])) > %(alertsCriticalCPUUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'High CPU load can indicate that Solr nodes are under heavy load, potentially impacting performance.',
              description:
                (
                  '{{$labels.instance}} on cluster {{$labels.solr_cluster}} has had a system CPU load of {{ printf "%%.0f" $value }}%%, which is above the threshold of %(alertsCriticalCPUUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheSolrHighCPUUsageWarning',
            expr: |||
              100 * sum without (base_url, item) (avg_over_time(solr_metrics_jvm_os_cpu_load{item="systemCpuLoad"}[5m])) > %(alertsWarningCPUUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High CPU load can indicate that Solr nodes are under heavy load, potentially impacting performance.',
              description:
                (
                  '{{$labels.instance}} on cluster {{$labels.solr_cluster}} has had a system CPU load of {{ printf "%%.0f" $value }}%%, which is above the threshold of %(alertsWarningCPUUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheSolrHighHeapMemoryUsageCritical',
            expr: |||
              100 * sum without(item, base_url)(solr_metrics_jvm_memory_heap_bytes{item="used"}) / clamp_min(sum without(item, base_url)(solr_metrics_jvm_memory_heap_bytes{item="max"}), 1) > %(alertsCriticalMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'High heap memory usage can lead to garbage collection issues, out-of-memory errors, and overall system instability.',
              description: |||
                {{$labels.instance}} on cluster {{$labels.solr_cluster}} has had high memory usage of {{ printf "%%.0f" $value }}%%, which is above the thresold of %(alertsCriticalMemoryUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'ApacheSolrHighHeapMemoryUsageWarning',
            expr: |||
              100 * sum without(item, base_url)(solr_metrics_jvm_memory_heap_bytes{item="used"}) / clamp_min(sum without(item, base_url)(solr_metrics_jvm_memory_heap_bytes{item="max"}), 1) > %(alertsWarningMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High heap memory usage can lead to garbage collection issues, out-of-memory errors, and overall system instability.',
              description: |||
                {{$labels.instance}} on cluster {{$labels.solr_cluster}} has had high memory usage of {{ printf "%%.0f" $value }}%%, which is above the thresold of %(alertsWarningMemoryUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'ApacheSolrLowCacheHitRatio',
            expr: |||
              100 * sum without(base_url, category, collection, item, replica, shard) (solr_metrics_core_searcher_cache_ratio{item="hitratio", type=~"documentCache|filterCache|queryResultCache"}) < %(alertsWarningCacheUsage)s
            ||| % $._config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Low cache hit ratios can lead to increased disk I/O and slower query response times.',
              description: |||
                {{$labels.instance}} on cluster {{$labels.solr_cluster}} has had a low cache hit ratio of {{ printf "%%.0f" $value }}%% on core {{$labels.core}} of type {{$labels.type}}, which is under the threshold of %(alertsWarningCacheUsage)s.
              ||| % $._config,
            },
          },
          {
            alert: 'ApacheSolrHighCoreErrors',
            expr: |||
              100 * sum without(base_url, category, collection, handler, replica, shard) (increase(solr_metrics_core_errors_total[10m]) / clamp_min(avg_over_time(solr_metrics_core_errors_total[10m]), 1)) > %(alertsWarningCoreErrors)s
            ||| % $._config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A spike in core errors can indicate serious issues at the core level, affecting data integrity and availability.',
              description: |||
                {{$labels.instance}} on cluster {{$labels.solr_cluster}} has had a high amount of core errors {{ printf "%%.0f" $value }}%% on core {{$labels.core}}, which is above the threshold of %(alertsWarningCoreErrors)s.
              ||| % $._config,
            },
          },
          {
            alert: 'ApacheSolrHighDocumentIndexing',
            expr: |||
              100 * sum without(base_url, category, collection, handler, replica, shard) (increase(solr_metrics_core_update_handler_adds_total[15m]) / clamp_min(avg_over_time(solr_metrics_core_update_handler_adds_total[15m]), 1)) > %(alertsWarningDocumentIndexing)s
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'A sudden spike in document indexing could indicate unintended or malicious bulk updates.',
              description: |||
                {{$labels.instance}} on cluster {{$labels.solr_cluster}} has had a high document indexing value of {{ printf "%%.0f" $value }}%% on core {{$labels.core}}, which is above the threshold of %(alertsWarningDocumentIndexing)s.
              ||| % $._config,
            },
          },
        ],
      },
    ],
  },
}
