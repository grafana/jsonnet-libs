# Apache HBase mixin

The Apache HBase mixin is a set of configurable Grafana dashboards and alerts.

The Apache HBase mixin contains the following dashboards:

- Apache HBase cluster overview
- Apache HBase RegionServer overview
- Apache HBase logs

and the following alerts:

- ApacheHBaseHighHeapMemUsage
- ApacheHBaseHighNonHeapMemUsage
- ApacheHBaseDeadRegionServer
- ApacheHBaseOldRegionsInTransition
- ApacheHBaseHighMasterAuthFailureRate
- ApacheHBaseHighRSAuthFailureRate

## Apache HBase overview
The Apache HBase cluster overview dashboard provides details on integration status/alerts, current RegionServers, JVM memory usage, cluster connections, master queue performance, and transitioning regions.

![First screenshot of the Apache HBase cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hbase/screenshots/apache_hbase_cluster_overview_1.png)
![Second screenshot of the Apache HBase cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hbase/screenshots/apache_hbase_cluster_overview_2.png)

## Apache HBase RegionServer overview
The Apache HBase RegionServer overview dashboard provides details on data regions, storage, connections, and request handling performance for a RegionServer node.

![First screenshot of the Apache HBase RegionServer overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hbase/screenshots/apache_hbase_region_server_overview_1.png)
![Second screenshot of the Apache HBase RegionServer overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hbase/screenshots/apache_hbase_region_server_overview_2.png)


## Apache HBase logs
The Apache HBase logs dashboard provides details on incoming system logs.

![First screenshot of the Apache HBase logs dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hbase/screenshots/apache_hbase_logs_1.png)

Apache HBase system logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `instance`, `job`, and `apache_hbase_cluster` labels onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/apache-hbase
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/apache-hbase
          instance: "<your-instance-name>"
          apache_hbase_cluster: "<your-cluster-name>"
          __path__: {hbase-home}/logs/*.log
    pipeline_stages:
        - multiline:
            firstline: '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2},\d{3}'
        - regex:
            expression: '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2},\d{3} (?P<level>\w+)  \[(?P<context>.*)\] (?P<message>(?s:.*))$'
        - labels:
            level:
            context:
```

## Alerts overview

- ApacheHBaseHighHeapMemUsage: There is a limited amount of heap memory available to the JVM.
- ApacheHBaseHighNonHeapMemUsage: There is a limited amount of non-heap memory available to the JVM.
- ApacheHBaseDeadRegionServer: One or more RegionServer(s) has become unresponsive.
- ApacheHBaseOldRegionsInTransition: RegionServers are in transition for longer than expected.
- ApacheHBaseHighMasterAuthFailureRate: A high percentage of authentication attempts to the master are failing.
- ApacheHBaseHighRSAuthFailureRate: A high percentage of authentication attempts to a RegionServer are failing.

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    alertsHighHeapMemUsage: 80        // percentage
    alertsHighNonHeapMemUsage: 80     // percentage
    alertsDeadRegionServer: 0         // count
    alertsOldRegionsInTransition: 50  // percentage
    alertsHighMasterAuthFailRate: 35  // percentage
    alertsHighRSAuthFailRate: 35      // percentage
  },
}
```

## Install tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
```

For linting and formatting, you would also need `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

`prometheus_alerts.yaml` needs to be imported into Prometheus.

## Generate dashboards and alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
