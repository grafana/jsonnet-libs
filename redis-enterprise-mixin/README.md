# Redis Enterprise Mixin

The Redis Enterprise mixin is a set of configurable Grafana dashboards and alerts.

The mixin contains the following dashboards:

- Redis Enterprise overview
- Redis Enterprise nodes
- Redis Enterprise databases

and the following alerts:

- RedisEnterpriseClusterOutOfMemory
- RedisEnterpriseNodeNotResponding
- RedisEnterpriseDatabaseNotResponding
- RedisEnterpriseShardNotResponding
- RedisEnterpriseNodeHighCPUUtilization
- RedisEnterpriseAverageLatencyIncreasing
- RedisEnterpriseKeyEvictionsIncreasing

## Redis Enterprise overview

The Redis Enterprise overview dashboard provides details on the overall status of the Redis Enterprise cluster. Includes visualizations for important KPIs such as nodes up, databases up, average request latency, node cpu utilization, node memory utilization, and cluster cache hit ratio.

![First screenshot of the overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/redis-enterprise/screenshots/overview_1.png)
![Second screenshot of the overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/redis-enterprise/screenshots/overview_2.png)

## Redis Enterprise nodes

The Redis Enterprise nodes dashboard provides details on memory/cpu usage, node network ingress/egress, number of requests, storage utilization, connections, and optionally the redis logs panel.

![First screenshot of the nodes dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/redis-enterprise/screenshots/nodes_1.png)
![Second screenshot of the nodes dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/redis-enterprise/screenshots/nodes_2.png)

## Redis Enterprise databases

The Redis Enterprise databases dashboard provides details on key counts, operations, memory utilization, memory fragmentation ratio, LUA heap size, database evictions/expirations, and database ingress/egress.

![First screenshot of the database dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/redis-enterprise/screenshots/database_1.png)
![Second screenshot of the overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/redis-enterprise/screenshots/database_2.png)

## Alerts Overview

- RedisEnterpriseClusterOutOfMemory: Cluster has run out of memory.
- RedisEnterpriseNodeNotResponding: A node in the Redis Enterprise cluster is offline or unreachable.
- RedisEnterpriseDatabaseNotResponding: A database in the Redis Enterprise cluster is offline or unreachable.
- RedisEnterpriseShardNotResponding: A shard in the Redis Enterprise cluster is offline or unreachable.
- RedisEnterpriseNodeHighCPUUtilization: Node CPU usage is above the configured threshold.
- RedisEnterpriseDatabaseHighMemoryUtilization: Node memory utilization is above the configured threshold.
- RedisEnterpriseAverageLatencyIncreasing: Operation latency is above the configured threshold.
- RedisEnterpriseKeyEvictionsIncreasing: A node has a higher memory utilization than the configured threshold.

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

Edit `config.libsonnet` if required and then build JSON dashboard files and prometheus alerts for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
