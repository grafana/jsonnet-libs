function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      failures: {
        name: 'Task failures',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Overall task instance failures in an Apache Airflow system.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_ti_failures{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      slaMisses: {
        name: 'SLA misses',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'SLA misses in an Apache Airflow system.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_sla_missed{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      durationSum: {
        name: 'Task duration sum',
        type: 'counter',
        description: 'Sum of task durations.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'airflow_dag_task_duration_sum{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}',
            legendCustomTemplate: '{{dag_id}} - {{task_id}}',
          },
        },
      },

      durationCount: {
        name: 'Task duration count',
        type: 'counter',
        description: 'Count of task durations.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_dag_task_duration_count{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}',
            legendCustomTemplate: '{{dag_id}} - {{task_id}}',
          },
        },
      },

      finishTotal: {
        name: 'Task finish total',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Total number of task finishes by state.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_task_finish_total{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id", state=~"$state"}',
            legendCustomTemplate: '{{dag_id}} - {{task_id}} - {{state}}',
          },
        },
      },

      // Raw signal for average task duration (sum/count)
      avgDuration: {
        name: 'Average task duration',
        type: 'raw',
        description: 'Average duration of tasks calculated as sum/count.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'increase(airflow_dag_task_duration_sum{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}[$__interval:])/clamp_min(increase(airflow_dag_task_duration_count{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}[$__interval:]),1)',
            legendCustomTemplate: '{{dag_id}} - {{task_id}}',
          },
        },
      },

      startTotal: {
        name: 'Task start total',
        type: 'counter',
        description: 'Total number of task starts.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_task_start_total{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}',
            legendCustomTemplate: '{{dag_id}} - {{task_id}}',
          },
        },
      },
    },
  }
