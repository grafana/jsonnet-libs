# Apache Mesos Mixin

Apache Mesos mixin is a set of configurable Grafana dashboards and alerts.

The Apache Mesos mixin contains the following dashboards:

- Apache Mesos overview

and the following alerts:

- ApacheMesosHighMemoryUsage
- ApacheMesosHighDiskUsage
- ApacheMesosUnreachableTasks
- ApacheMesosNoLeaderElected
- ApacheMesosInactiveAgents

## Apache Mesos Overview

The Apache Mesos overview dashboard provides details on resource utilization, queue usage, registrar state, allocator usage and master and agent logs. [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance.

When running the Mesos master and agent process, specify the logs director using `--log_dir=/var/log/mesos/master/` and `--log_dir=/var/log/mesos/agent/` so logs can be found in the path `/var/log/mesos/master/*.log*` and `/var/log/mesos/agent/*.log*` when ingesting logs through the Promtail config..

Logs from Apache Mesos are not enabled by default which will result in empty log panels if the following step is not performed. When running the Mesos master and agent process, specify the logs director using `--log_dir=` for both the master and agent. This path will differ depending on if you are running Linux or Windows but is required so that Promptail can ingest the logs.

For master:
`--log_dir=/var/log/mesos/master/` on Linux masters
`–-log_dir=C:\Program Files\mesos\master\` on Windows masters

For agents:
`--log_dir=/var/log/mesos/agent/` on Linux agents
`–-log_dir=C:\Program Files\mesos\agent\` on Windows agents

Apache Mesos logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for master and agent logs ingested into your logs datasource, please also include the matching `job`, and `mesos_cluster` labels onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/apache-mesos
    static_configs:
      - targets:
        - localhost
        labels:
          job: integrations/apache-mesos
          mesos_cluster: '<your-cluster-name>'
          __path__: /var/log/mesos/master/*.log*
      - targets:
        - localhost
        labels:
          job: integrations/apache-mesos
          mesos_cluster: '<your-cluster-name>'
          __path__: /var/log/mesos/agent/*.log*
```

![Apache Mesos Overview Dashboard 1](TODO)
![Apache Mesos Overview Dashboard 2](TODO)

## Alerts Overview

| Alert                       | Summary                                                  |
|-----------------------------|----------------------------------------------------------|
| ApacheMesosHighMemoryUsage  | There is a high memory usage for the cluster.            |
| ApacheMesosHighDiskUsage    | There is a high disk usage for the cluster.              |
| ApacheMesosUnreachableTasks | There are an unusually high number of unreachable tasks. |
| ApacheMesosNoLeaderElected  | There is currently no cluster coordinator.               |
| ApacheMesosInactiveAgents   | There are currently inactive agent clients.              |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
    alertsWarningMemoryUsage: 90,
    alertsCriticalDiskUsage: 90,
    alertsWarningUnreachableTask: 3,
  },
}
```

## Install Tools

For linting and formatting, you would also need `mixtool` and `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
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
