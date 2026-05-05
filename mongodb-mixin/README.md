# MongoDB mixin

The MongoDB mixin is a set of configurable Grafana dashboards and alerts based on the metrics exported by the [Percona MongoDB Exporter](https://github.com/percona/mongodb_exporter).

The MongoDB mixin contains the following dashboards:

- MongoDB overview
- MongoDB instance
- MongoDB replica set
- MongoDB cluster
- MongoDB logs

and the following alerts:

- MongodbDown
- MongodbReplicaMemberUnhealthy
- MongodbReplicationLag
- MongodbReplicationHeadroom
- MongodbNumberCursorsOpen
- MongodbCursorsTimeouts
- MongodbTooManyConnections
- MongodbVirtualMemoryUsage
- MongodbReadRequestsQueueingUp
- MongodbWriteRequestsQueueingUp

## MongoDB overview

The MongoDB overview dashboard provides fleet-wide health and performance: total instances, instances up/down, total connections, total operations, max replication lag, and per-instance state, connections, operations, and replication lag.

## MongoDB instance

The MongoDB instance dashboard provides per-instance details: uptime, QPS, replica set state, latency, command/document operations, connections, queued operations, cursors, scanned/moved objects, asserts, page faults, and query efficiency.

## MongoDB replica set

The MongoDB replica set dashboard provides per-replica-set details: members, last election, average lag, version distribution, member states, replication lag, operations, elections, heartbeat and member ping times, and oplog details (buffered ops, getmore time, recovery window, processing time, operations).

## MongoDB cluster

The MongoDB cluster dashboard provides sharded-cluster details: number of shards, sharded/unsharded databases, draining shards, sharded collections, total chunks, balancer status, collections and chunks per shard, indexes per shard, connections, operations, and cursors.

## MongoDB logs

The MongoDB logs dashboard provides details on incoming MongoDB logs.

MongoDB logs are enabled by default in `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboards:

```js
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for MongoDB logs ingested into your logs datasource, please also include the matching `job`, `mongodb_cluster`, and `service_name` labels on the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

## Alerts overview

- MongodbDown: A MongoDB instance is down.
- MongodbReplicaMemberUnhealthy: A MongoDB replica set member is unhealthy.
- MongodbReplicationLag: Replication lag exceeds the configured threshold.
- MongodbReplicationHeadroom: Replication headroom is non-positive (the secondary risks falling out of the oplog window).
- MongodbNumberCursorsOpen: Too many open cursors.
- MongodbCursorsTimeouts: Cursors are timing out at a high rate.
- MongodbTooManyConnections: Connection utilization exceeds the configured threshold.
- MongodbVirtualMemoryUsage: Virtual memory usage is too high relative to mapped memory.
- MongodbReadRequestsQueueingUp: Read requests are queuing up.
- MongodbWriteRequestsQueueingUp: Write requests are queuing up.

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    alertsCriticalReplicationLag: 60,  // seconds
    alertsWarningCursorsOpen: 10000,  // count
    alertsWarningCursorsTimeouts: 100,  // count per 1m
    alertsWarningConnectionUtilization: 80,  // percent
    alertsWarningVirtualMemoryRatio: 3,  // ratio
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
