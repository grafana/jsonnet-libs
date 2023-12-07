# MongoDB Atlas Mixin
The MongoDB Atlas mixin is a set of configurable Grafana dashboards and alerts.

The MongoDB Atlas mixin contains the following dashboards:

- MongoDB Atlas cluster overview
- MongoDB Atlas performance overview
- MongoDB Atlas operations overview
- MongoDB Atlas elections overview
- MongoDB Atlas sharding overview

and the following alerts:

- MongoDBAtlasHighNumberOfSlowNetworkRequests
- MongoDBAtlasDiskSpaceLow
- MongoDBAtlasSlowHardwareIO
- MongoDBAtlasHighNumberOfTimeoutElections
- MongoDBAtlasHighNumberOfCollectionExclusiveDeadlocks
- MongoDBAtlasHighNumberOfCollectionIntentExclusiveDeadlocks
- MongoDBAtlasHighNumberOfCollectionSharedDeadlocks
- MongoDBAtlasHighNumberOfCollectionIntentSharedDeadlocks
- MongoDBAtlasHighNumberOfDatabaseExclusiveDeadlocks
- MongoDBAtlasHighNumberOfDatabaseIntentExclusiveDeadlocks
- MongoDBAtlasHighNumberOfDatabaseSharedDeadlocks
- MongoDBAtlasHighNumberOfDatabaseIntentSharedDeadlocks

**Please note:**
- Some metrics may be reset if the MongoDB Atlas cluster is ever reset.
- Lock related metrics such as deadlocks and wait count do not report data until the respective event has occurred.
- The MongoDB Atlas sharding overview dashboard is controlled by a boolean flag in the config file. See more in the [environment configuration](#environment-configuration) section.
- Within the MongoDB Atlas sharding overview dashboard certain panels only relate to `shardsvr` nodes, other panels relate only to `mongos` nodes, and other relate to both nodes.

## MongoDB Atlas cluster overview
The MongoDB Atlas cluster overview dashboard provides an at a glance view into your MongoDB Atlas cluster. Metrics such as hardware I/Os, network requests, memory usage, hardware disk usage, connections, latency, operations, deadlocks, and inventory tables for the nodes in the cluster. Please note that lock related panels such as deadlocks and wait times will show "no data" until load is generated for their respective metrics.

![First screenshot of the MongoDB Atlas cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-cluster-overview-1.png)
![Second screenshot of the MongoDB Atlas cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-cluster-overview-2.png)

## MongoDB Atlas performance overview
The MongoDB Atlas performance overview dashboard provides a detailed look at the performance of specific nodes in the Atlas environment. Metrics available include memory usage, hardware disk usage, network requests, slow network requests, and hardware I/O counts and wait times. 

![First screenshot of the MongoDB Atlas performance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-performance-overview-1.png)
![Second screenshot of the MongoDB Atlas performance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-performance-overview-2.png)

## MongoDB Atlas operations overview
The MongoDB Atlas operations overview dashboard provides a detailed look at the operations occurring in an Atlas node. Metrics include CRUD operation counts, connection counts, read and write operations and latency, deadlock counts, and lock wait times. Please note that lock related panels such as deadlocks and wait times will show "no data" until load is generated for their respective metrics.

![First screenshot of the MongoDB Atlas operations overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-operations-overview-1.png)
![Second screenshot of the MongoDB Atlas operations overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-operations-overview-2.png)

## MongoDB Atlas elections overview
The MongoDB Atlas elections overview dashboard provides a detailed look into the election states of replica sets in the Atlas cluster, at the node level. Metrics include various "called" and "successful" counts for various election types and catch-up related numbers like catch-ups successful, skipped, and failed.

![First screenshot of the MongoDB Atlas elections overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-elections-overview-1.png)
![Second screenshot of the MongoDB Atlas elections overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-elections-overview-2.png)

## MongoDB Atlas sharding overview
The MongoDB Atlas sharding overview dashboard is exclusive for sharded Atlas clusters. This dashboard includes metrics like refreshes started and failed, refresh times, blocked cache operations, stale configs, and counts for operations that target a different number of shards. Panels in this dashboard only apply to `shardsvr` and `mongos` nodes. Between those 2 node types, most panels only apply to one or the other.

# shardsvr
![First screenshot of the MongoDB Atlas sharding overview (shardsvr) dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-sharding-overview-shardsvr-1.png)
![Second screenshot of the MongoDB Atlas sharding overview (shardsvr) dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-sharding-overview-shardsvr-2.png)

# mongos
![First screenshot of the MongoDB Atlas sharding overview (mongos) dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-sharding-overview-mongos-1.png)
![Second screenshot of the MongoDB Atlas sharding overview (mongos) dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/mongodb-atlas/screenshots/mongodb-atlas-sharding-overview-mongos-2.png)

## Environment configuration
This mixin includes the MongoDB Atlas sharding overview dashboard, however the metrics used report data only when there is a sharded cluster in the project the prometheus integration is reporting on. Because of this, the MongoDB Atlas sharding overview dashboard is disabled by default. However, if you do have a sharded cluster and want to use the MongoDB Atlas sharding overview dashboard, you can set the `enableShardingOverview` parameter in `config.libsonnet` to `true`.

```
{
  _config+:: {
    enableShardingOverview: true,
  },
}
```

## Alerts overview

- MongoDBAtlasHighNumberOfSlowNetworkRequests: There is a high number of slow network requests.
- MongoDBAtlasDiskSpaceLow: Hardware is running out of disk space.
- MongoDBAtlasSlowHardwareIO: Read and write I/Os are taking too long to complete.
- MongoDBAtlasHighNumberOfTimeoutElections: There is a high number of elections being called due to the primary node timing out.
- MongoDBAtlasHighNumberOfCollectionExclusiveDeadlocks: There is a high number of collection exclusive-lock deadlocks.
- MongoDBAtlasHighNumberOfCollectionIntentExclusiveDeadlocks: There is a high number of collection intent-exclusive-lock deadlocks.
- MongoDBAtlasHighNumberOfCollectionSharedDeadlocks: There is a high number of collection shared-lock deadlocks.
- MongoDBAtlasHighNumberOfCollectionIntentSharedDeadlocks: There is a high number of collection intent-shared-lock deadlocks.
- MongoDBAtlasHighNumberOfDatabaseExclusiveDeadlocks: There is a high number of database exclusive-lock deadlocks.
- MongoDBAtlasHighNumberOfDatabaseIntentExclusiveDeadlocks: There is a high number of database intent-exclusive-lock deadlocks.
- MongoDBAtlasHighNumberOfDatabaseSharedDeadlocks: There is a high number of database shared-lock deadlocks.
- MongoDBAtlasHighNumberOfDatabaseIntentSharedDeadlocks: There is a high number of database intent-shared-lock deadlocks.

Default thresholds can be configured in `config.libsonnet`.
```js
{
  _config+:: {
    // sharding dashboard flag
    enableShardingOverview: false,

    dashboardTags: ['mongodb-atlas-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsDeadlocks: 10,  // count
    alertsSlowNetworkRequests: 10,  // count
    alertsHighDiskUsage: 90,  // percentage: 0-100
    alertsSlowHardwareIO: 3,  // seconds
    alertsHighTimeoutElections: 10,  // count
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
