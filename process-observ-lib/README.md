# OS process observability lib

This lib can be used to generate dashboards, rows, panels for generic OS process monitoring.

Supports the following sources:

- `prometheus`. Should also work for jmx_exporter in javaagent mode
- `otel`
- `java_otel`
- `java_micrometer` (springboot, can be seen when Micromter to OTEL bridge is used)
- `java_micrometer_with_suffixes` (springboot when scraped from prometheus endpoint)
- `jmx_exporter`. Works for both jmx_exporter modes: http and javaagent

If you pick `jmx_exporter` option, make sure you add the following snippet to your jmx_exporter config:

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
jb install https://github.com/grafana/jsonnet-libs/process-observ-lib
```

