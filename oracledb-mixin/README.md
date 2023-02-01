# OracleDB Mixin

OracleDB mixin is a set of configurable alerts and dashboards that use the third party [OracleDB Exporter](https://github.com/iamseth/oracledb_exporter) using Prometheus and Loki for logs (optional).

## Alerts

| Alert                              | Description                                                           | Default Threshold |
| ---------------------------------- | --------------------------------------------------------------------- | ----------------- |
| OracledbReachingSessionLimit       | number of processess being utilized exceeded a theshold.              | 85%               |
| OracledbReachingProcessLimit       | The number of processess being utilized exceeded the threshold.       | 85%               |
| OracledbTablespaceReachingCapacity | A Tablespace is exceeded its threshold of its maximum allotted space. | 85%               |
| OracledbFileDescriptorLimit        | File descriptors usage is reaching its threshold.                     | 85%               |

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    alertsFileDescriptorThreshold: '85',  // %
    alertsProcessThreshold: '85',  // %
    alertsSessionThreshold: '85',  // %
    alertsTablespaceThreshold: '85',  // %
  },
}
```

## Dashboards

This mixin includes one dashboard: `OracleDB Overview` which includes a variety of metrics and a panel for alert logs.

OracleDB alert logs are enabled by default in the `config.libsonnet` and can be remoed by setting `enableLokiLogs` to `false` and generating the dashboards again.

```js
{
  _config+:: {
    enableLokiLogs: true,
  },
}
```

Alert logs are generally located at `$ORACLE_HOME/diag/rdbms/*/*/trace/alert_*.log` but please follow [the official documentation](http://www.dba-oracle.com/t_alert_log_location.htm) to determine the location specific to respective installs.

![Screenshot of the overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/oracledb/screenshots/oracledb_overview.png)

## Install tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
```

For linting and formatting, you would also need and `jsonnetfmt` installed. If you
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
<https://github.com/monitoring-mixins/docs>.
