# JVM observability lib

This lib can be used to generate dashboards, rows, panels, and alerts for JVM monitoring.

Supports the following sources:

- prometheus (https://prometheus.github.io/client_java/instrumentation/jvm/#jvm-memory-metrics)
- otel (https://github.com/open-telemetry/opentelemetry-java-contrib/blob/main/jmx-metrics/docs/target-systems/jvm.md)
- java_micrometer (springboot) (https://github.com/micrometer-metrics/micrometer/blob/main/micrometer-core/src/main/java/io/micrometer/core/instrument/binder/jvm/JvmMemoryMetrics.java)

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/jvm-observ-lib
```
