function(this) {
  local legendCustomTemplate = std.join(' ', std.map(function(label) '{{' + label + '}}', this.coordinatorLegendLabels)),
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  legendCustomTemplate: legendCustomTemplate,
  aggLevel: 'none',
  aggFunction: 'avg',
  discoveryMetric: {
    prometheus: 'presto_QueryManager_InternalFailures_OneMinute_Count',
  },
  signals: {

    nonheapMemoryUsage: {
      name: 'Non-heap memory usage',
      nameShort: 'Non-heap memory usage',
      type: 'gauge',
      description: 'The non-heap memory usage of the coordinator.',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'avg (jvm_nonheap_memory_used{%(queriesSelector)s} / clamp_min((jvm_nonheap_memory_used{%(queriesSelector)s} + jvm_nonheap_memory_committed{%(queriesSelector)s}), 1))',
        },
      },
    },

    heapMemoryUsage: {
      name: 'Heap memory usage',
      nameShort: 'Heap memory usage',
      type: 'gauge',
      description: 'The heap memory usage of the coordinator.',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'avg (jvm_heap_memory_used{%(queriesSelector)s} / clamp_min((jvm_heap_memory_used{%(queriesSelector)s} + jvm_heap_memory_committed{%(queriesSelector)s}), 1))',
        },
      },
    },

    errorFailuresInternal: {
      name: 'Error failures internal',
      nameShort: 'Error failures internal',
      type: 'gauge',
      description: 'The number of internal error failures occurring on the coordinator.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_InternalFailures_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - internal',
        },
      },
    },

    userErrorFailures: {
      name: 'User error failures',
      nameShort: 'User error failures',
      type: 'gauge',
      description: 'The number of user error failures occurring on the coordinator.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_UserErrorFailures_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - user',
        },
      },
    },

    queryCompleted: {
      name: 'Query completed',
      nameShort: 'Query completed',
      type: 'gauge',
      description: 'The number of queries completed occurring on the coordinator.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_CompletedQueries_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - completed',
        },
      },
    },

    queryRunning: {
      name: 'Query running',
      nameShort: 'Query running',
      type: 'gauge',
      description: 'The number of queries running occurring on the coordinator.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_RunningQueries{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - running',
        },
      },
    },

    queryStarted: {
      name: 'Query started',
      nameShort: 'Query started',
      type: 'gauge',
      description: 'The number of queries started occurring on the coordinator.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_StartedQueries_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - started',
        },
      },
    },

    abnormalQueryFailed: {
      name: 'Abnormal query failed',
      nameShort: 'Abnormal query failed',
      type: 'gauge',
      description: 'A count of failed abnormal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_FailedQueries_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - failed',
        },
      },
    },

    abnormalQueryAbandoned: {
      name: 'Abnormal query abandoned',
      nameShort: 'Abnormal query abandoned',
      type: 'gauge',
      description: 'A count of abandoned abnormal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_AbandonedQueries_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - abandoned',
        },
      },
    },

    abnormalQueryCanceled: {
      name: 'Abnormal query canceled',
      nameShort: 'Abnormal query canceled',
      type: 'gauge',
      description: 'A count of canceled abnormal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_CanceledQueries_OneMinute_Count{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - canceled',
        },
      },
    },

    normalQueryCompletedRate: {
      name: 'Normal query completed rate',
      nameShort: 'Normal query completed',
      type: 'gauge',
      description: 'A rate of completed normal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_CompletedQueries_OneMinute_Rate{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - completed',
        },
      },
    },


    normalQueryRunningRate: {
      name: 'Normal query running rate',
      nameShort: 'Normal query running',
      type: 'gauge',
      description: 'A rate of running normal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_RunningQueries{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - running',
        },
      },
    },

    normalQueryStartedRate: {
      name: 'Normal query started rate',
      nameShort: 'Normal query started',
      type: 'gauge',
      description: 'A rate of started normal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_StartedQueries_OneMinute_Rate{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - started',
        },
      },
    },

    abnormalQueryFailedRate: {
      name: 'Abnormal query completed rate',
      nameShort: 'Abnormal query completed',
      type: 'counter',
      description: 'A rate of failed abnormal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_FailedQueries_TotalCount{%(queriesSelector)s}',
          rangeFunction: 'rate',
          legendCustomTemplate: legendCustomTemplate + ' - failed',
        },
      },
    },

    abnormalQueryAbandonedRate: {
      name: 'Abnormal query abandoned rate',
      nameShort: 'Abnormal query abandoned',
      type: 'counter',
      description: 'A rate of abandoned abnormal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_AbandonedQueries_TotalCount{%(queriesSelector)s}',
          rangeFunction: 'rate',
          legendCustomTemplate: legendCustomTemplate + ' - abandoned',
        },
      },
    },

    abnormalQueryCanceledRate: {
      name: 'Abnormal query canceled rate',
      nameShort: 'Abnormal query canceled',
      type: 'counter',
      description: 'A rate of canceled abnormal queries.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_CanceledQueries_TotalCount{%(queriesSelector)s}',
          rangeFunction: 'rate',
          legendCustomTemplate: legendCustomTemplate + ' - canceled',
        },
      },
    },

    queryExecutionTimeP50: {
      name: 'Query execution time (p50)',
      nameShort: 'Query execution time',
      type: 'gauge',
      description: 'The time it took to run queries over the past one minute period.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_ExecutionTime_OneMinute_P50{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - p50',
        },
      },
    },

    queryExecutionTimeP75: {
      name: 'Query execution time (p75)',
      nameShort: 'Query execution time',
      type: 'gauge',
      description: 'The time it took to run queries over the past one minute period.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_ExecutionTime_OneMinute_P75{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - p75',
        },
      },
    },

    queryExecutionTimeP95: {
      name: 'Query execution time (p95)',
      nameShort: 'Query execution time',
      type: 'gauge',
      description: 'The time it took to run queries over the past one minute period.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_ExecutionTime_OneMinute_P95{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - p95',
        },
      },
    },

    queryExecutionTimeP99: {
      name: 'Query execution time (p99)',
      nameShort: 'Query execution time',
      type: 'gauge',
      description: 'The time it took to run queries over the past one minute period.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_ExecutionTime_OneMinute_P99{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - p99',
        },
      },
    },

    cpuTimeConsumed: {
      name: 'CPU time consumed',
      nameShort: 'CPU time consumed',
      type: 'gauge',
      description: 'The time it took to run queries over the past one minute period.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_ConsumedCpuTimeSecs_OneMinute_Count{%(queriesSelector)s}',
        },
      },
    },

    cpuInputThroughput: {
      name: 'CPU input throughput',
      nameShort: 'CPU input throughput',
      type: 'gauge',
      description: 'The time it took to run queries over the past one minute period.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'presto_QueryManager_CpuInputByteRate_OneMinute_Total{%(queriesSelector)s}',
        },
      },
    },

    // JVM metrics

    jvmGarbageCollectorCount: {
      name: 'Garbage collector count',
      nameShort: 'Garbage collector count',
      type: 'counter',
      description: 'The number of garbage collections.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'jvm_gc_collection_count{%(queriesSelector)s, name="G1 Young Generation"}',
          rangeFunction: 'increase',
        },
      },
    },

    jvmGarbageCollectionDuration: {
      name: 'Garbage collection duration',
      nameShort: 'Garbage collection duration',
      type: 'gauge',
      description: 'The duration of garbage collections.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'jvm_gc_duration{%(queriesSelector)s, name="G1 Young Generation"}',
        },
      },
    },

    jvmHeapMemoryUsage: {
      name: 'Heap memory usage',
      nameShort: 'Heap memory usage',
      type: 'gauge',
      description: 'The heap memory usage of the JVM.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'jvm_heap_memory_used{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - heap',
        },
      },
    },

    jvmNonHeapMemoryUsage: {
      name: 'Non-heap memory usage',
      nameShort: 'Non-heap memory usage',
      type: 'gauge',
      description: 'The non-heap memory usage of the JVM.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'jvm_nonheap_memory_used{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - non heap',
        },
      },
    },

    jvmHeapMemoryCommitted: {
      name: 'Heap memory committed',
      nameShort: 'Heap memory committed',
      type: 'gauge',
      description: 'The heap memory committed of the JVM.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'jvm_heap_memory_committed{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - heap',
        },
      },
    },

    jvmNonHeapMemoryCommitted: {
      name: 'Non-heap memory committed',
      nameShort: 'Non-heap memory committed',
      type: 'gauge',
      description: 'The non-heap memory committed of the JVM.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'jvm_nonheap_memory_committed{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - non heap',
        },
      },
    },
  },
}
