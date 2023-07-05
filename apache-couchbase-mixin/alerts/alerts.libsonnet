{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'apache-couchbase',
        rules: [
          {
            alert: 'ApacheCouchbaseHighCPUUsage',
            expr: |||
              max without(category) (sys_cpu_utilization_rate) > %(alertsCriticalCPUUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is high cpu usage for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent CPU usage on {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalCPUUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheCouchbaseHighMemoryUsage',
            expr: |||
              100 * max without(category) (sys_mem_actual_used / (sys_mem_actual_used + sys_mem_actual_free)) > %(alertsCriticalMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a limited amount of memory available for a node.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent memory usage on node {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsCriticalMemoryUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheCouchbaseMemoryEvictionRate',
            expr: |||
              max without() (kv_ep_num_value_ejects) > %(alertsWarningMemoryEvictionRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a spike in evictions in a bucket, which indicates high memory pressure.',
              description:
                (
                  '{{ printf "%%.0f" $value }} evictions in bucket {{$labels.bucket}} on node {{$labels.instance}}, ' +
                  'which is above the threshold of %(alertsWarningMemoryEvictionRate)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheCouchbaseInvalidRequestVolume',
            expr: |||
              max without(instance) (rate(n1ql_invalid_requests[$__rate_interval])) > %(alertsWarningInvalidRequestVolume)s
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
 14 changes: 14 additions & 0 deletions14
integrations/couchbase/alerts/config.libsonnet
Marking files as viewed can help keep track of your progress, but will not affect your submitted reviewViewed
Comment on this file
@@ -0,0 +1,14 @@
{
  _config+:: {
    dashboardTags: ['couchbase-mixin'],
    dashboardPeriod: 'now-3h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsCriticalCPUUsage: 85, // %
    alertsCriticalMemoryUsage: 85,  // %
    alertsWarningMemoryEvictionRate: 10,  // count
    alertsWarningInvalidRequestVolume: 1000,  // count
  },
}