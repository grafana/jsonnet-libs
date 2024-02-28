# PgBouncer Mixin
The PgBouncer mixin is a set of configurable Grafana dashboards and alerts.

The PgBouncer mixin contains the following dashboards:

- PgBouncer cluster overview
- PgBouncer overview
- PgBouncer logs overview

and the following alerts:

- HighNumberClientWaitingConnections
- HighClientWaitTime
- HighServerConnectionSaturationWarning
- HighServerConnectionSaturationCritical
- HighNetworkTraffic

## PgBouncer Cluster Overview

The PgBouncer cluster overview dashboard provides details on active connections, query durations, query processing, network traffic, and alerts.

![PgBouncer Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/pgbouncer/screenshots/pgbouncer-cluster-overview.png)

## PgBouncer Overview

The PgBouncer overview dashboard provides details on active connections, query durations, query processing, network traffic, config details, client connections, SQL transactions, and wait times.

![PgBouncer Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/pgbouncer/screenshots/pgbouncer-overview.png)

## PgBouncer Logs Overview

The PgBouncer logs overview dashboard provides details on the PgBouncer system. [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. The default PgBouncer log path is `/var/log/postgresql/pgbouncer.log`, but this can change depending on the path you provide in your `pgbouncer.ini` configuration file.

![PgBouncer Logs Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/pgbouncer/screenshots/pgbouncer-logs-overview.png)

PgBouncer logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `job` label onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/pgbouncer
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/pgbouncer
          __path__: /var/log/postgresql/pgbouncer.log
          pgbouncer_cluster: cluster-A
          instance: localhost:9127
    pipeline_stages:
      - multiline:
          firstline: '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3}'
      - regex:
          expression: '\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{3} \w+ \[\d+\] (?P<level>LOG|ERROR|WARNING|INFO|DEBUG) .*'
      - labels:
          level:
```

![PgBouncer Logs Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/pgbouncer/screenshots/pgbouncer-logs-overview.png)

## Alerts Overview

| Alert                                  | Summary                                                                                                                                                                 |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HighNumberClientWaitingConnections     | High number of clients waiting a connection, which may indicate a bottleneck in connection pooling, where too many clients are waiting for available server connections |
| HighClientWaitTime                     | Clients are experiencing significant delays, which could indicate issues with connection pool saturation or server performance.                                         |
| HighServerConnectionSaturationWarning  | System is nearing a high number of user connections, near the threshold of configured max user connections.                                                             |
| HighServerConnectionSaturationCritical | System is nearing a critically high number of user connections, near the threshold of configured max user connections.                                                  |
| HighNetworkTraffic                     | A significant spike over the average peak of network traffic was observed, may indicate unusual activity or an increase in load.                                        |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
  alertsHighClientWaitingConnections: 20,
  alertsHighClientWaitTime: 15,
  alertsHighServerConnectionSaturationWarning: 80,
  alertsHighServerConnectionSaturationCritical: 90,
  alertsHighNetworkTraffic: 50,
  },
}
```

## Install Tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
# or in brew: brew install go-jsonnet
```

For linting and formatting, you would also need `mixtool` and `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

`prometheus_alerts.yaml` needs to be imported into Prometheus.

## Generate Dashboards And Alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.

