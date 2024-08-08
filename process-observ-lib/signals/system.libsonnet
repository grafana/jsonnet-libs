function(this)
  {
    discoveryMetric: {
      // https://opentelemetry.io/docs/specs/semconv/system/process-metrics/
      otel: 'runtime_uptime',
      java_otel: self.otel,  // some system metrics are calculated differently for java
      java_micrometer: 'process_uptime_seconds',
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
      loadAverage1m: {
        name: 'Load average',
        type: 'gauge',  //show as is.
        description: "System's load average.",
        unit: 'short',
        optional: true,
        sources: {
          java_otel: {
            expr: 'process_runtime_jvm_system_cpu_load_1m{%(queriesSelector)s}',
          },
          java_micrometer: {
            expr: 'system_load_average_1m{%(queriesSelector)s}',
          },
          jmx_exporter: {
            expr: 'java_lang_operatingsystem_systemloadaverage{%(queriesSelector)s}',
          },
        },
      },
      systemCPUUsage: {
        name: 'CPU usage (system)',
        description: 'CPU Usage of host system.',
        type: 'gauge',
        unit: 'percent',  // 0-100
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'system_cpu_usage{%(queriesSelector)s} * 100',
          },
          java_otel: {
            expr: 'process_runtime_jvm_system_cpu_utilization{%(queriesSelector)s}',
          },
          jmx_exporter: {
            expr: 'java_lang_operatingsystem_cpuload{%(queriesSelector)s}',
            exprWrappers: [
              //nanoseconds
              ['', '* 100'],
            ],
          },
        },

      },

      systemCPUCount: {
        name: 'CPU count',
        type: 'gauge',
        description: "System's CPU count available to the process observed.",
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'system_cpu_count{%(queriesSelector)s}',
          },
        },
      },
    },
  }
