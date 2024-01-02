# Apache Solr Mixin

Apache Solr mixin is a set of configurable Grafana dashboards and alerts.

The Apache Solr mixin contains the following dashboards:

- Apache Solr cluster overview
- Apache Solr query performance overview
- Apache Solr resource monitoring overview
- Apache Solr Logs overview

and the following alerts:

- ApacheSolrZookeeperChangeInEnsembleSize
- ApacheSolrHighCPUUsageCritical
- ApacheSolrHighCPUUsageWarning
- ApacheSolrHighHeapMemoryUsageCritical
- ApacheSolrHighHeapMemoryUsageWarning
- ApacheSolrLowCacheHitRatio
- ApacheSolrHighCoreErrors
- ApacheSolrHighDocumentIndexing

## Apache Solr Cluster Overview

The Apache Solr cluster overview dashboard provides details on cluster, shard, replica and Zookeeper health as well as top core and error metrics.

![Apache Solr Cluster Overview Dashboard 1](https://storage.googleapis.com/grafanalabs-integration-assets/apache-solr/screenshots/apache-solr-cluster-1.png)
![Apache Solr Cluster Overview Dashboard 2](https://storage.googleapis.com/grafanalabs-integration-assets/apache-solr/screenshots/apache-solr-cluster-2.png)

## Apache Solr Query Performance Overview

The Apache Solr query performance overview dashboard provides details on various query load and latency, update handlers, cache, timeout and error metrics.

![Apache Solr Query Performance Overview Dashboard 1](https://storage.googleapis.com/grafanalabs-integration-assets/apache-solr/screenshots/apache-solr-query-performance-1.png)
![Apache Solr Query Performance Overview Dashboard 2](https://storage.googleapis.com/grafanalabs-integration-assets/apache-solr/screenshots/apache-solr-query-performance-2.png)

## Apache Solr Resource Monitoring Overview

The Apache Solr resource monitoring overview dashboard provides details on connection, threads, core fs usage, JVM and Jetty metrics.

![Apache Solr Resource Monitoring Overview Dashboard 1](https://storage.googleapis.com/grafanalabs-integration-assets/apache-solr/screenshots/apache-solr-resource-monitoring-1.png)
![Apache Solr Resource Monitoring Overview Dashboard 2](https://storage.googleapis.com/grafanalabs-integration-assets/apache-solr/screenshots/apache-solr-resource-monitoring-2.png)

## Apache Solr Logs Overview

The Apache Solr logs overview dashboard provides details on slow requests, garbage collection, and error logs. [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. The default Apache Solr error log path is `/var/solr/logs/solr.log` for each instance on Linux.

Apache Solr logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `job` and `solr_cluster` labels onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/apache-solr
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/apache-solr
          instance: '<your-instance-name>'
          solr_cluster: '<your-cluster-name>'
          __path__: /var/log/logs/*.log
```

![Apache Solr Logs Overview Dashboard 1](https://storage.googleapis.com/grafanalabs-integration-assets/apache-solr/screenshots/apache-solr-logs-overview.png)

## Alerts Overview


| Alert                                   | Summary                                                                                                             |
|-----------------------------------------|---------------------------------------------------------------------------------------------------------------------|
| ApacheSolrZookeeperChangeInEnsembleSize | Changes in the ZooKeeper ensemble size can affect the stability and performance of the cluster.                     |
| ApacheSolrHighCPUUsageCritical          | High CPU load can indicate that Solr nodes are under heavy load, potentially impacting performance.                 |
| ApacheSolrHighCPUUsageWarning           | High CPU load can indicate that Solr nodes are under heavy load, potentially impacting performance.                 |
| ApacheSolrHighHeapMemoryUsageCritical   | High heap memory usage can lead to garbage collection issues, out-of-memory errors, and overall system instability. |
| ApacheSolrHighHeapMemoryUsageWarning    | High heap memory usage can lead to garbage collection issues, out-of-memory errors, and overall system instability. |
| ApacheSolrLowCacheHitRatio              | Low cache hit ratios can lead to increased disk I/O and slower query response times.                                |
| ApacheSolrHighCoreErrors                | A spike in core errors can indicate serious issues at the core level, affecting data integrity and availability.    |
| ApacheSolrHighDocumentIndexing          | A sudden spike in document indexing could indicate unintended or malicious bulk updates.                            |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
    alertsCriticalCPUUsage: 85,
    alertsWarningCPUUsage: 75,
    alertsWarningMemoryUsage: 85,
    alertsCriticalMemoryUsage: 75,
    alertsWarningCacheUsage: 75,
    alertsWarningCoreErrors: 15,
    alertsWarningDocumentIndexing: 30,
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
