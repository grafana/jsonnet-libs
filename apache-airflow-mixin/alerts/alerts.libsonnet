{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'apache-airflow',
        rules: [
          {
            alert: 'ApacheAirflowStarvingPoolTasks',
            expr: |||
              airflow_pool_starving_tasks > %(alertsCriticalPoolStarvingTasks)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are starved tasks detected in the Apache Airflow pool.',
              description: |||
                The number of starved tasks is {{ printf "%%.0f" $value }} over the last 5m on {{ $labels.instance }} - {{ $labels.pool_name }} which is above the threshold of %(alertsCriticalPoolStarvingTasks)s.
              ||| % $._config,
            },
          },
          {
            alert: 'ApacheAirflowDAGScheduleDelayWarningLevel',
            expr: |||
              increase(airflow_dagrun_schedule_delay_sum[5m]) / clamp_min(increase(airflow_dagrun_schedule_delay_count[5m]),1) > %(alertsWarningDAGScheduleDelayLevel)s
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'The delay in DAG schedule time to DAG run time has reached the warning threshold.',
              description: |||
                The average delay in DAG schedule to run time is {{ printf "%%.0f" $value }} over the last 1m on {{ $labels.instance }} - {{ $labels.dag_id }} which is above the threshold of %(alertsWarningDAGScheduleDelayLevel)s.
              ||| % $._config,
            },
          },
          {
            alert: 'ApacheAirflowDAGScheduleDelayCriticalLevel',
            expr: |||
              increase(airflow_dagrun_schedule_delay_sum[5m]) / clamp_min(increase(airflow_dagrun_schedule_delay_count[5m]),1) > %(alertsCriticalDAGScheduleDelayLevel)s
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'The delay in DAG schedule time to DAG run time has reached the critical threshold.',
              description: |||
                The average delay in DAG schedule to run time is {{ printf "%%.0f" $value }} over the last 1m for {{ $labels.instance }} - {{ $labels.dag_id }} which is above the threshold of %(alertsCriticalDAGScheduleDelayLevel)s.
              ||| % $._config,
            },
          },
          {
            alert: 'ApacheAirflowDAGFailures',
            expr: |||
              increase(airflow_dagrun_duration_failed_count[5m]) > %(alertsCriticalFailedDAGs)s
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There have been DAG failures detected.',
              description: |||
                The number of DAG failures seen is {{ printf "%%.0f" $value }} over the last 1m for {{ $labels.instance }} - {{ $labels.dag_id }} which is above the threshold of %(alertsCriticalFailedDAGs)s.
              ||| % $._config,
            },
          },
        ],
      },
    ],
  },
}
  