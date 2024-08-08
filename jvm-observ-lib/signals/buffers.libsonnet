local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      java_micrometer: 'jvm_buffer_memory_used_bytes',  // https://github.com/micrometer-metrics/micrometer/blob/main/micrometer-core/src/main/java/io/micrometer/core/instrument/binder/jvm/JvmMemoryMetrics.java
      prometheus: 'jvm_buffer_pool_used_bytes',  // https://prometheus.github.io/client_java/instrumentation/jvm/#jvm-buffer-pool-metrics
      otel: 'process_runtime_jvm_buffer_usage',
      prometheus_old: 'jvm_buffer_pool_used_bytes',
    },
    signals: {
      directBufferUsed: {
        name: 'Direct buffer used bytes',
        description: "Direct buffer is allocated outside the Java heap and represents the OS native memory used by the JVM process. It is generally used for I/O operations. Note that direct buffers aren't freed up by GC.",
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_buffer_memory_used_bytes{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_buffer_pool_used_bytes{pool="direct", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_buffer_usage{pool="direct", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_buffer_pool_used_bytes{pool="direct", %(queriesSelector)s}',
          },
        },
      },
      directBufferCapacity: {
        name: 'Direct buffer capacity',
        description: "Direct buffer is allocated outside the Java heap and represents the OS native memory used by the JVM process. It is generally used for I/O operations. Note that direct buffers aren't freed up by GC.",
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_buffer_total_capacity_bytes{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_buffer_pool_capacity_bytes{pool="direct", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_buffer_limit{pool="direct", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_buffer_pool_capacity_bytes{pool="direct", %(queriesSelector)s}',
          },
        },
      },
      mappedBufferUsed: {
        name: 'Mapped buffer used',
        description: 'The mapped buffer pool is used for its FileChannel instances.',
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_buffer_memory_used_bytes{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_buffer_pool_used_bytes{pool="mapped", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_buffer_usage{pool="mapped", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_buffer_pool_used_bytes{pool="mapped", %(queriesSelector)s}',
          },
        },
      },
      mappedBufferCapacity: {
        name: 'Mapped buffer capacity',
        description: 'The mapped buffer pool is used for its FileChannel instances.',
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_buffer_total_capacity_bytes{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_buffer_pool_capacity_bytes{pool="mapped", %(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_buffer_limit{pool="mapped", %(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_buffer_pool_capacity_bytes{pool="mapped", %(queriesSelector)s}',
          },
        },
      },
    },
  }
