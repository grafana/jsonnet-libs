# JVM observability lib

This lib can be used to generate dashboards, rows, panels, and alerts for JVM monitoring.

Supports the following sources:

- `prometheus` (https://prometheus.github.io/client_java/instrumentation/jvm/#jvm-memory-metrics). This also works for jmx_exporter (javaagent mode) starting from 1.0.1 release.
- `otel` (https://github.com/open-telemetry/opentelemetry-java-contrib/blob/main/jmx-metrics/docs/target-systems/jvm.md)
- `java_micrometer` (springboot) (https://github.com/micrometer-metrics/micrometer/blob/main/micrometer-core/src/main/java/io/micrometer/core/instrument/binder/jvm/JvmMemoryMetrics.java)
- `prometheus_old` client_java instrumentation prior to 1.0.0 release: (https://github.com/prometheus/client_java/releases/tag/v1.0.0-alpha-4). This also works for jmx_exporter (javaagent mode) prior to 1.0.1 release.
- `jmx_exporter`. Works with jmx_exporter (both http and javaagent modes) and the folllowing snippet:

```yaml
lowercaseOutputName: true
lowercaseOutputLabelNames: true
rules:
  - pattern: java.lang<type=(.+), name=(.+)><(.+)>(\w+)
    name: java_lang_$1_$4_$3_$2
  - pattern: java.lang<type=(.+), name=(.+)><>(\w+)
    name: java_lang_$1_$3_$2
  - pattern : java.lang<type=(.*)>
```


## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/jvm-observ-lib
```

## Example: Generate monitoring-mixin

```
local config = import './config.libsonnet';
local jvmlib = import 'jvm-observ-lib/main.libsonnet';
local jvm =
  jvmlib.new()
  + jvmlib.withConfigMixin(
    {
        filteringSelector: 'job!=""',
        groupLabels: ['job'],
        instanceLabels: ['instance'],
        uid: 'jvm-sample',
        dashboardNamePrefix: 'JVM',
        dashboardTags: ['java', 'jvm'],
        metricsSource: 'java_micrometer', // or java_otel, prometheus,
    }
  );
jvm.asMonitoringMixin()
```

![image](https://github.com/grafana/jsonnet-libs/assets/14870891/c5fb3763-66a1-478e-ade9-5cb3aaff81bb)