{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'GrafanaAgentHealthChecks',
        rules: [
          {
            alert: 'GrafanaAgentDown',
            expr: |||
              up{
                job="integrations/agent",
              } == 0
            |||,
            'for': '5m',
            annotations: {
              summary: 'Grafana agent is down.',
              description: 'Grafana agent is down on {{ $labels.instance }} for the last 5 minutes',
            },
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'GrafanaAgentUnstable',
            expr: |||
              avg_over_time(up{
                job="integrations/agent",
              }[5m]) < 1
            |||,
            'for': '15m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Grafana agent is unstable.',
              description: 'Grafana agent is unstable or restarting on {{ $labels.instance }} over the last 15 minutes',
            },
          },
          {
            alert: 'GrafanaAgentCPUHigh',
            expr: |||
              (
                rate(process_cpu_seconds_total{
                  job=~"integrations/agent"
                }[5m]) > %(alertsCriticalCpuUsage5m)s / 100
              )
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Grafana agent high CPU usage.',
              description: 'Grafana agent is using more than %(alertsCriticalCpuUsage5m)s percent of CPU on {{ $labels.instance }} for the last 5 minutes' % $._config,
            },
          },
          {
            alert: 'GrafanaAgentMemHigh',
            expr: |||
              (
                sum without (instance) (go_memstats_heap_inuse_bytes{job=~"integrations/agent"}) /
                sum without (instance, instance_group_name) (agent_wal_storage_active_series{job=~"integrations/agent"}) / 1e3 > %(alertsCriticalMemUsage5m)s
              )
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Grafana agent high memory usage.',
              description: 'Grafana agent is using more than %(alertsCriticalMemUsage5m)s of memory on {{ $labels.instance }} for the last 5 minutes' % $._config,
            },
          },
        ],
      },
    ],
  },
}
