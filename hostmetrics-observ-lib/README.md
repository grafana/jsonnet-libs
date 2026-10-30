# Hostmetrics observ lib

This observ lib can be used to generate an observ package for hosts monitored with the [hostmetrics receiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/hostmetricsreceiver), with metrics sent over OTLP.

Metric names follow OpenTelemetry semantic conventions. Dashboards cover Linux hosts: fleet overview, host overview, CPU and system, memory, filesystem and disks, and network.

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/hostmetrics-observ-lib
```

## Metric names

OTLP ingestion can store metrics with or without unit and type suffixes, for example `system_cpu_utilization` or `system_cpu_utilization_ratio`. You can set `metricsSource` to match your backend:

| Value | Metric names |
|---|---|
| `otel` | Without suffixes, for example `system_memory_usage`. Grafana Cloud stores them this way. |
| `otel_with_suffixes` | With suffixes, for example `system_memory_usage_bytes`. Prometheus stores them this way by default. |

The default is both, `['otel', 'otel_with_suffixes']`, so dashboards and alerts work with either. The suffixes for each metric are listed in [signals/common.libsonnet](signals/common.libsonnet).

The receiver must also run the `resourcedetection` processor with the `system` detector so that `target_info` carries `host_name`, `host_arch` and `os_description`, and set `service.namespace`, `service.name` and `service.instance.id` so that the `job` and `instance` labels are populated.

## Example

```jsonnet
// mixin.libsonnet
local hostmetricslib = import 'github.com/grafana/jsonnet-libs/hostmetrics-observ-lib/main.libsonnet';

local hostmetrics =
  hostmetricslib.new()
  + hostmetricslib.withConfigMixin({
    filteringSelector: 'job="integrations/linux-hostmetrics"',
    uid: 'linux-hostmetrics',
    dashboardNamePrefix: 'Linux Hostmetrics / ',
    dashboardTags: ['linux-hostmetrics'],
    metricsSource: ['otel'],
    // Match the scrapers enabled in the receiver. Panels for disabled scrapers are not rendered.
    enablePagingScraper: true,
    enableNetworkScraper: true,
  });

hostmetrics.asMonitoringMixin()
```

## Logs

Set `enableLokiLogs: true` to add a logs dashboard. By default it expects logs with the same `job` and `instance` labels as the metrics.

Logs sent over OTLP are labeled from resource attributes instead. Set the logs options to match, for example:

```jsonnet
enableLokiLogs: true,
logsFilteringSelector: 'service_namespace="integrations", service_name="linux-hostmetrics"',
logsGroupLabels: ['service_name'],
logsInstanceLabels: ['service_instance_id'],
extraLogLabels: [],
logsVolumeGroupBy: 'detected_level',
logsExtraFilters:
  |||
    | line_format `{{ if eq "[[instance]]" ".*" }}{{alignLeft 25 .service_instance_id}}|{{end}} {{__line__}}`
  |||,
```

The links at the top of each dashboard keep the selected host when you move between dashboards, including to and from the logs dashboard. To enable that with OTLP logs the logs dashboard's host variable is named `instance` even though it filters on `service_instance_id`.

## Options

See [config.libsonnet](config.libsonnet) for all options, including alert thresholds.
