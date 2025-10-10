function(this) {
  local legendCustomTemplate = '{{instance}}',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  legendCustomTemplate: std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
  aggLevel: 'none',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'presto_TaskExecutor_ProcessorExecutor_QueuedTaskCount',
  },
  signals: {
    nonheapMemoryUsage: {
      name: 'Non-heap memory usage',
      nameShort: 'Non-heap memory usage',
      type: 'raw',
      description: 'The non-heap memory usage of the worker.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'avg (jvm_nonheap_memory_used{%(queriesSelector)s} / clamp_min((jvm_nonheap_memory_used{%(queriesSelector)s} + jvm_nonheap_memory_committed{%(queriesSelector)s}), 1))',
        },
      },
    },
    heapMemoryUsage: {
      name: 'Heap memory usage',
      nameShort: 'Heap',
      type: 'raw',
      description: 'The heap memory usage of the worker.',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'avg (jvm_heap_memory_used{%(queriesSelector)s} / clamp_min((jvm_heap_memory_used{%(queriesSelector)s} + jvm_heap_memory_committed{%(queriesSelector)s}), 1))',
        },
      },
    },
    queuedTasks: {
      name: 'Queued tasks',
      nameShort: 'Queued',
      type: 'gauge',
      description: 'The number of tasks that are being queued by the task executor.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'presto_TaskExecutor_ProcessorExecutor_QueuedTaskCount{%(queriesSelector)s}',
        },
      },
    },

    failedTasks: {
      name: 'Failed tasks',
      nameShort: 'Failed',
      type: 'counter',
      description: 'The number of tasks that have failed by the task executor.',
      unit: 'ops',
      sources: {
        prometheus: {
          expr: 'presto_TaskExecutor_ProcessorExecutor_FailedTaskCount{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - failed',
        },
      },
    },

    completedTasks: {
      name: 'Completed tasks',
      nameShort: 'Completed',
      type: 'counter',
      description: 'The number of tasks that have completed by the task executor.',
      unit: 'ops',
      sources: {
        prometheus: {
          expr: 'presto_TaskExecutor_ProcessorExecutor_CompletedTaskCount{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - completed',
        },
      },
    },

    outputPositions: {
      name: 'Output positions',
      nameShort: 'Output positions',
      type: 'gauge',
      description: 'The rate of rows (or records) produced by an operation.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'presto_TaskManager_OutputPositions_OneMinute_Rate{%(queriesSelector)s}',
        },
      },
    },

    taskNotificationExecutorPoolSize: {
      name: 'Executor pool size',
      nameShort: 'Task notification executor pool size',
      type: 'gauge',
      description: 'The pool size of the task notification executor.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'presto_TaskExecutor_ProcessorExecutor_PoolSize{%(queriesSelector)s}',
        },
      },
    },

    processExecutorCorePoolSize: {
      name: 'Process executor core pool size',
      nameShort: 'Process executor core pool size',
      type: 'gauge',
      description: 'The core pool size of the process executor.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'presto_TaskExecutor_ProcessorExecutor_CorePoolSize{%(queriesSelector)s}',
        },
      },
    },

    processExecutorPoolSize: {
      name: 'Process executor pool size',
      nameShort: 'Process executor pool size',
      type: 'gauge',
      description: 'The pool size of the process executor.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'presto_TaskExecutor_ProcessorExecutor_PoolSize{%(queriesSelector)s}',
        },
      },
    },

    memoryPoolFreeBytes: {
      name: 'Memory pool free bytes',
      nameShort: 'Memory pool free bytes',
      type: 'gauge',
      description: 'The free bytes of the memory pool.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'presto_MemoryPool_general_FreeBytes{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - free',
        },
      },
    },

    memoryPoolReservedFreeBytes: {
      name: 'Memory pool reserved free bytes',
      nameShort: 'Memory pool reserved free bytes',
      type: 'gauge',
      description: 'The reserved free bytes of the memory pool.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'presto_MemoryPool_reserved_FreeBytes{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - reserved free',
        },
      },
    },


    dataProcessingInput: {
      name: 'Data processing input',
      nameShort: 'Data processing input',
      type: 'gauge',
      description: 'The input of the data processing.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'presto_TaskManager_InputDataSize_OneMinute_Rate{%(queriesSelector)s}',
        },
      },
    },

    dataProcessingOutput: {
      name: 'Data processing output',
      nameShort: 'Data processing output',
      type: 'gauge',
      description: 'The output of the data processing.',
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'presto_TaskManager_OutputDataSize_OneMinute_Rate{%(queriesSelector)s}',
        },
      },
    },

    garbageCollectionCount: {
      name: 'Garbage collection count',
      nameShort: 'Garbage collection count',
      type: 'counter',
      description: 'The number of garbage collections.',
      unit: 'ops',
      sources: {
        prometheus: {
          expr: 'jvm_gc_collection_count{%(queriesSelector)s}',
          rangeFunction: 'increase',
        },
      },
    },

    garbageCollectionDuration: {
      name: 'JVM GC duration',
      nameShort: 'JVM GC duration',
      type: 'gauge',
      description: 'The duration for each garbage collection operation in the JVM.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'jvm_gc_duration{%(queriesSelector)s}',
          rangeFunction: 'increase',
        },
      },
    },

    jvmNonHeapMemoryUsage: {
      name: 'JVM non-heap memory usage',
      nameShort: 'JVM non-heap memory usage',
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

    jvmHeapMemoryUsage: {
      name: 'JVM heap memory usage',
      nameShort: 'JVM heap memory usage',
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

    jvmHeapMemoryCommitted: {
      name: 'JVM heap memory committed',
      nameShort: 'JVM heap memory committed',
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
      name: 'JVM non-heap memory committed',
      nameShort: 'JVM non-heap memory committed',
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
