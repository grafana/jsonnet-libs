function(this)
  {
    datasource: 'prometheus_datasource',
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'solr_metrics_jvm_os_cpu_load',
    },
    signals: {
      garbageCollections: {
        name: 'Garbage collections / $__interval',
        nameShort: 'GC count',
        type: 'counter',
        description: 'Counts the total number of garbage collection events.',
        unit: 'none',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_gc_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
            aggKeepLabels: ['solr_cluster', 'base_url', 'item'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      garbageCollectionTime: {
        name: 'Garbage collection time / $__interval',
        nameShort: 'GC time',
        type: 'raw',
        description: 'Total time spent in garbage collection.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url, item) (increase(solr_metrics_jvm_gc_seconds_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(solr_metrics_jvm_gc_total{%(queriesSelector)s}[$__interval:]), 1)) > 0',
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      cpuLoad: {
        name: 'CPU load',
        nameShort: 'CPU',
        type: 'gauge',
        description: 'CPU load caused by the JVM.',
        unit: 'percent',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: '100 * solr_metrics_jvm_os_cpu_load{%(queriesSelector)s, item="systemCpuLoad"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}}',
          },
        },
      },
      cpuLoadAlert: {
        name: 'CPU load (alert)',
        nameShort: 'CPU alert',
        type: 'raw',
        description: 'System CPU load aggregated without instance labels (used for alerting).',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum without (base_url, item) (avg_over_time(solr_metrics_jvm_os_cpu_load{%(queriesSelector)s, item="systemCpuLoad"}[5m]))',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      osMemoryFree: {
        name: 'OS free physical memory',
        nameShort: 'OS mem free',
        type: 'gauge',
        description: 'OS free physical memory.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_os_memory_bytes{%(queriesSelector)s, item="freePhysicalMemorySize"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - free physical',
          },
        },
      },
      osMemoryTotal: {
        name: 'OS total physical memory',
        nameShort: 'OS mem total',
        type: 'gauge',
        description: 'OS total physical memory.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_os_memory_bytes{%(queriesSelector)s, item="totalPhysicalMemorySize"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - total physical',
          },
        },
      },
      osMemoryVirtual: {
        name: 'OS committed virtual memory',
        nameShort: 'OS mem virtual',
        type: 'gauge',
        description: 'OS committed virtual memory.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_os_memory_bytes{%(queriesSelector)s, item="committedVirtualMemorySize"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - committed virtual',
          },
        },
      },
      fileDescriptors: {
        name: 'File descriptors',
        nameShort: 'File descriptors',
        type: 'gauge',
        description: 'Number of open file descriptors.',
        unit: 'none',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_os_file_descriptors{%(queriesSelector)s}',
            aggKeepLabels: ['solr_cluster', 'base_url', 'item'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      memoryHeapUsed: {
        name: 'Heap memory used',
        nameShort: 'Heap used',
        type: 'gauge',
        description: 'JVM heap memory used.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="used"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - heap',
          },
        },
      },
      memoryHeapCommitted: {
        name: 'Heap memory committed',
        nameShort: 'Heap committed',
        type: 'gauge',
        description: 'JVM heap memory committed.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="committed"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - heap',
          },
        },
      },
      memoryHeapMax: {
        name: 'Heap memory max',
        nameShort: 'Heap max',
        type: 'gauge',
        description: 'Maximum JVM heap memory available.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="max"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - heap max',
          },
        },
      },
      memoryNonHeapUsed: {
        name: 'Non-heap memory used',
        nameShort: 'Non-heap used',
        type: 'gauge',
        description: 'JVM non-heap memory used.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_memory_non_heap_bytes{%(queriesSelector)s, item="used"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - non-heap',
          },
        },
      },
      memoryNonHeapCommitted: {
        name: 'Non-heap memory committed',
        nameShort: 'Non-heap committed',
        type: 'gauge',
        description: 'JVM non-heap memory committed.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_jvm_memory_non_heap_bytes{%(queriesSelector)s, item="committed"}',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - non-heap',
          },
        },
      },
      heapMemoryUsage: {
        name: 'Top nodes by heap memory usage',
        nameShort: 'Heap usage',
        type: 'raw',
        description: 'Top nodes by the JVM heap memory usage.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * avg by (job, base_url, solr_cluster) (sum without(item)(solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="used"}) / clamp_min(sum without(item)(solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="max"}), 1))',
            legendCustomTemplate: '{{base_url}}',
          },
        },
      },
      heapMemoryUsagePct: {
        name: 'Heap memory usage %',
        nameShort: 'Heap %',
        type: 'raw',
        description: 'JVM heap memory usage percentage (used for alerting).',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum without(item, base_url)(solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="used"}) / clamp_min(sum without(item, base_url)(solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="max"}), 1)',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
