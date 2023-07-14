{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'apache-couchbase',
        rules: [
          {
            alert: 'ApacheCouchbaseHighCPUUsage',
            expr: |||
              max without(category, job) (sys_cpu_utilization_rate) > %(alertsCriticalCPUUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The node CPU usage has exceeded the critical threshold.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent CPU usage on node {{$labels.instance}} and on cluster {{$labels.couchbase_cluster}}, ' +
                  'which is above the threshold of %(alertsCriticalCPUUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheCouchbaseHighMemoryUsage',
            expr: |||
              100 * max without(category, job) (sys_mem_actual_used / clamp_min(sys_mem_actual_used + sys_mem_actual_free, 1)) > %(alertsCriticalMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a limited amount of memory available for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent memory usage on node {{$labels.instance}} and on cluster {{$labels.couchbase_cluster}}, ' +
                  'which is above the threshold of %(alertsCriticalMemoryUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheCouchbaseMemoryEvictionRate',
            expr: |||
              max without(job) (kv_ep_num_value_ejects) > %(alertsWarningMemoryEvictionRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a spike in evictions in a bucket, which indicates high memory pressure.',
              description:
                (
                  '{{ printf "%%.0f" $value }} evictions in bucket {{$labels.bucket}}, on node {{$labels.instance}}, and on cluster {{$labels.couchbase_cluster}}, ' +
                  'which is above the threshold of %(alertsWarningMemoryEvictionRate)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheCouchbaseInvalidRequestVolume',
            expr: |||
              max without(instance, job) (rate(n1ql_invalid_requests[2m])) > %(alertsWarningInvalidRequestVolume)s
            ||| % $._config,
            'for': '2m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high volume of incoming invalid requests, which may indicate a DOS or injection attack.',
              description:
                (
                  '{{ printf "%%.0f" $value }} invalid requests to {{$labels.couchbase_cluster}}, ' +
                  'which is above the threshold of %(alertsWarningInvalidRequestVolume)s.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
