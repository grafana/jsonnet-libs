local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      java_micrometer: 'jvm_threads_live_threads',  // https://github.com/micrometer-metrics/micrometer/blob/main/micrometer-core/src/main/java/io/micrometer/core/instrument/binder/jvm/JvmThreadMetrics.java
      prometheus: 'jvm_threads_current',  // https://prometheus.github.io/client_java/instrumentation/jvm/#jvm-memory-metrics
      otel: 'process_runtime_jvm_threads_count',
      prometheus_old: 'jvm_threads_current',
      jmx_exporter: 'java_lang_threading_threadcount',
    },
    signals: {
      threads: {
        name: 'Threads',
        description: 'The current number of live threads including both daemon and non-daemon threads.',
        type: 'gauge',
        unit: 'short',
        sources: {
          java_micrometer: {
            expr: 'jvm_threads_live_threads{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_threads_current{%(queriesSelector)s}',
          },
          otel: {
            expr: 'sum without (daemon) (process_runtime_jvm_threads_count{%(queriesSelector)s})',
          },
          prometheus_old: self.prometheus,
          jmx_exporter: {
            expr: 'java_lang_threading_threadcount{%(queriesSelector)s}',
          },
        },
      },
      threadsDaemon: {
        name: 'Threads (daemon)',
        description: 'Daemon thread count of a JVM.',
        type: 'gauge',
        unit: 'short',
        sources: {
          java_micrometer: {
            expr: 'jvm_threads_daemon_threads{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_threads_daemon{%(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_threads_count{daemon="true", %(queriesSelector)s}',
          },
          prometheus_old: self.prometheus,
          jmx_exporter: {
            expr: 'java_lang_threading_daemonthreadcount{%(queriesSelector)s}',
          },
        },


      },
      threadsPeak: {
        name: 'Threads (peak)',
        description: 'Peak thread count of a JVM.',
        type: 'gauge',
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'jvm_threads_peak_threads{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_threads_peak{%(queriesSelector)s}',
          },
          prometheus_old: self.prometheus,
          jmx_exporter: {
            expr: 'java_lang_threading_peakthreadcount{%(queriesSelector)s}',
          },
        },
      },
      threadsDeadlocked: {
        name: 'Threads (deadlocked)',
        description: 'Cycles of JVM-threads that are in deadlock waiting to acquire object monitors or ownable synchronizers.',
        type: 'gauge',
        unit: 'short',
        optional: true,
        sources: {
          prometheus: {
            expr: 'jvm_threads_deadlocked{%(queriesSelector)s}',
          },
          prometheus_old: self.prometheus,
        },
      },
      threadStates: {
        name: 'Threads states',
        description: 'Threads by current state.',
        type: 'raw',  // gauge
        unit: 'short',
        optional: true,
        sources: {
          java_micrometer: {
            expr: 'sum by (state, %(agg)s) (jvm_threads_states_threads{%(queriesSelector)s})',
            legendCustomTemplate: '{{ state }}',
          },
          //https://prometheus.github.io/client_java/instrumentation/jvm/#jvm-thread-metrics
          prometheus: {
            expr: 'sum by (state, %(agg)s) (jvm_threads_state{%(queriesSelector)s})',
            legendCustomTemplate: '{{ state }}',
          },
          prometheus_old: self.prometheus,
          //   otel: {
          //     expr: '?{%(queriesSelector)s}',
          //   },
        },
      },
    },
  }
