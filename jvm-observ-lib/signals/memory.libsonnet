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
      otel_old: 'process_runtime_jvm_memory_usage',
      otel_old_with_suffixes: 'process_runtime_jvm_memory_usage_bytes',
      otel_with_suffixes: 'jvm_memory_used_bytes',
      prometheus_old: 'jvm_memory_bytes_max',
      jmx_exporter: 'java_lang_memory_heapmemoryusage_used',  //https://github.com/prometheus/jmx_exporter/blob/main/collector/src/test/java/io/prometheus/jmx/JmxCollectorTest.java#L195
    },
    signals: {
      //memory
      memoryUsedHeap: {
        name: 'JVM memory used(heap)',
        description: 'The used space is the amount of memory that is currently occupied by Java objects.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          //spring
          java_micrometer: {
            expr: 'sum without (id) (jvm_memory_used{area="heap", %(queriesSelector)s})',
          },
          java_micrometer_with_suffixes: {
            expr: 'sum without (id) (jvm_memory_used_bytes{area="heap", %(queriesSelector)s})',
          },
          prometheus: {
            expr: 'sum without (id) (jvm_memory_used_bytes{area="heap", %(queriesSelector)s})',
          },
          otel_old: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_usage{type="heap", %(queriesSelector)s})',
          },
          otel_old_with_suffixes: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_usage_bytes{type="heap", %(queriesSelector)s})',
          },
          otel_with_suffixes: {
            expr: 'sum without (jvm_memory_pool_name) (jvm_memory_used_bytes{jvm_memory_type="heap", %(queriesSelector)s})',
          },
          prometheus_old: {
            expr: 'sum without (id) (jvm_memory_bytes_used{area="heap", %(queriesSelector)s})',
          },
          jmx_exporter: {
            expr: 'java_lang_memory_heapmemoryusage_used{%(queriesSelector)s}',
          },
        },
      },
      memoryMaxHeap: {
        name: 'JVM memory max(heap)',
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
        sources: {
          java_micrometer: {
            expr: 'sum without (id) (jvm_memory_max{area="heap", %(queriesSelector)s} != -1)',
          },
          java_micrometer_with_suffixes: {
            expr: 'sum without (id) (jvm_memory_max_bytes{area="heap", %(queriesSelector)s} != -1)',
          },
          prometheus: self.java_micrometer_with_suffixes,
          otel_old: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_limit{type="heap", %(queriesSelector)s} != -1)',
          },
          otel_old_with_suffixes: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_limit_bytes{type="heap", %(queriesSelector)s} != -1)',
          },
          otel_with_suffixes: {
            expr: 'sum without (jvm_memory_pool_name) (jvm_memory_limit_bytes{jvm_memory_type="heap", %(queriesSelector)s} != -1)',
          },
          prometheus_old: {
            expr: 'sum without (id) (jvm_memory_bytes_max{area="heap", %(queriesSelector)s} != -1)',
          },
          jmx_exporter: {
            expr: 'java_lang_memory_heapmemoryusage_max{%(queriesSelector)s} != -1',
          },
        },
      },
      memoryUsedNonHeap: {
        name: 'JVM memory used(nonheap)',
        description: 'The amount of memory that is currently in non-heap.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          //spring
          java_micrometer: {
            expr: 'sum without (id) (jvm_memory_used{area="nonheap", %(queriesSelector)s})',
          },
          java_micrometer_with_suffixes: {
            expr: 'sum without (id) (jvm_memory_used_bytes{area="nonheap", %(queriesSelector)s})',
          },
          prometheus: self.java_micrometer_with_suffixes,
          otel_old: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_usage{type="non_heap", %(queriesSelector)s})',
          },
          otel_old_with_suffixes: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_usage_bytes{type="non_heap", %(queriesSelector)s})',
          },
          otel_with_suffixes: {
            expr: 'sum without (jvm_memory_pool_name) (jvm_memory_used_bytes{jvm_memory_type="non_heap", %(queriesSelector)s})',
          },
          prometheus_old: {
            expr: 'sum without (id) (jvm_memory_bytes_used{area="nonheap", %(queriesSelector)s})',
          },
          jmx_exporter: {
            expr: 'java_lang_memory_nonheapmemoryusage_used{%(queriesSelector)s}',
          },
        },
      },
      memoryMaxNonHeap: {
        name: 'JVM memory max(nonheap)',
        description: 'Measure of memory max possible (non-heap). Returns -1 if the maximum memory size is undefined.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          java_micrometer: {
            expr: 'sum without (id) (jvm_memory_max{area="nonheap", %(queriesSelector)s} != -1)',
          },
          java_micrometer_with_suffixes: {
            expr: 'sum without (id) (jvm_memory_max_bytes{area="nonheap", %(queriesSelector)s} != -1)',
          },
          prometheus: self.java_micrometer_with_suffixes,
          otel_old: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_limit{type="non_heap", %(queriesSelector)s} != -1)',
          },
          otel_old_with_suffixes: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_limit_bytes{type="non_heap", %(queriesSelector)s} != -1)',
          },
          otel_with_suffixes: {
            expr: 'sum without (jvm_memory_pool_name) (jvm_memory_limit_bytes{jvm_memory_type="non_heap", %(queriesSelector)s} != -1)',
          },
          prometheus_old: {
            expr: 'sum without (id) (jvm_memory_bytes_max{area="nonheap", %(queriesSelector)s} != -1)',
          },
          jmx_exporter: {
            expr: 'java_lang_memory_nonheapmemoryusage_max{%(queriesSelector)s} != -1',
          },
        },
      },
      memoryCommittedHeap: {
        name: 'JVM memory committed(heap)',
        description: |||
          The committed size is the amount of memory guaranteed to be available for use by the Java virtual machine.
        |||,
        type: 'gauge',
        unit: 'bytes',
        sources: {
          java_micrometer: {
            expr: 'sum without (id) (jvm_memory_committed{area="heap", %(queriesSelector)s})',
          },
          java_micrometer_with_suffixes: {
            expr: 'sum without (id) (jvm_memory_committed_bytes{area="heap", %(queriesSelector)s})',
          },
          prometheus: self.java_micrometer_with_suffixes,
          otel_old: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_committed{type="heap", %(queriesSelector)s})',
          },
          otel_old_with_suffixes: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_committed_bytes{type="heap", %(queriesSelector)s})',
          },
          otel_with_suffixes: {
            expr: 'sum without (jvm_memory_pool_name) (jvm_memory_committed_bytes{jvm_memory_type="heap", %(queriesSelector)s})',
          },
          prometheus_old: {
            expr: 'sum without (id) (jvm_memory_bytes_committed{area="heap", %(queriesSelector)s})',
          },
          jmx_exporter: {
            expr: 'java_lang_memory_heapmemoryusage_committed{%(queriesSelector)s}',
          },
        },
      },
      memoryCommittedNonHeap: {
        name: 'JVM memory committed(nonheap)',
        description: |||
          The committed size is the amount of memory guaranteed to be available for use by the Java virtual machine(non-heap).
        |||,
        type: 'gauge',
        unit: 'bytes',
        sources: {
          java_micrometer: {
            expr: 'sum without (id) (jvm_memory_committed{area="nonheap", %(queriesSelector)s})',
          },
          java_micrometer_with_suffixes: {
            expr: 'sum without (id) (jvm_memory_committed_bytes{area="nonheap", %(queriesSelector)s})',
          },
          prometheus: self.java_micrometer_with_suffixes,
          otel_old: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_committed{type="non_heap", %(queriesSelector)s})',
          },
          otel_old_with_suffixes: {
            expr: 'sum without (pool) (process_runtime_jvm_memory_committed_bytes{type="non_heap", %(queriesSelector)s})',
          },
          otel_with_suffixes: {
            expr: 'sum without (jvm_memory_pool_name) (jvm_memory_committed_bytes{jvm_memory_type="non_heap", %(queriesSelector)s})',
          },
          prometheus_old: {
            expr: 'sum without (id) (jvm_memory_bytes_committed{area="nonheap", %(queriesSelector)s})',
          },
          jmx_exporter: {
            expr: 'java_lang_memory_nonheapmemoryusage_committed{%(queriesSelector)s}',
          },
        },
      },
    },
  }
