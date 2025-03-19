{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'influxdb',
        rules: [
          {
            alert: 'InfluxDBWarningTaskSchedulerHighFailureRate',
            expr: |||
              100 * rate(task_scheduler_total_execute_failure[5m])/clamp_min(rate(task_scheduler_total_execution_calls[5m]), 1) >= %(alertsWarningTaskSchedulerHighFailureRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Automated data processing tasks are failing at a high rate.',
              description:
                (
                  'Task scheduler task executions for instance {{$labels.instance}} on cluster {{$labels.influxdb_cluster}} are failing at a rate of {{ printf "%%.0f" $value }} percent, ' +
                  'which is above the threshold of %(alertsWarningTaskSchedulerHighFailureRate)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'InfluxDBCriticalTaskSchedulerHighFailureRate',
            expr: |||
              100 * rate(task_scheduler_total_execute_failure[5m])/clamp_min(rate(task_scheduler_total_execution_calls[5m]), 1) >= %(alertsCriticalTaskSchedulerHighFailureRate)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Automated data processing tasks are failing at a critical rate.',
              description:
                (
                  'Task scheduler task executions for instance {{$labels.instance}} on cluster {{$labels.influxdb_cluster}} are failing at a rate of {{ printf "%%.0f" $value }} percent, ' +
                  'which is above the threshold of %(alertsCriticalTaskSchedulerHighFailureRate)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'InfluxDBHighBusyWorkerPercentage',
            expr: |||
              task_executor_workers_busy >= %(alertsWarningHighBusyWorkerPercentage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high percentage of busy workers.',
              description:
                (
                  'The busy worker percentage for instance {{$labels.instance}} on cluster {{$labels.influxdb_cluster}} is {{ printf "%%.0f" $value }} percent, ' +
                  'which is above the threshold of %(alertsWarningHighBusyWorkerPercentage)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'InfluxDBHighHeapMemoryUsage',
            expr: |||
              100 * go_memstats_heap_alloc_bytes/clamp_min((go_memstats_heap_idle_bytes + go_memstats_heap_alloc_bytes), 1) >= %(alertsWarningHighHeapMemoryUsage)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There is a high amount of heap memory being used.',
              description:
                (
                  'The heap memory usage for instance {{$labels.instance}} on cluster {{$labels.influxdb_cluster}} is {{ printf "%%.0f" $value }} percent, ' +
                  'which is above the threshold of %(alertsWarningHighHeapMemoryUsage)s percent.'
                ) % $._config,
            },
          },
          {
            alert: 'InfluxDBHighAverageAPIRequestLatency',
            expr: |||
              sum without(handler, method, path, response_code, status, user_agent) (increase(http_api_request_duration_seconds_sum[5m])/clamp_min(increase(http_api_requests_total[5m]), 1)) >= %(alertsWarningHighAverageAPIRequestLatency)s
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Average API request latency is too high. High latency will negatively affect system performance, degrading data availability and precision.',
              description:
                (
                  'The average API request latency for instance {{$labels.instance}} on cluster {{$labels.influxdb_cluster}} is {{ printf "%%.2f" $value }} seconds, which is above the threshold of %(alertsWarningHighAverageAPIRequestLatency)s seconds.'
                ) % $._config,
            },
          },
          {
            alert: 'InfluxDBSlowAverageIQLExecutionTime',
            expr: |||
              sum without(result) (increase(influxql_service_executing_duration_seconds_sum[5m])/clamp_min(increase(influxql_service_requests_total[5m]), 1)) >= %(alertsWarningSlowAverageIQLExecutionTime)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'InfluxQL execution times are too slow. Slow query execution times will negatively affect system performance, degrading data availability and precision.',
              description:
                (
                  'The average InfluxQL query execution time for instance {{$labels.instance}} on cluster {{$labels.influxdb_cluster}} is {{ printf "%%.2f" $value }} seconds, ' +
                  'which is above the threshold of %(alertsWarningSlowAverageIQLExecutionTime)s seconds.'
                ) % $._config,
            },
          },
        ],
      },
    ],
  },
}
