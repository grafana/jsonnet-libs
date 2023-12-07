# Couchbase Mixin

The Couchbase mixin is a set of configurable Grafana dashboards and alerts.

The Couchbase mixin contains the following dashboards:

- Couchbase cluster overview
- Couchbase node overview
- Couchbase bucket overview

and the following alerts:

- CouchbaseHighCPUUsage
- CouchbaseHighMemoryUsage
- CouchbaseMemoryEvictionRate
- CouchbaseInvalidRequestVolume

## Couchbase Cluster Overview

The Couchbase cluster overview dashboard provides details on the top nodes and buckets for a cluster, including memory and disk usage, network requests, key service metrics, rate of operations, along with replication metrics at all levels of a Couchbase cluster.

![First screenshot of the Couchbase cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/couchbase/screenshots/couchbase_cluster_overview_1.png)
![Second screenshot of the Couchbase cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/couchbase/screenshots/couchbase_cluster_overview_2.png)
![Third screenshot of the Couchbase cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/couchbase/screenshots/couchbase_cluster_overview_3.png)

## Couchbase Node Overview

The Couchbase node overview dashboard provides details on memory usage, cpu usage, network request info (request methods and response codes), query service request info (volume, type, and processing time), index service performance (request volume, cache hit ratio, and scan latency), and both error and couchdb logs. The default Couchbase system log path is `/opt/couchbase/var/lib/couchbase/logs` on Linux, or `C:\Program\Files\Couchbase\Server\var\lib\couchbase\logs` on Windows.

![First screenshot of the Couchbase node overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/couchbase/screenshots/couchbase_node_overview_1.png)
![Second screenshot of the Couchbase node overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/couchbase/screenshots/couchbase_node_overview_2.png)
![Third screenshot of the Couchbase node overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/couchbase/screenshots/couchbase_node_overview_3.png)

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
    pipeline_stages:
      - drop:
          expression: '---'
      - multiline:
          firstline: '\[(ns_server|couchdb):(error|info),.*\]'
```

## Couchbase Bucket Overview

The Couchbase Bucket overview dashboard provides details on the top buckets based on key resource usage, items, operations, operations failed, high priority requests, cache hit ratio, number of replica vBuckets, and vBucket queue memory usage.

![First screenshot of the Couchbase bucket overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/couchbase/screenshots/couchbase_bucket_overview_1.png)
![Second screenshot of the Couchbase bucket overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/couchbase/screenshots/couchbase_bucket_overview_2.png)

## Alerts Overview

- CouchbaseHighCPUUsage: There is high cpu usage for a node.
- CouchbaseHighMemoryUsage: There is a limited amount of memory available for a node.
- CouchbaseMemoryEvictionRate: There is a spike in evictions in a bucket, which indicates high memory pressure.
- CouchbaseInvalidRequestVolume: There is a high volume of incoming invalid requests, which may indicate a DOS or injection attack.

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
