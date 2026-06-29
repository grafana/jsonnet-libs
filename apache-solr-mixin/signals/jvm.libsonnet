function(this)
  {
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
        name: 'Garbage collections',
        nameShort: 'GC count',
        type: 'raw',
        description: 'Total number of garbage collection events.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url, item) (increase(solr_metrics_jvm_gc_total{%(queriesSelector)s}[$__interval:])) > 0',
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      garbageCollectionTime: {
        name: 'Garbage collection time',
        nameShort: 'GC time',
        type: 'raw',
        description: 'Average time per garbage collection event.',
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
        type: 'raw',
        description: 'CPU load caused by the JVM.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (100 * solr_metrics_jvm_os_cpu_load{%(queriesSelector)s, item="systemCpuLoad"}) > 0',
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
        type: 'raw',
        description: 'OS free physical memory.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_os_memory_bytes{%(queriesSelector)s, item="freePhysicalMemorySize"}) > 0',
            legendCustomTemplate: '{{base_url}} - free physical',
          },
        },
      },
      osMemoryTotal: {
        name: 'OS total physical memory',
        nameShort: 'OS mem total',
        type: 'raw',
        description: 'OS total physical memory.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_os_memory_bytes{%(queriesSelector)s, item="totalPhysicalMemorySize"}) > 0',
            legendCustomTemplate: '{{base_url}} - total physical',
          },
        },
      },
      osMemoryVirtual: {
        name: 'OS committed virtual memory',
        nameShort: 'OS mem virtual',
        type: 'raw',
        description: 'OS committed virtual memory.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_os_memory_bytes{%(queriesSelector)s, item="committedVirtualMemorySize"}) > 0',
            legendCustomTemplate: '{{base_url}} - committed virtual',
          },
        },
      },
      fileDescriptors: {
        name: 'File descriptors',
        nameShort: 'File descriptors',
        type: 'raw',
        description: 'Number of open file descriptors.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url, item) (solr_metrics_jvm_os_file_descriptors{%(queriesSelector)s}) > 0',
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      memoryHeapUsed: {
        name: 'Heap memory used',
        nameShort: 'Heap used',
        type: 'raw',
        description: 'JVM heap memory used.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="used"}) > 0',
            legendCustomTemplate: '{{base_url}} - heap',
          },
        },
      },
      memoryHeapCommitted: {
        name: 'Heap memory committed',
        nameShort: 'Heap committed',
        type: 'raw',
        description: 'JVM heap memory committed.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="committed"}) > 0',
            legendCustomTemplate: '{{base_url}} - heap',
          },
        },
      },
      memoryHeapMax: {
        name: 'Heap memory max',
        nameShort: 'Heap max',
        type: 'raw',
        description: 'Maximum JVM heap memory available.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_heap_bytes{%(queriesSelector)s, item="max"}) > 0',
            legendCustomTemplate: '{{base_url}} - heap max',
          },
        },
      },
      memoryNonHeapUsed: {
        name: 'Non-heap memory used',
        nameShort: 'Non-heap used',
        type: 'raw',
        description: 'JVM non-heap memory used.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_non_heap_bytes{%(queriesSelector)s, item="used"}) > 0',
            legendCustomTemplate: '{{base_url}} - non-heap',
          },
        },
      },
      memoryNonHeapCommitted: {
        name: 'Non-heap memory committed',
        nameShort: 'Non-heap committed',
        type: 'raw',
        description: 'JVM non-heap memory committed.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (solr_metrics_jvm_memory_non_heap_bytes{%(queriesSelector)s, item="committed"}) > 0',
            legendCustomTemplate: '{{base_url}} - non-heap',
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
