function(this)
  {
    discoveryMetric: {
      // https://opentelemetry.io/docs/specs/semconv/system/process-metrics/

      otel: 'runtime_uptime',
      java_otel: self.otel,  // some system metrics are calculated differently for java. (see system.libsonnet)
      java_micrometer: 'process_uptime_seconds',  // https://docs.spring.io/spring-boot/docs/1.3.3.RELEASE/reference/html/production-ready-metrics.html

      // https://prometheus.github.io/client_java/instrumentation/jvm/#process-metrics
      // https://github.com/prometheus/client_golang
      prometheus: 'process_start_time_seconds',

      // acceptable if container has single process running
      cadvisor: 'container_cpu_usage_seconds_total',
    },
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',  // group, instance, or none.
    alertsInterval: '5m',
    signals: {
      uptime: {
        name: 'Uptime',
        type: 'raw',
        description: 'Process uptime.',
        unit: 'dtdurations',  //duration in seconds
        optional: true,
        sources: {
          prometheus:
            {
              expr: 'time()-process_start_time_seconds{%(queriesSelector)s}',
            },
          otel: {
            expr: 'runtime_uptime{%(queriesSelector)s}/1000',
          },
          java_otel: self.otel,
          java_micrometer: {
            expr: 'process_uptime_seconds{%(queriesSelector)s}',
          },
        },
      },
      startTime: {
        name: 'Process start time',
        type: 'gauge',
        description: 'Process start time.',
        unit: 'dateTimeAsIso',
        sources: {
          java_micrometer: {
            expr: 'process_start_time_seconds{%(queriesSelector)s} * 1000',
          },
          prometheus:
            {
              expr: 'process_start_time_seconds{%(queriesSelector)s} * 1000',
            },
          otel: {
            expr: 'process_start_time{%(queriesSelector)s} * 1000',
          },
          java_otel: self.otel,
          cadvisor: {
            cadvisor: 'container_start_time_seconds{%(queriesSelector)s}',
          },
        },
      },
      // cpuUsage
      processCPUUsage: {
        name: 'CPU usage (process)',
        type: 'gauge',
        description: 'Process CPU usage.',
        unit: 'percent',  // 0-100
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'process_cpu_usage{%(queriesSelector)s} * 100',
          },
          // otel: {
          //   // expr: 'process_runtime_jvm_cpu_utilization{%(queriesSelector)s}',
          //   expr: '?',
          // },
          java_otel: {
            expr: 'process_runtime_jvm_cpu_utilization{%(queriesSelector)s} * 100',
          },
          prometheus: {
            // convert to gauge from counter to match others here.
            expr: 'rate(process_cpu_seconds_total{%(queriesSelector)s}[%(interval)s]) * 100',
          },
          cadvisor: {
            expr: 'rate(container_cpu_usage_seconds_total{cpu="total", %(queriesSelector)s}[%(interval)s]) * 100',
          },
        },
      },

      memoryUsedResident: {
        name: 'Process memory used (rss)',
        description: 'Process resident memory size in bytes.',
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          // java_micrometer: {
          //   expr: '?{%(queriesSelector)s}',
          // },
          // otel: {
          //   expr: '?{%(queriesSelector)s}',
          // },
          prometheus: {
            expr: 'process_resident_memory_bytes{%(queriesSelector)s}',
          },
          cadvisor: {
            expr: 'container_memory_rss{%(queriesSelector)s}',
          },
        },
      },
      memoryUsedVirtual: {
        name: 'Process memory used (virtual)',
        description: 'Process virtual memory size in bytes.',
        type: 'gauge',
        unit: 'bytes',
        optional: true,
        sources: {
          // java_micrometer: {
          //   expr: '?{%(queriesSelector)s}',
          // },
          // otel: {
          //   expr: '?{%(queriesSelector)s}',
          // },
          prometheus: {
            expr: 'process_virtual_memory_bytes{%(queriesSelector)s}',
          },
        },
      },

      // files open
      // process_files_open_files
      filesOpen: {
        name: 'Process files open',
        type: 'gauge',
        description: 'Process files opened.',
        optional: true,
        sources: {
          otel: {
            expr: 'process_files_open{%(queriesSelector)s}',
          },
          java_otel: self.otel,
          java_micrometer: {
            expr: 'process_files_open_files{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'process_open_fds{%(queriesSelector)s}',
          },
        },
      },
      filesMax: {
        name: 'Process files max',
        type: 'gauge',
        description: 'Process files opened limit.',
        optional: true,
        sources: {
          otel: {
            expr: 'process_files_max{%(queriesSelector)s}',
          },
          java_otel: self.otel,
          java_micrometer: {
            expr: 'process_files_max_files{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'process_max_fds{%(queriesSelector)s}',
          },
          cadvisor: {
            expr: 'container_ulimits_soft{%(queriesSelector)s}',
          },
        },
      },
    },
  }
