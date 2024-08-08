local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      java_micrometer: 'jvm_classes_loaded_classes',  // https://github.com/micrometer-metrics/micrometer/blob/main/micrometer-core/src/main/java/io/micrometer/core/instrument/binder/jvm/ClassLoaderMetrics.java
      prometheus: 'jvm_classes_loaded',  // https://prometheus.github.io/client_java/instrumentation/jvm/#jvm-class-loading-metrics
      otel: 'process_runtime_jvm_classes_loaded',
      prometheus_old: 'jvm_classes_loaded',
      jmx_exporter: 'java_lang_classloading_loadedclasscount',
    },
    signals: {
      classesLoaded: {
        name: 'Classes loaded',
        description: 'The number of classes that are currently loaded in the JVM.',
        type: 'gauge',
        unit: 'short',
        sources: {
          java_micrometer: {
            expr: 'jvm_classes_loaded_classes{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'jvm_classes_loaded{%(queriesSelector)s}',
          },
          otel: {
            expr: 'process_runtime_jvm_classes_loaded{%(queriesSelector)s}',
          },
          prometheus_old: {
            expr: 'jvm_classes_loaded{%(queriesSelector)s}',
          },
          jmx_exporter: {
            expr: 'java_lang_classloading_loadedclasscount{%(queriesSelector)s}',
          },
        },
      },
    },
  }
