# OpenTelemetry Collector observability library

This library can be used to generate dashboards, rows, panels, and alerts for [OpenTelemetry Collector internal telemetry](https://opentelemetry.io/docs/collector/internal-telemetry/) .

Supports the following sources:

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/opentelemetry-collector-observ-lib
```

## Example: Generate monitoring-mixin

```.jsonnet
local otelcollib = import 'opentelemetry-collector-observ-lib/main.libsonnet';
local otelcol =
  otelcollib.new()
  + otelcollib.withConfigMixin(
    {
        filteringSelector: 'job!=""',
    }
  );
otelcollib.asMonitoringMixin()
```
