# Presto mixin

The Presto mixin is a set of configurable Grafana dashboards and alerts.

The Presto mixin contains the following dashboards:

- Presto overview
- Presto coordinator overview
- Presto worker overview
- Presto logs overview

and the following alerts:

- PrestoHighInsufficientFailures
- PrestoHighTaskFailuresWarning
- PrestoHighTaskFailuresCritical
- PrestoHighQueuedTaskCount
- PrestoHighBlockedNodes
- PrestoHighFailedQueriesWarning
- PrestoHighFailedQueriesCritical

## Presto overview
The Presto cluster overview dashboard provides details on integration status/alerts, workers/coordinators, error failures, data throughput, blocked nodes, and distributed bytes.
![First screenshot of the Presto cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/presto/screenshots/presto_overview_1.png)
![Second screenshot of the Presto cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/presto/screenshots/presto_overview_2.png)

## Presto coordinator overview
The Presto coordinator overview dashboard provides details on various query counts and rates, query execution time, CPU time consumed, CPU input throughput, error failures, JVM metrics, and memory pool information.
![First screenshot of the Presto coordinator overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/presto/screenshots/presto_coordinator_overview_1.png)
![Second screenshot of the Presto coordinator overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/presto/screenshots/presto_coordinator_overview_2.png)

## Presto worker overview
The Presto worker overview dashboard provides details on various task rates, pool sizes, output positions, data throughput, JVM metrics, and memory pool information
![First screenshot of the Presto coordinator overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/presto/screenshots/presto_worker_overview_1.png)
![Second screenshot of the Presto coordinator overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/presto/screenshots/presto_worker_overview_2.png)

## Presto logs
The Presto logs dashboard provides details on incoming system logs.

![First screenshot of the Presto logs dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/presto/screenshots/presto_logs_overview.png)

Presto system logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `instance`, `job`, and `presto_cluster` labels onto the [scrape configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/presto
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/presto
          instance: "<your-instance-name>"
          presto_cluster: "<your-cluster-name>"
          __path__: /var/presto/logs/*.log
    pipeline_stages:
        - multiline:
            firstline: '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}'
        - regex:
            expression: '\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{3}Z\s+(?P<level>\w+)(?P<message>.+)'
        - labels:
            level:
```

## Alerts overview

- PrestoHighInsufficientFailures: The amount of failures that are occurring due to insufficient resources are scaling, causing saturation in the system.
- PrestoHighTaskFailuresWarning: The amount of tasks that are failing is increasing, this might affect query processing and could result in incomplete or incorrect results.
- PrestoHighTaskFailuresCritical: The amount of tasks that are failing has reached a critical level. This might affect query processing and could result in incomplete or incorrect results.
- PrestoHighQueuedTaskCount: The amount of tasks that are being put in queue is increasing. A high number of queued tasks can lead to increased query latencies and degraded system performance.
- PrestoHighBlockedNodes: The amount of nodes that are blocked due to memory restrictions is increasing. Blocked nodes can cause performance degradation and resource starvation.
- PrestoHighFailedQueriesWarning: The amount of queries failing is increasing. Failed queries can prevent users from accessing data, disrupt analytics processes, and might indicate underlying issues with the system or data.
- PrestoHighFailedQueriesCritical: The amount of queries failing has increased to critical levels. Failed queries can prevent users from accessing data, disrupt analytics processes, and might indicate underlying issues with the system or data.

Default thresholds can be configured in `config.libsonnet`.

```js
{
    _configs+:: {

        // alerts thresholds
        alertsHighInsufficientResourceErrors: 0, // count
        alertsHighTaskFailuresWarning: 0, // count
        alertsHighTaskFailuresCritical: 30, // percent
        alertsHighQueuedTaskCount: 5, // count
        alertsHighBlockedNodesCount: 0, // count
        alertsHighFailedQueryCountWarning: 0, // count
        alertsHighFailedQueryCountCritical: 30, // percent
    }
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
