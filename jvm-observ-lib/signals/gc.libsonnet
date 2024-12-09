function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      java_micrometer: 'jvm_memory_used',
      java_micrometer_with_suffixes: 'jvm_memory_used_bytes',
      prometheus: 'jvm_memory_used_bytes',  // https://prometheus.github.io/client_java/instrumentation/jvm/#jvm-memory-metrics
      prometheus_old: 'jvm_memory_bytes_used',
      otel: 'process_runtime_jvm_memory_usage',  //https://opentelemetry.io/docs/specs/semconv/runtime/jvm-metrics/
      otel_with_suffixes: 'process_runtime_jvm_memory_usage_bytes',
    },
    signals: {

      local actionLabelPrettify = [
        'label_replace(',
        ', "action", "$1", "action", "end of (.+)")',
      ],

      //gc
      collections: {
        name: 'Garbage collections',
        description: 'Major and minor garbage collection',
        type: 'counter',
        unit: 'ops',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_gc_pause_count{%(queriesSelector)s}',
            aggKeepLabels: ['action', 'cause'],
            legendCustomTemplate: '%(aggLegend)s',
            exprWrappers: [
              actionLabelPrettify,
            ],
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_gc_pause_seconds_count{%(queriesSelector)s}',
            aggKeepLabels: ['action', 'cause'],
            legendCustomTemplate: '%(aggLegend)s',
            exprWrappers: [
              actionLabelPrettify,
            ],
          },
          prometheus: {
            expr: 'jvm_gc_collection_seconds_count{%(queriesSelector)s}',
            aggKeepLabels: ['gc'],
            legendCustomTemplate: '%(aggLegend)s',
          },
          prometheus_old: self.prometheus,
          otel: {
            expr: 'process_runtime_jvm_gc_duration_count{%(queriesSelector)s}',
            legendCustomTemplate: '%(aggLegend)s',
            aggKeepLabels: ['gc', 'action'],
            exprWrappers: [
              actionLabelPrettify,
            ],
          },
          otel_with_suffixes: self.otel {
            expr: 'process_runtime_jvm_gc_duration_seconds_count{%(queriesSelector)s}',
          },
        },
      },
      //gc
      collectionsTimeMax: {
        name: 'GC time (max)',
        description: 'Garbage collection time (max).',
        type: 'raw',
        unit: 's',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'avg by (action,cause, %(agg)s) (rate(jvm_gc_pause_max{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ %(agg)s }}: {{ action }} ({{ cause }}) (max)',
            exprWrappers: [
              actionLabelPrettify,
            ],
          },
          java_micrometer_with_suffixes: {
            expr: 'avg by (action,cause, %(agg)s) (rate(jvm_gc_pause_seconds_max{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{ %(agg)s }}: {{ action }} ({{ cause }}) (max)',
            exprWrappers: [
              actionLabelPrettify,
            ],
          },
        },
      },
      collectionsTimeAvg: {
        name: 'GC time (avg)',
        description: 'Garbage collection time (max).',
        type: 'raw',
        unit: 's',
        optional: true,
        sources: {
          java_micrometer: {
            expr: |||
              avg by (%(agg)s, action, cause) (
                rate(jvm_gc_pause_sum{%(queriesSelector)s}[$__rate_interval])
                /
                rate(jvm_gc_pause_count{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{ %(agg)s }}: {{ action }} ({{ cause }}) (avg)',
            exprWrappers: [
              actionLabelPrettify,
            ],
          },
          java_micrometer_with_suffixes: {
            expr: |||
              avg by (%(agg)s, action, cause) (
                rate(jvm_gc_pause_seconds_sum{%(queriesSelector)s}[$__rate_interval])
                /
                rate(jvm_gc_pause_seconds_count{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{ %(agg)s }}: {{ action }} ({{ cause }}) (avg)',
            exprWrappers: [
              actionLabelPrettify,
            ],
          },
          prometheus: {
            expr: |||
              avg by (%(agg)s, gc) (
                rate(jvm_gc_collection_seconds_sum{%(queriesSelector)s}[$__rate_interval])
                /
                rate(jvm_gc_collection_seconds_count{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{ %(agg)s }}: {{ gc }} (avg)',

          },
          prometheus_old: self.prometheus,
        },
      },
      collectionsTimeP95: {
        name: 'GC time (p95)',
        description: 'Garbage collection time (p95).',
        type: 'raw',
        unit: 'ms',
        optional: true,
        sources: {
          otel: {
            expr: |||
              histogram_quantile(0.95, sum(rate(process_runtime_jvm_gc_duration_bucket{%(queriesSelector)s}[$__rate_interval])) by (le,%(agg)s,action,gc))
            |||,
            legendCustomTemplate: '{{ %(agg)s }}: {{ action }} ({{ gc }}) (p95)',
            exprWrappers: [
              actionLabelPrettify,
            ],
          },
          otel_with_suffixes: self.otel {
            expr: |||
              histogram_quantile(0.95, sum(rate(process_runtime_jvm_gc_duration_seconds_bucket{%(queriesSelector)s}[$__rate_interval])) by (le,%(agg)s,action,gc))
            |||,
          },
        },
      },

      memPromotedBytes: {
        name: 'Promoted',
        description: 'Memory promoted to Tenured Space.',
        type: 'counter',
        rangeFunction: 'increase',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_gc_memory_promoted{%(queriesSelector)s}',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_gc_memory_promoted_bytes_total{%(queriesSelector)s}',
          },
        },
      },
      memAllocatedBytes: {
        name: 'Allocated (bytes)',
        description: 'Memory allocated to Eden Space.',
        type: 'counter',
        rangeFunction: 'increase',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_gc_memory_allocated{%(queriesSelector)s}',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_gc_memory_allocated_bytes_total{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_memory_pool_allocated_bytes_total{pool=~"(G1 |PS )?Eden Space",%(queriesSelector)s}',
          },
          prometheus_old: self.prometheus,
        },
      },
      memAllocated: {
        name: 'Allocated',
        description: 'Memory allocated to Eden Space.',
        type: 'raw',
        rangeFunction: 'increase',
        unit: 'allocs',
        optional: true,
        sources: {
          otel: {
            expr: |||
              topk(10,
                avg by (%(agg)s, arena, thread_name) (rate(process_runtime_jvm_memory_allocation_count{%(queriesSelector)s}[$__rate_interval]))
              )
            |||,
            legendCustomTemplate: '{{ %(agg)s }}: Allocated ({{ thread_name }}, {{ arena }})',
          },
          otel_with_suffixes: self.otel,
        },
      },


      //G1 Eden
      memoryUsedEden: {
        name: 'Eden Space (used)',
        description: 'Memory used for G1 Eden Space Collection.',
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          //spring
          java_micrometer: {
            expr: 'jvm_memory_used_bytes{id=~"(G1 |PS )?Eden Space", area="heap", %(queriesSelector)s}',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_used{id=~"(G1 |PS )?Eden Space", area="heap", %(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_memory_pool_used_bytes{pool=~"(G1 |PS )?Eden Space", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_used{pool=~"(G1 |PS )?Eden Space", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_memory_usage{type="heap", pool=~"(G1 |PS )?Eden Space", %(queriesSelector)s}',
          },
          otel_with_suffixes: {
            expr: 'process_runtime_jvm_memory_usage_bytes{type="heap", pool=~"(G1 |PS )?Eden Space", %(queriesSelector)s}',
          },
        },
      },
      memoryMaxEden: {
        name: 'Eden Space (max)',
        description: |||
          The max heap size is the size specified via the -Xmx flag.
          Returns -1 if the maximum memory size is undefined.

          This amount of memory is not guaranteed to be available for memory management
          if it is greater than the amount of committed memory.
          The Java virtual machine may fail to allocate memory even if the amount of used memory does not exceed this maximum size.

          See also: https://docs.oracle.com/javase/10/docs/api/java/lang/management/MemoryUsage.html
        |||,
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_memory_max{id=~"(G1 )?Eden Space", area="heap", %(queriesSelector)s}',
            exprWrappers: [
              ['', ' != -1'],
            ],
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_max_bytes{id=~"(G1 )?Eden Space", area="heap", %(queriesSelector)s}',
            exprWrappers: [
              ['', ' != -1'],
            ],
          },
          prometheus: {
            expr: 'jvm_memory_pool_max_bytes{pool=~"(G1 |PS )?Eden Space", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_max{pool=~"(G1 |PS )?Eden Space", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_memory_limit{pool=~"(G1 |PS )?Eden Space", type="heap", %(queriesSelector)s}',
            exprWrappers: [
              ['', ' != -1'],
            ],
          },
          otel_with_suffixes: self.otel {
            expr: 'process_runtime_jvm_memory_limit_bytes{pool=~"(G1 |PS )?Eden Space", type="heap", %(queriesSelector)s}',
          },
        },
      },
      memoryCommittedEden: {
        name: 'Eden Space (committed)',
        description: |||
          The committed size is the amount of memory guaranteed to be available for use by the Java virtual machine.
        |||,
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_memory_committed{id=~"(G1 |PS )?Eden Space", area="heap", %(queriesSelector)s}',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_committed_bytes{id=~"(G1 |PS )?Eden Space", area="heap", %(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_memory_pool_committed_bytes{pool=~"(G1 |PS )?Eden Space", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_committed{pool=~"(G1 |PS )?Eden Space", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_memory_committed{pool=~"(G1 |PS )?Eden Space", type="heap", %(queriesSelector)s}',
          },
          otel_with_suffixes: {
            expr: 'process_runtime_jvm_memory_committed_bytes{pool=~"(G1 |PS )?Eden Space", type="heap", %(queriesSelector)s}',
          },
        },
      },


      // Survival
      memoryUsedSurvival: {
        name: 'Survival space (used)',
        description: 'Memory used for Survival collection.',
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          //spring
          java_micrometer: {
            expr: 'jvm_memory_used{id=~"(G1 |PS )?Survivor Space", area="heap", %(queriesSelector)s}',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_used_bytes{id=~"(G1 |PS )?Survivor Space", area="heap", %(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_memory_pool_used_bytes{pool=~"(G1 |PS )?Survivor Space", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_used{pool=~"(G1 |PS )?Survivor Space", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_memory_usage{type="heap", pool=~"(G1 |PS )?Survivor Space", %(queriesSelector)s}',
          },
          otel_with_suffixes: {
            expr: 'process_runtime_jvm_memory_usage_bytes{type="heap", pool=~"(G1 |PS )?Survivor Space", %(queriesSelector)s}',
          },
        },
      },
      memoryMaxSurvival: {
        name: 'Survival space (max)',
        description: |||
          The max heap size is the size specified via the -Xmx flag.
          Returns -1 if the maximum memory size is undefined.

          This amount of memory is not guaranteed to be available for memory management
          if it is greater than the amount of committed memory.
          The Java virtual machine may fail to allocate memory even if the amount of used memory does not exceed this maximum size.

          See also: https://docs.oracle.com/javase/10/docs/api/java/lang/management/MemoryUsage.html
        |||,
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_memory_max{id=~"(G1 |PS )?Survivor Space", area="heap", %(queriesSelector)s} != -1',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_max_bytes{id=~"(G1 |PS )?Survivor Space", area="heap", %(queriesSelector)s} != -1',
          },
          prometheus: {
            expr: 'jvm_memory_pool_max_bytes{pool=~"(G1 |PS )?Survivor Space", %(queriesSelector)s} != -1',
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_max{pool=~"(G1 |PS )?Survivor Space", %(queriesSelector)s} != -1',
          },
          otel: {
            expr: 'process_runtime_jvm_memory_limit{pool=~"(G1 |PS )?Survivor Space", type="heap", %(queriesSelector)s} != -1',
          },
          otel_with_suffixes: {
            expr: 'process_runtime_jvm_memory_limit_bytes{pool=~"(G1 |PS )?Survivor Space", type="heap", %(queriesSelector)s} != -1',
          },
        },
      },
      memoryCommittedSurvival: {
        name: 'Survival space (committed)',
        description: |||
          The committed size is the amount of memory guaranteed to be available for use by the Java virtual machine.
        |||,
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_memory_committed{id=~"(G1 |PS )?Survivor Space", area="heap", %(queriesSelector)s}',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_committed_bytes{id=~"(G1 |PS )?Survivor Space", area="heap", %(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_memory_pool_committed_bytes{pool=~"(G1 |PS )?Survivor Space", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_committed{pool=~"(G1 |PS )?Survivor Space", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_memory_committed{pool=~"(G1 |PS )?Survivor Space", type="heap", %(queriesSelector)s}',
          },
          otel_with_suffixes: {
            expr: 'process_runtime_jvm_memory_committed_bytes{pool=~"(G1 |PS )?Survivor Space", type="heap", %(queriesSelector)s}',
          },
        },
      },

      // Tenured
      memoryUsedTenured: {
        name: 'Tenured space (used)',
        description: 'Memory used for Tenured(Old Gen) collection.',
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          //spring
          java_micrometer: {
            expr: 'jvm_memory_used{id="Tenured Gen", area="heap", %(queriesSelector)s}',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_used_bytes{id="Tenured Gen", area="heap", %(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_memory_pool_used_bytes{pool="PS Old Gen", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_used{pool="G1 Old Gen", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_memory_usage{type="heap", pool=~"G1 Old Gen|Tenured Gen", %(queriesSelector)s}',
          },
          otel_with_suffixes: {
            expr: 'process_runtime_jvm_memory_usage_bytes{type="heap", pool=~"G1 Old Gen|Tenured Gen", %(queriesSelector)s}',
          },
        },
      },
      memoryMaxTenured: {
        name: 'Tenured space (max)',
        description: |||
          The max heap size is the size specified via the -Xmx flag.
          Returns -1 if the maximum memory size is undefined.

          This amount of memory is not guaranteed to be available for memory management
          if it is greater than the amount of committed memory.
          The Java virtual machine may fail to allocate memory even if the amount of used memory does not exceed this maximum size.

          See also: https://docs.oracle.com/javase/10/docs/api/java/lang/management/MemoryUsage.html
        |||,
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_memory_max{id="Tenured Gen", area="heap", %(queriesSelector)s}',
            exprWrappers: [
              ['', ' != -1'],
            ],
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_max_bytes{id="Tenured Gen", area="heap", %(queriesSelector)s}',
            exprWrappers: [
              ['', ' != -1'],
            ],
          },
          prometheus: {
            expr: 'jvm_memory_pool_used_bytes{pool="PS Old Gen", %(queriesSelector)s}',
            exprWrappers: [
              ['', ' != -1'],
            ],
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_max{pool="G1 Old Gen", %(queriesSelector)s}',
            exprWrappers: [
              ['', ' != -1'],
            ],
          },
          otel: {
            expr: 'process_runtime_jvm_memory_limit{pool=~"G1 Old Gen|Tenured Gen", type="heap", %(queriesSelector)s}',
            exprWrappers: [
              ['', ' != -1'],
            ],
          },
          otel_with_suffixes: self.otel {
            expr: 'process_runtime_jvm_memory_limit_bytes{pool=~"G1 Old Gen|Tenured Gen", type="heap", %(queriesSelector)s}',
          },
        },
      },
      memoryCommittedTenured: {
        name: 'Tenured space (committed)',
        description: |||
          The committed size is the amount of memory guaranteed to be available for use by the Java virtual machine.
        |||,
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_memory_committed{id="Tenured Gen", area="heap", %(queriesSelector)s}',
          },
          java_micrometer_with_suffixes: {
            expr: 'jvm_memory_committed_bytes{id="Tenured Gen", area="heap", %(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_memory_pool_committed_bytes{pool="PS Old Gen", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_memory_pool_bytes_committed{pool="G1 Old Gen", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_memory_committed{pool=~"G1 Old Gen|Tenured Gen", type="heap", %(queriesSelector)s}',
          },
          otel_with_suffixes: {
            expr: 'process_runtime_jvm_memory_committed_bytes{pool=~"G1 Old Gen|Tenured Gen", type="heap", %(queriesSelector)s}',
          },
        },
      },
    },
  }
