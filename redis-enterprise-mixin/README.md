# Redis Enterprise Mixin

The Redis Enterprise mixin is a set of configurable Grafana dashboards and alerts.

The mixin contains the following dashboards:

- Redis Enterprise overview
- Redis Enterprise nodes
- Redis Enterprise databases

and the following alerts:

- ClusterOutOfMemory
- NodeNotResponding
- DatabaseNotResponding
- ShardNotResponding
- NodeHighCPUUtilization
- AverageLatencyIncreasing
- KeyEvictionsIncreasing

## Redis Enterprise overview

The Redis Enterprise overview dashboard provides details on the overall status of the Redis Enterprise cluster. Includes visualizations for important KPIs such as nodes up, databases up, average request latency, node cpu utilization, node memory utilization, and cluster cache hit ratio.

## Redis Enterprise nodes

The Redis Enterprise nodes dashboard provides details on memory/cpu usage, node network ingress/egress, number of requests, storage utilization, connections, and optionally the redis logs panel.

## Redis Enterprise databases

The Redis Enterprise databases dashboard provides details on key counts, operations, memory utilization, memory fragmentation ratio, LUA heap size, database evictions/expirations, and database ingress/egress.

## Alerts Overview

- ClusterOutOfMemory: Cluster has run out of memory.
- NodeNotResponding: A node in the Redis Enterprise cluster is offline or unreachable.
- DatabaseNotResponding: A database in the Redis Enterprise cluster is offline or unreachable.
- ShardNotResponding: A shard in the Redis Enterprise cluster is offline or unreachable.
- NodeHighCPUUtilization: Node CPU usage is above the configured threshold.
- DatabaseHighMemoryUtilization: Node memory utilization is above the configured threshold.
- AverageLatencyIncreasing: Operation latency is above the configured threshold.
- KeyEvictionsIncreasing: A node has a higher memory utilization than the configured threshold.

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
