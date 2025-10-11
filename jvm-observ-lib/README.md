# JVM observability library

This library can be used to generate dashboards, rows, panels, and alerts for JVM monitoring.

Supports the following sources:

- `prometheus` (https://prometheus.github.io/client_java/instrumentation/jvm/#jvm-memory-metrics). This also works for jmx_exporter (javaagent mode) starting from 1.0.1 release.
- `otel_with_suffixes` OpenTelemetry JVM metrics following semantic conventions (https://opentelemetry.io/docs/specs/semconv/runtime/jvm-metrics/). Uses metric names like `jvm_memory_used_bytes`, `jvm_gc_duration_seconds`, etc. **Recommended for new deployments. Corresponds to semantic conventions v1.22.0 and later.**
- `otel_old` Legacy OpenTelemetry JVM metrics (https://github.com/open-telemetry/opentelemetry-java-contrib/blob/main/jmx-metrics/docs/target-systems/jvm.md). Uses `process_runtime_jvm_*` metric names. **Corresponds to semantic conventions v1.21.0 and earlier.**
- `otel_old_with_suffixes` Same as `otel_old` but with Prometheus suffixes added by the OTel collector (`add_metric_suffixes=true`). **Corresponds to semantic conventions v1.21.0 and earlier.**
- `java_micrometer` (springboot) (https://github.com/micrometer-metrics/micrometer/blob/main/micrometer-core/src/main/java/io/micrometer/core/instrument/binder/jvm/JvmMemoryMetrics.java). Can be seen when Micrometer to OTEL bridge is used.
- `java_micrometer_with_suffixes` (springboot) same, but with prometheus suffixes
- `prometheus_old` client_java instrumentation prior to 1.0.0 release: (https://github.com/prometheus/client_java/releases/tag/v1.0.0-alpha-4). This also works for jmx_exporter (javaagent mode) prior to 1.0.1 release.
- `jmx_exporter`. Works with jmx_exporter (both http and javaagent modes) and the following snippet:

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

## OpenTelemetry sources

The library supports multiple OpenTelemetry metric sources to accommodate different deployment scenarios:

### Recommended: `otel_with_suffixes`
Uses the latest OpenTelemetry JVM semantic conventions with metric names like:
- `jvm_memory_used_bytes{jvm_memory_type="heap", jvm_memory_pool_name="G1 Eden Space"}`
- `jvm_gc_duration_seconds_count{jvm_gc_name="G1 Young Generation", jvm_gc_action="end of minor GC"}`
- `jvm_thread_count{jvm_thread_daemon="true", jvm_thread_state="runnable"}`

### Legacy: `otel_old` and `otel_old_with_suffixes`
For backward compatibility with existing OpenTelemetry deployments using:
- `process_runtime_jvm_memory_usage{type="heap", pool="G1 Eden Space"}`
- `process_runtime_jvm_gc_duration_count{gc="G1 Young Generation", action="end of minor GC"}`
- `process_runtime_jvm_threads_count{daemon="true"}`

### Migration path
1. **Current users of `otel`** → migrate to `otel_old` (no functional change)
2. **Current users of `otel_with_suffixes`** → migrate to `otel_old_with_suffixes` (no functional change)  
3. **New deployments** → use `otel_with_suffixes` for semantic conventions compliance
4. **Upgrade path** → `otel_old*` → `otel_with_suffixes` when updating instrumentation

## OpenTelemetry Semantic Conventions Migration

The OpenTelemetry project introduced breaking changes to JVM metric names in semantic conventions v1.22.0 (October 2023):

- **v1.21.0 and earlier**: Used `process_runtime_jvm_*` metric names (supported by `otel_old` sources)
- **v1.22.0 and later**: Changed to `jvm.*` metric names (supported by `otel_with_suffixes` sources)

### When to use each source:

- Use `otel_old*` sources if your instrumentation produces `process_runtime_jvm_*` metrics
- Use `otel_with_suffixes` if your instrumentation produces `jvm.*` metrics  
- Check your OpenTelemetry Java instrumentation version:
  - **Before semantic conventions v1.22.0**: Use `otel_old*` sources
  - **After semantic conventions v1.22.0**: Use `otel_with_suffixes` sources


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
        metricsSource: 'otel_with_suffixes', // or java_micrometer_with_suffixes, prometheus, etc.
    }
  );
jvm.asMonitoringMixin()
```

![image](https://github.com/grafana/jsonnet-libs/assets/14870891/c5fb3763-66a1-478e-ade9-5cb3aaff81bb)