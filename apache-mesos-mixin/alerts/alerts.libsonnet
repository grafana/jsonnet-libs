{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'apache-mesos',
        rules: [
          {
            alert: 'ApacheMesosHighMemoryUsage',
            expr: |||
              min without(instance, job, type) (mesos_master_mem{type="percent"}) > %(alertsWarningMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There is a high memory usage for the cluster.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent memory usage on {{$labels.mesos_cluster}}, ' +
                  'which is above the threshold of %(alertsWarningMemoryUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheMesosHighDiskUsage',
            expr: |||
              min without(instance, job, type) (mesos_master_disk{type="percent"}) > %(alertsCriticalDiskUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high disk usage for the cluster.',
              description:
                (
                  '{{ printf "%%.0f" $value }} percent disk usage on {{$labels.mesos_cluster}}, ' +
                  'which is above the threshold of %(alertsCriticalDiskUsage)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheMesosUnreachableTasks',
            expr: |||
              max without(instance, job, state) (mesos_master_task_states_current{state="unreachable"}) > %(alertsWarningUnreachableTask)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are an unusually high number of unreachable tasks.',
              description:
                (
                  '{{ printf "%%.0f" $value }} unreachable tasks on {{$labels.mesos_cluster}}, ' +
                  'which is above the threshold of %(alertsWarningUnreachableTask)s.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheMesosNoLeaderElected',
            expr: |||
              max without(instance, job) (mesos_master_elected) == 0
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is currently no cluster coordinator.',
              description:
                (
                  'There is no cluster coordinator on {{$labels.mesos_cluster}}.'
                ) % $._config,
            },
          },
          {
            alert: 'ApacheMesosInactiveAgents',
            expr: |||
              max without(instance, job, state) (mesos_master_slaves_state{state=~"connected_inactive|disconnected_inactive"}) > 1
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'There are currently inactive agent clients.',
              description:
                (
                  '{{ printf "%%.0f" $value }} inactive agent clients over the last 5m which is above the threshold of 1.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
