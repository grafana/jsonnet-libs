{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'presto-alerts',
        rules: [
          {
            alert: 'PrestoHighInsufficientFailures',
            expr: |||
              increase(com_facebook_presto_execution_QueryManager_InsufficientResourcesFailures_TotalCount[5m]) > %(alertsHighInsufficientResourceErrors)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The amount of failures that are occurring due to insufficient resources are scaling, causing saturation in the system.',
              description:
                (
                  'The number of insufficient resource failures on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighInsufficientResourceErrors)s.'
                ) % $._config,
            },
          },
          {
            alert: 'PrestoHighTaskFailuresWarning',
            expr: |||
              increase(com_facebook_presto_execution_TaskManager_FailedTasks_TotalCount[5m]) > %(alertsHighTaskFailuresWarning)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The amount of tasks that are failing is increasing, this might affect query processing and could result in incomplete or incorrect results.',
              description:
                (
                  'The number of task failures on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is above the threshold of %(alertsHighTaskFailuresWarning)s.'
                ) % $._config,
            },
          },
          {
            alert: 'PrestoHighTaskFailuresCritical',
            expr: |||
              increase(com_facebook_presto_execution_TaskManager_FailedTasks_TotalCount[5m]) / clamp_min(increase(com_facebook_presto_execution_TaskManager_FailedTasks_TotalCount[10m]), 1) * 100 > %(alertsHighTaskFailuresCritical)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The amount of tasks that are failing has reached a critical level. This might affect query processing and could result in incomplete or incorrect results.',
              description:
                (
                  'The number of task failures on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is above the threshold of %(alertsHighTaskFailuresCritical)s%%s.'
                ) % $._config,
            },
          },
          {
            alert: 'PrestoHighQueuedTaskCount',
            expr: |||
              increase(com_facebook_presto_execution_QueryManager_QueuedTaskCount[5m]) > %(alertsHighQueuedTaskCount)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The amount of tasks that are being put in queue is increasing. A high number of queued tasks can lead to increased query latencies and degraded system performance.',
              description:
                (
                  'The number of queued tasks on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighQueuedTaskCount)s'
                ) % $._config,
            },
          },
          {
            alert: 'PrestoHighBlockedNodes',
            expr: |||
              increase(com_facebook_presto_memory_ClusterMemoryPool_BlockedNodes[5m]) > %(alertsHighBlockedNodesCount)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The amount of nodes that are blocked due to memory restrictions is increasing. Blocked nodes can cause performance degradation and resource starvation.',
              description:
                (
                  'The number of blocked nodes on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighBlockedNodesCount)s'
                ) % $._config,
            },
          },
          {
            alert: 'PrestoHighFailedQueriesWarning',
            expr: |||
              increase(com_facebook_presto_execution_QueryManager_FailedQueries_TotalCount[5m]) > %(alertsHighFailedQueryCountWarning)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The amount of queries failing is increasing. Failed queries can prevent users from accessing data, disrupt analytics processes, and might indicate underlying issues with the system or data.',
              description:
                (
                  'The number of failed queries on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighFailedQueryCountWarning)s'
                ) % $._config,
            },
          },
          {
            alert: 'PrestoHighFailedQueriesCritical',
            expr: |||
              increase(com_facebook_presto_execution_QueryManager_FailedQueries_TotalCount[5m]) / clamp_min(increase(com_facebook_presto_execution_QueryManager_FailedQueries_TotalCount[10m]), 1) * 100 > %(alertsHighFailedQueryCountCritical)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The amount of queries failing has increased to critical levels. Failed queries can prevent users from accessing data, disrupt analytics processes, and might indicate underlying issues with the system or data.',
              description:
                (
                  'The number of failed queries on {{$labels.instance}} is {{ printf "%%.0f" $value }} which is greater than the threshold of %(alertsHighFailedQueryCountCritical)s%%s.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
