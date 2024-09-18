# OS process observability lib

This lib can be used to generate dashboards, rows, panels for generic OS process monitoring.

Supports the following sources:

- prometheus
- otel
- java_otel
- java_otel_with_suffixes (add_metric_suffixes=true in otelcollector)
- java_micrometer (springboot)
- jmx_exporter

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/process-observ-lib
```

