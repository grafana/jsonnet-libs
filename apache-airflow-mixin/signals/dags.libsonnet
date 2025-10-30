function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      parsingErrors: {
        name: 'DAG file parsing errors',
        type: 'gauge',
        description: 'The number of errors from trying to parse DAG files in an Apache Airflow system.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_dag_processing_import_errors{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      successDurationSum: {
        name: 'Successful DAG run duration sum',
        type: 'counter',
        description: 'Sum of successful DAG run durations.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'airflow_dagrun_duration_success_sum{%(queriesSelector)s, dag_id=~"$dag_id"}',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      successDurationCount: {
        name: 'Successful DAG run duration count',
        type: 'counter',
        description: 'Count of successful DAG runs.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_dagrun_duration_success_count{%(queriesSelector)s, dag_id=~"$dag_id"}',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      failedDurationSum: {
        name: 'Failed DAG run duration sum',
        type: 'counter',
        description: 'Sum of failed DAG run durations.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'airflow_dagrun_duration_failed_sum{%(queriesSelector)s, dag_id=~"$dag_id"}',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      failedDurationCount: {
        name: 'Failed DAG run duration count',
        type: 'counter',
        description: 'Count of failed DAG runs.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_dagrun_duration_failed_count{%(queriesSelector)s, dag_id=~"$dag_id"}',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      scheduleDelaySum: {
        name: 'DAG schedule delay sum',
        type: 'counter',
        description: 'Sum of DAG schedule delays.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'airflow_dagrun_schedule_delay_sum{%(queriesSelector)s, dag_id=~"$dag_id"}',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      scheduleDelayCount: {
        name: 'DAG schedule delay count',
        type: 'counter',
        description: 'Count of DAG schedule delays.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_dagrun_schedule_delay_count{%(queriesSelector)s, dag_id=~"$dag_id"}',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      // Raw signal for average successful DAG duration (sum/count)
      avgSuccessDuration: {
        name: 'Average successful DAG run duration',
        type: 'raw',
        description: 'Average duration of successful DAG runs calculated as sum/count.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'increase(airflow_dagrun_duration_success_sum{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:])/clamp_min(increase(airflow_dagrun_duration_success_count{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:]),1)',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      // Raw signal for average failed DAG duration (sum/count)
      avgFailedDuration: {
        name: 'Average failed DAG run duration',
        type: 'raw',
        description: 'Average duration of failed DAG runs calculated as sum/count.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'increase(airflow_dagrun_duration_failed_sum{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:])/clamp_min(increase(airflow_dagrun_duration_failed_count{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:]),1)',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      // Raw signal for average DAG schedule delay (sum/count)
      avgScheduleDelay: {
        name: 'Average DAG schedule delay',
        type: 'raw',
        description: 'Average DAG schedule delay calculated as sum/count.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'increase(airflow_dagrun_schedule_delay_sum{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:])/clamp_min(increase(airflow_dagrun_schedule_delay_count{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:]),1)',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },
    },
  }
