# Hostmetrics observ lib

This observ lib can be used to generate an observ package for hosts monitored with the [hostmetrics receiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/hostmetricsreceiver), with metrics sent over OTLP.

Metric names follow OpenTelemetry semantic conventions. Dashboards cover Linux hosts: fleet overview, host summary, CPU and system, memory, filesystem and disks, network, and logs.

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

## Receiver configuration

The dashboards and alerts use metrics and resource attributes that the hostmetrics receiver and the `system` resource detector don't send by default. The config below sends all of them. The `job` label is `service.name`, or `service.namespace/service.name` if you set a namespace. The `instance` label is `service.instance.id`.

The default `filteringSelector` is empty, so it matches any job. To show only these hosts, set it to `job="<your-namespace>/<your-service-name>"`.

```yaml
receivers:
  hostmetrics:
    scrapers:
      cpu:
        metrics:
          system.cpu.utilization: {enabled: true, attributes: [cpu, state]}
          system.cpu.logical.count: {enabled: true}
          system.cpu.physical.count: {enabled: true}
          system.cpu.frequency: {enabled: true}
      load:
      memory:
        metrics:
          system.memory.utilization: {enabled: true}
          system.memory.limit: {enabled: true}
          system.linux.memory.available: {enabled: true}
          system.linux.memory.dirty: {enabled: true}
          system.memory.linux.shared: {enabled: true}
      disk:
      filesystem:
        metrics:
          system.filesystem.utilization: {enabled: true}
      network:
        metrics:
          system.network.conntrack.count: {enabled: true}
          system.network.conntrack.max: {enabled: true}
      paging:
      processes:
      system:

processors:
  resource_detection:
    detectors: [system]
    system:
      resource_attributes:
        host.arch: {enabled: true}
        os.description: {enabled: true}
  resource:
    attributes:
      - key: service.namespace
        value: <your-namespace>
        action: upsert
      - key: service.name
        value: <your-service-name>
        action: upsert
      - key: service.instance.id
        from_attribute: host.name
        action: insert
```

The `network` and `paging` scrapers are optional: set `enableNetworkScraper` or `enablePagingScraper` to `false` if you leave them out.

## Example

```jsonnet
// mixin.libsonnet
local hostmetricslib = import 'github.com/grafana/jsonnet-libs/hostmetrics-observ-lib/main.libsonnet';

local hostmetrics =
  hostmetricslib.new()
  + hostmetricslib.withConfigMixin({
    filteringSelector: 'job="integrations/linux-hostmetrics"',
    logsFilteringSelector: 'service_namespace="integrations", service_name="linux-hostmetrics"',
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

The logs dashboard is on by default. Set `enableLokiLogs: false` to leave it out. By default it expects logs sent over OTLP, which Loki labels from resource attributes: `service_name` and `service_instance_id` where the metrics have `job` and `instance`. Set `logsFilteringSelector` to pick out your hosts' logs, for example `'service_namespace="integrations", service_name="linux-hostmetrics"'`.

For logs pushed to Loki with the same `job` and `instance` labels as the metrics, such as journald logs collected with Alloy's `loki.source.journal`, set the logs options to match, for example:

```jsonnet
logsFilteringSelector: 'job!=""',
logsGroupLabels: ['job'],
logsInstanceLabels: ['instance'],
extraLogLabels: ['transport', 'unit', 'level'],
logsVolumeGroupBy: 'level',
logsExtraFilters:
  |||
    | line_format `{{ if eq "[[instance]]" ".*" }}{{alignLeft 25 .instance}}|{{end}}{{alignLeft 25 .unit}}| {{__line__}}`
  |||,
```

The links at the top of each dashboard keep the selected host when you move between dashboards, including to and from the logs dashboard. To enable that with OTLP logs the logs dashboard's host variable is named `instance` even though it filters on `service_instance_id`.

## Alerts

| Alert | Summary |
|---|---|
| `HostmetricsHostDown` | No host metrics received. |
| `HostmetricsCPUHighUsage` | Host CPU usage is high. |
| `HostmetricsMemoryHighUtilization` | Host memory usage is high. |
| `HostmetricsDiskSpaceLow` | Filesystem is nearly full (warning) or critically full (critical). |
| `HostmetricsInodesLow` | Filesystem is running out of inodes (warning) or almost out (critical). |
| `HostmetricsSystemSaturation` | Host load average is high relative to core count. |
| `HostmetricsDiskIOSaturation` | Disk I/O queue is high. |
| `HostmetricsProcessesHigh` | Many processes are running. |
| `HostmetricsHostRebooted` | Host has rebooted. |
| `HostmetricsNetworkErrors` | Network interface has a high error rate. Needs `enableNetworkScraper`. |
| `HostmetricsConntrackHighUsage` | Connection tracking table is filling up. Needs `enableNetworkScraper`. |
| `HostmetricsMemoryMajorPageFaults` | Memory major page faults are high. Needs `enablePagingScraper`. |

## Options

See [config.libsonnet](config.libsonnet) for all options, including alert thresholds.
