# OpenSearch Mixin

OpenSearch mixin is a set of configurable Grafana dashboards and alerts.

The OpenSearch mixin contains the following dashboards:

- OpenSearch cluster overview
- OpenSearch node overview
- OpenSearch search and index overview

and the following alerts:

- OpenSearchYellowCluster
- OpenSearchRedCluster
- OpenSearchUnstableShardReallocation
- OpenSearchUnstableShardUnassigned
- OpenSearchModerateNodeDiskUsage
- OpenSearchHighNodeDiskUsage
- OpenSearchModerateNodeCPUUsage
- OpenSearchHighNodeCPUUsage
- OpenSearchModerateNodeMemoryUsage
- OpenSearchHighNodeMemoryUsage
- OpenSearchModerateRequestLatency
- OpenSearchModerateIndexLatency

## OpenSearch Cluster Overview

The OpenSearch cluster overview dashboard provides details on cluster, node and shard status as well as cluster search and index summary details on a cluster level.

![Screenshots TODO]()
†
## OpenSearch Node Overview

The OpenSearch node overview dashboard provides details on node health, node JVM usage, thread pools, and error logs. [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. The default OpenSearch error log path is `/var/log/opensearch/opensearch.log` for each node on Linux.

OpenSearch logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `instance`, `job`, and `cluster` labels onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/opensearch
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/opensearch
          instance: '<your-instance-name>'
          cluster: '<your-cluster-name>'
          __path__: /var/log/opensearch/opensearch.log
```

![Screenshots TODO]()

## OpenSearch Search And Index Overview

The OpenSearch search and index overview dashboard provides details on request performance, index performance and index capacity. 

![Screenshots TODO]()

## Alerts Overview

OpenSearchYellowCluster: At least one of the clusters is reporting a yellow status.
OpenSearchRedCluster: At least one of the clusters is reporting a red status.
OpenSearchUnstableShardReallocation: A node has gone offline or has been disconnected triggering shard reallocation
OpenSearchUnstableShardUnassigned: A node has gone offline or has been disconnected triggering shard unassigned
OpenSearchModerateNodeDiskUsage: The node disk usage has exceeded the warning threshold.
OpenSearchHighNodeDiskUsage: The node disk usage has exceeded the critical threshold.
OpenSearchModerateNodeCPUUsage: The node CPU usage has exceeded the warning threshold.
OpenSearchHighNodeCPUUsage: The node CPU usage has exceeded the critical threshold.
OpenSearchModerateNodeMemoryUsage: The node memory usage has exceeded the warning threshold.
OpenSearchHighNodeMemoryUsage: The node memory usage has exceeded the critical threshold.
OpenSearchModerateRequestLatency: The request latency has exceeded the warning threshold.
OpenSearchModerateIndexLatency: The index latency has exceeded the warning threshold.

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
    alertsWarningShardReallocations: 0,
    alertsWarningShardUnassigned: 1,
    alertsWarningDiskUsage: 60,
    alertsCriticalDiskUsage: 80,
    alertsWarningCPUUsage: 70,
    alertsCriticalCPUUsage: 85,
    alertsWarningMemoryUsage: 70,
    alertsCriticalMemoryUsage: 85,
    alertsWarningRequestLatency: 0.5,  // seconds
    alertsWarningIndexLatency: 0.5,  // seconds
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
