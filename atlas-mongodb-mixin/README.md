# MongoDB Atlas Mixin
The MongoDB Atlas mixin is a set of configurable Grafana dashboards and alerts.

The MongoDB Atlas  mixin contains the following dashboards:

- Atlas cluster overview
- Atlas performance overview
- Atlas operations overview
- Atlas elections overview
- Atlas sharding overview

and the following alerts:

- AtlasHighNumberOfDeadlocks
- AtlasHighNumberOfSlowNetworkRequests
- AtlasDiskSpaceLow
- AtlasSlowHardwareIO
- AtlasHighNumberOfTimeoutElections

## Atlas cluster overview
The Atlas cluster overview dashboard provides an at a glance view into an Atlas cluster. Metrics such as hardware I/O's, network requests, memory usage, hardware disk usage, connections, latency, operations, deadlocks, and inventory tables for the nodes in the cluster. Please note that lock related panels such as deadlocks and wait times will show "no data" until load is generated for their respective metrics.

![First screenshot of the MongoDB Atlas cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-cluster-overview-1.png)
![Second screenshot of the MongoDB Atlas cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-cluster-overview-2.png)

## Atlas performance overview
The Atlas performance overview dashboard provides a detailed look at the performance of specific nodes in the Atlas environment. Metrics available include memory usage, hardware disk usage, network requests, slow network requests, and hardware I/O counts and wait times. 

![First screenshot of the MongoDB Atlas performance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-performance-overview-1.png)
![Second screenshot of the MongoDB Atlas performance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-performance-overview-2.png)

## Atlas operations overview
The Atlas operations overview dashboard provides a detailed look at the operations occurring in an Atlas node. Metrics include CRUD operation counts, connection counts, read and write operations and latency, deadlock counts, and lock wait times. Please note that lock related panels such as deadlocks and wait times will show "no data" until load is generated for their respective metrics.

![First screenshot of the MongoDB Atlas operations overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-operations-overview-1.png)
![Second screenshot of the MongoDB Atlas operations overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-operations-overview-2.png)

## Atlas elections overview
The Atlas elections overview dashboard provides a detailed look into the election states of replica sets in the Atlas cluster, at the node level. Metrics include various "called" and "successful" counts for various election types and catch-up related numbers like catch-ups successful, skipped, and failed.

![First screenshot of the MongoDB Atlas elections overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-elections-overview-1.png)
![Second screenshot of the MongoDB Atlas elections overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-elections-overview-2.png)

## Atlas sharding overview
The Atlas sharding overview dashboard is exclusive for sharded Atlas clusters. This dashboard includes metrics like refreshes started and failed, refresh times, blocked cache operations, stale configs, and counts for operations that target a different number of shards. Panels in this dashboard only apply to `shardsvr` and `mongos` nodes. Between those 2 node types, most panels only apply to one or the other.

![First screenshot of the MongoDB Atlas sharding overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-sharding-overview-1.png)
![Second screenshot of the MongoDB Atlas sharding overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/atlas-mongodb/screenshots/atlas-sharding-overview-2.png)

## Environment configuration
This mixin includes the Atlas sharding overview dashboard, however the metrics used report data only when there is a sharded cluster in the project the prometheus integration is reporting on. Because of this, the Atlas sharding overview dashboard is disabled by default. However, if you do have a sharded cluster and want to use the Atlas sharding overview dashboard, you can set the `enableShardingDashboard` parameter in `config.libsonnet` to `true`.

```
{
  _config+:: {
    enableShardingDashboard: true,
  },
}
```

## Alerts overview

- AtlasHighNumberOfDeadlocks: There is a high number of deadlocks occurring.
- AtlasHighNumberOfSlowNetworkRequests: There is a high number of slow network requests.
- AtlasDiskSpaceLow: Hardware is running out of disk space.
- AtlasSlowHardwareIO: Read and write I/O's are taking too long to complete.
- AtlasHighNumberOfTimeoutElections: There is a high number of elections being called due to the primary node timing out.

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
