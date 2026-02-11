# Apache CouchDB Mixin

The Apache CouchDB mixin is a set of configurable Grafana dashboards and alerts.

The Apache CouchDB mixin contains the following dashboards:

- Apache CouchDB overview
- Apache CouchDB nodes

and the following alerts:

- CouchDBUnhealthyCluster
- CouchDBHigh4xxResponseCodes
- CouchDBHigh5xxResponseCodes
- CouchDBModerateRequestLatency
- CouchDBHighRequestLatency
- CouchDBManyReplicatorJobsPending
- CouchDBReplicatorJobsCrashing
- CouchDBReplicatorChangesQueuesDying
- CouchDBReplicatorConnectionOwnersCrashing
- CouchDBReplicatorWorkersCrashing

## Apache CouchDB Overview

The Apache CouchDB overview dashboard provides details on number of clusters and nodes per cluster, open OS files, open databases, database reads and writes, view info, request info (rate, latency, status code info), and replicator failure info for a CouchDB cluster.

![First screenshot of the Apache CouchDB overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchdb/screenshots/couchdb_overview_1.png)
![Second screenshot of the Apache CouchDB overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchdb/screenshots/couchdb_overview_2.png)

## Apache CouchDB Nodes

The Apache CouchDB nodes dashboard provides details on memory usage, open OS files, open databases, database reads and writes, view info, request info (rate, latency, status code info), log type breakdown, and logs for a specific node in the cluster. To get CouchDB system logs, [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. The default CouchDB system log path is `/var/log/couchdb/couchdb.log` on Linux.

![First screenshot of the Apache CouchDB nodes dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchdb/screenshots/couchdb_nodes_1.png)
![Second screenshot of the Apache CouchDB nodes dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-couchdb/screenshots/couchdb_nodes_2.png)

CouchDB system logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

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
  - job_name: integrations/apache-couchdb
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/apache-couchdb
          instance: '<your-instance-name>'
          cluster: '<your-cluster-name>'
          __path__: /var/log/couchdb/couchdb.log
```

## CouchDB Version Compatibility

This mixin supports **Apache CouchDB 3.3.1 and later** and handles differences in metric naming conventions between versions.

### Metric Naming Changes

Between CouchDB 3.3.0 and 3.5.0, there was a change in how some metrics are named. Specifically, some metrics that previously had a `_total` suffix no longer include it in newer versions:

- **CouchDB 3.3.0 and earlier**: `couchdb_open_os_files_total`
- **CouchDB 3.5.0 and later**: `couchdb_open_os_files`

### How the Mixin Handles This

By default, the mixin is configured to work with both naming conventions automatically through the `metricsSource` configuration in `config.libsonnet`. This ensures dashboards and alerts work correctly regardless of which CouchDB version you're running.

If you need to customize this behavior, you can modify the `metricsSource` in your `config.libsonnet`:

```jsonnet
{
  _config+:: {
    // For CouchDB 3.5.0+ only (no _total suffix)
    metricsSource: ['prometheus']

    // OR for backwards compatibility with both versions
    metricsSource: ['prometheus', 'prometheusWithTotal'],
  },
}
```

## Alerts Overview

- CouchDBUnhealthyCluster: At least one of the nodes in a cluster is reporting the cluster as being unstable.
- CouchDBHigh4xxResponseCodes: There are a high number of 4xx responses for incoming requests to a node.
- CouchDBHigh5xxResponseCodes: There are a high number of 5xx responses for incoming requests to a node.
- CouchDBModerateRequestLatency: There is a moderate level of request latency for a node.
- CouchDBHighRequestLatency: There is a high level of request latency for a node.
- CouchDBManyReplicatorJobsPending: There is a high number of replicator jobs pending for a node.
- CouchDBReplicatorJobsCrashing: There are replicator jobs crashing for a node.
- CouchDBReplicatorChangesQueuesDying: There are replicator changes queue process deaths for a node.
- CouchDBReplicatorOwnersCrashing: There are replicator connection owner process crashes for a node.
- CouchDBReplicatorWorkersCrashing: There are replicator connection worker process crashes for a node.

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
