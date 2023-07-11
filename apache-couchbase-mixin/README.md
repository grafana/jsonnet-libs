# Apache Couchbase Mixin

The Apache Couchbase mixin is a set of configurable Grafana dashboards and alerts.

The Apache Couchbase mixin contains the following dashboards:

- Apache Couchbase cluster overview
- Apache Couchbase node overview
- Apache Couchbase bucket overview

and the following alerts:

- ApacheCouchbaseHighCPUUsage
- ApacheCouchbaseHighMemoryUsage
- ApacheCouchbaseMemoryEvictionRate
- ApacheCouchbaseInvalidRequestVolume

## Apache Couchbase Cluster Overview

The Apache Couchbase cluster overview dashboard provides details on the top nodes and buckets for a cluster, including memory and disk usage, network requests, key service metrics, rate of operations, along with replication metrics at all levels of a Couchbase cluster.

![First screenshot of the Apache Couchbase cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchbase/screenshots/cluster-overview-1.png)
![Second screenshot of the Apache Couchbase cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchbase/screenshots/cluster-overview-2.png)

## Apache Couchbase Node Overview

The Apache Couchbase node overview dashboard provides details on memory usage, cpu usage, network request info (request methods and response codes), query service request info (volume, type, and processing time), index service performance (request volume, cache hit ratio, and scan latency), and both error and couchdb logs. The default Couchbase system log path is `/opt/couchbase/var/lib/couchbase/logs` on Linux, or `C:\Program\Files\Couchbase\Server\var\lib\couchbase\logs` on Windows.

![First screenshot of the Apache Couchbase node overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchbase/screenshots/node-overview-1.png)
![Second screenshot of the Apache Couchbase node overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchbase/screenshots/node-overview-2.png)
![Third screenshot of the Apache Couchbase node overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchbase/screenshots/node-overview-3.png)

Couchbase system logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

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
  - job_name: integrations/couchbase
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/couchbase
          instance: "<your-instance-name>"
          cluster: "<your-cluster-name>"
          __path__: /opt/couchbase/var/lib/couchbase/logs/*.log
```

## Apache Couchbase Bucket Overview

The Apache Bucket overview dashboard provides details on the top buckets based on key resource usage, items, operations, operations failed, high priority requests, cache hit ratio, number of replica vBuckets, and vBucket queue memory usage.

![First screenshot of the Apache Couchbase bucket overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchbase/screenshots/bucket-overview-1.png)
![Second screenshot of the Apache Couchbase bucket overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchbase/screenshots/bucket-overview-2.png)

## Alerts Overview

- ApacheCouchbaseHighCPUUsage: There is high cpu usage for a node.
- ApacheCouchbaseHighMemoryUsage: There is a limited amount of memory available for a node.
- ApacheCouchbaseMemoryEvictionRate: There is a spike in evictions in a bucket, which indicates high memory pressure.
- ApacheCouchbaseInvalidRequestVolume: There is a high volume of incoming invalid requests, which may indicate a DOS or injection attack.

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    alertsCriticalCPUUsage: 85, // percent 0-100
    alertsCriticalMemoryUsage: 85, // percent 0-100
    alertsWarningMemoryEvictionRate: 10, // count
    alertsWarningInvalidRequestVolume: 1000, // count
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
