function(this)
  local legendCustmoTemplate = std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels));
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustmoTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      // DAG-related signals
      dagParsingErrors: {
        name: 'DAG file parsing errors',
        type: 'gauge',
        description: 'The number of errors from trying to parse DAG files in an Apache Airflow system.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_dag_processing_import_errors{%(queriesSelector)s}',
          },
        },
      },

      dagSuccessDurationSum: {
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

      dagSuccessDurationCount: {
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

      dagFailedDurationSum: {
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

      dagFailedDurationCount: {
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

      dagScheduleDelaySum: {
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

      dagScheduleDelayCount: {
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

      dagAvgSuccessDuration: {
        name: 'Average successful DAG run duration',
        type: 'raw',
        description: 'Average duration of successful DAG runs calculated as sum/count.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'increase(airflow_dagrun_duration_success_sum{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:] offset -$__interval)/clamp_min(increase(airflow_dagrun_duration_success_count{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:] offset -$__interval),1)',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      dagAvgFailedDuration: {
        name: 'Average failed DAG run duration',
        type: 'raw',
        description: 'Average duration of failed DAG runs calculated as sum/count.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'increase(airflow_dagrun_duration_failed_sum{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:] offset -$__interval)/clamp_min(increase(airflow_dagrun_duration_failed_count{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:] offset -$__interval),1)',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      dagAvgScheduleDelay: {
        name: 'Average DAG schedule delay',
        type: 'raw',
        description: 'Average DAG schedule delay calculated as sum/count.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'increase(airflow_dagrun_schedule_delay_sum{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:] offset -$__interval)/clamp_min(increase(airflow_dagrun_schedule_delay_count{%(queriesSelector)s, dag_id=~"$dag_id"}[$__interval:] offset -$__interval),1)',
            legendCustomTemplate: '{{dag_id}}',
          },
        },
      },

      // Task-related signals
      taskFailures: {
        name: 'Task failures',
        type: 'counter',
        description: 'Overall task instance failures in an Apache Airflow system.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_ti_failures{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
            rangeFunction: 'increase',
          },
        },
      },

      taskSlaMisses: {
        name: 'SLA misses',
        type: 'counter',
        description: 'SLA misses in an Apache Airflow system.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_sla_missed{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      taskDurationSum: {
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

      taskDurationCount: {
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

      taskFinishTotalSum: {
        name: 'Task finish total pie',
        type: 'raw',
        description: 'Total number of task finishes by state.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, dag_id, state) (increase(airflow_task_finish_total{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id", state=~"$state"}[$__interval:] offset -$__interval) > 0)',
            legendCustomTemplate: '{{dag_id}} - {{state}}',
          },
        },
      },

      taskFinishTotal: {
        name: 'Task finish total',
        type: 'raw',
        description: 'Total number of task finishes by state.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'increase(airflow_task_finish_total{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id", state=~"$state"}[$__interval:] offset -$__interval) > 0',
            legendCustomTemplate: '{{dag_id}} - {{task_id}} - {{state}}',
          },
        },
      },

      taskAvgDuration: {
        name: 'Average task duration',
        type: 'raw',
        description: 'Average duration of tasks calculated as sum/count.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'increase(airflow_dag_task_duration_sum{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}[$__interval:] offset -$__interval)/clamp_min(increase(airflow_dag_task_duration_count{%(queriesSelector)s, dag_id=~"$dag_id", task_id=~"$task_id"}[$__interval:] offset -$__interval),1) != 0',
            legendCustomTemplate: '{{dag_id}} - {{task_id}}',
          },
        },
      },

      taskStartTotal: {
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

      // Scheduler-related signals
      schedulerTasksExecutable: {
        name: 'Scheduler executable tasks',
        type: 'gauge',
        description: 'Number of tasks that are ready for execution in the scheduler.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_scheduler_tasks_executable{%(queriesSelector)s}',
            legendCustomTemplate: legendCustmoTemplate + ' - executable',
          },
        },
      },

      schedulerTasksStarving: {
        name: 'Scheduler starving tasks',
        type: 'gauge',
        description: 'Number of tasks that are starving (waiting for resources) in the scheduler.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_scheduler_tasks_starving{%(queriesSelector)s}',
            legendCustomTemplate: legendCustmoTemplate + ' - starving',
          },
        },
      },

      // Executor-related signals
      executorRunningTasks: {
        name: 'Executor running tasks',
        type: 'gauge',
        description: 'Number of tasks currently running in the executor.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_executor_running_tasks{%(queriesSelector)s}',
            legendCustomTemplate: legendCustmoTemplate + ' - running',
          },
        },
      },

      executorQueuedTasks: {
        name: 'Executor queued tasks',
        type: 'gauge',
        description: 'Number of tasks queued in the executor.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_executor_queued_tasks{%(queriesSelector)s}',
            legendCustomTemplate: legendCustmoTemplate + ' - queued',
          },
        },
      },

      executorOpenSlots: {
        name: 'Executor open slots',
        type: 'gauge',
        description: 'Number of open slots available in the executor.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_executor_open_slots{%(queriesSelector)s}',
            legendCustomTemplate: legendCustmoTemplate + ' - open',
          },
        },
      },

      // Pool-related signals
      poolRunningSlots: {
        name: 'Pool running slots',
        type: 'gauge',
        description: 'Number of slots currently running in pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_pool_running_slots{%(queriesSelector)s, pool_name=~"$pool_name"}',
            legendCustomTemplate: legendCustmoTemplate + ' - {{pool_name}} - running',
          },
        },
      },

      poolQueuedSlots: {
        name: 'Pool queued slots',
        type: 'gauge',
        description: 'Number of slots queued in pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_pool_queued_slots{%(queriesSelector)s, pool_name=~"$pool_name"}',
            legendCustomTemplate: legendCustmoTemplate + ' - {{pool_name}} - queued',
          },
        },
      },

      poolStarvingTasks: {
        name: 'Pool starving tasks',
        type: 'gauge',
        description: 'Number of tasks starving (waiting for resources) in pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_pool_starving_tasks{%(queriesSelector)s, pool_name=~"$pool_name"}',
            legendCustomTemplate: legendCustmoTemplate + ' - {{pool_name}} - starving',
          },
        },
      },

      poolOpenSlots: {
        name: 'Pool open slots',
        type: 'gauge',
        description: 'Number of open slots available in pools.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'airflow_pool_open_slots{%(queriesSelector)s, pool_name=~"$pool_name"}',
            legendCustomTemplate: legendCustmoTemplate + ' - {{pool_name}} - open',
          },
        },
      },
    },
  }
