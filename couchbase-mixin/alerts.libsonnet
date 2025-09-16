{
  new(this): {
    groups: [
      {
        name: 'couchbase',
        rules: [
          {
            alert: 'CouchbaseHighCPUUsage',
            expr: |||
              (sys_cpu_utilization_rate) > %(alertsCriticalCPUUsage)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'CouchbaseHighMemoryUsage',
            expr: |||
              100 * (sys_mem_actual_used / clamp_min(sys_mem_actual_used + sys_mem_actual_free, 1)) > %(alertsCriticalMemoryUsage)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'CouchbaseMemoryEvictionRate',
            expr: |||
              (kv_ep_num_value_ejects) > %(alertsWarningMemoryEvictionRate)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'CouchbaseInvalidRequestVolume',
            expr: |||
              sum without(instance, job) (rate(n1ql_invalid_requests[2m])) > %(alertsWarningInvalidRequestVolume)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
