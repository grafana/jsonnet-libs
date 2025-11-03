{
  new(this): {
    groups+: [
      {
        name: 'influxdb',
        rules: [
          {
            alert: 'InfluxDBWarningTaskHighFailureRate',
            expr: |||
              100 * rate(task_scheduler_total_execute_failure{%(filteringSelector)s}[5m])/clamp_min(rate(task_scheduler_total_execution_calls{%(filteringSelector)s}[5m]), 1) >= %(alertsWarningTaskSchedulerHighFailureRate)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'InfluxDBCriticalTaskHighFailureRate',
            expr: |||
              100 * rate(task_scheduler_total_execute_failure{%(filteringSelector)s}[5m])/clamp_min(rate(task_scheduler_total_execution_calls{%(filteringSelector)s}[5m]), 1) >= %(alertsCriticalTaskSchedulerHighFailureRate)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'InfluxDBHighBusyWorkerPercentage',
            expr: |||
              task_executor_workers_busy{%(filteringSelector)s} >= %(alertsWarningHighBusyWorkerPercentage)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'InfluxDBHighHeapMemoryUsage',
            expr: |||
              100 * go_memstats_heap_alloc_bytes{%(filteringSelector)s}/clamp_min((go_memstats_heap_idle_bytes{%(filteringSelector)s} + go_memstats_heap_alloc_bytes{%(filteringSelector)s}), 1) >= %(alertsWarningHighHeapMemoryUsage)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
          {
            alert: 'InfluxDBHighAverageAPIRequestLatency',
            expr: |||
              sum without(handler, method, path, response_code, status, user_agent) (increase(http_api_request_duration_seconds_sum{%(filteringSelector)s}[5m])/clamp_min(increase(http_api_requests_total{%(filteringSelector)s}[5m]), 1)) >= %(alertsWarningHighAverageAPIRequestLatency)s
            ||| % this.config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Average API request latency is too high. High latency will negatively affect system performance, degrading data availability and precision.',
              description:
                (
                  'The average API request latency for instance {{$labels.instance}} on cluster {{$labels.influxdb_cluster}} is {{ printf "%%.2f" $value }} seconds, which is above the threshold of %(alertsWarningHighAverageAPIRequestLatency)s seconds.'
                ) % this.config,
            },
          },
          {
            alert: 'InfluxDBSlowAverageIQLExecutionTime',
            expr: |||
              sum without(result) (increase(influxql_service_executing_duration_seconds_sum{%(filteringSelector)s}[5m])/clamp_min(increase(influxql_service_requests_total{%(filteringSelector)s}[5m]), 1)) >= %(alertsWarningSlowAverageIQLExecutionTime)s
            ||| % this.config,
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
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
