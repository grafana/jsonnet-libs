# Dragonfly Mixin

Grafana dashboards and Prometheus alerts for [Dragonfly](https://www.dragonflydb.io/) - a modern, Redis-compatible in-memory data store.

## Overview

Dragonfly exposes Prometheus-compatible metrics natively at `http://<host>:6379/metrics` (or `:9999` in Kubernetes). This mixin provides:

- **Overview dashboard**: Uptime, connected clients, memory, commands, keyspace, network, and pipeline metrics
- **Cluster overview dashboard**: Fleet-wide view with alerts
- **Alerts**: High memory usage, high connected clients, low keyspace hit rate

## Metrics

The mixin uses the following Dragonfly metrics:

- `dragonfly_uptime_in_seconds` - Server uptime
- `dragonfly_connected_clients` - Connected client count
- `dragonfly_memory_used_bytes`, `dragonfly_memory_max_bytes` - Memory usage
- `dragonfly_commands_total`, `dragonfly_reply_total` - Command/reply throughput
- `dragonfly_reply_duration_seconds` - Reply latency
- `dragonfly_keyspace_hits_total`, `dragonfly_keyspace_misses_total` - Cache hit/miss
- `dragonfly_db_keys`, `dragonfly_db_keys_expiring` - Key counts
- `dragonfly_evicted_keys_total`, `dragonfly_expired_keys_total` - Eviction/expiry
- `dragonfly_net_input_bytes_total`, `dragonfly_net_output_bytes_total` - Network I/O
- `dragonfly_pipeline_queue_length` - Pipeline queue depth

## Usage

### Prometheus scrape config

```yaml
scrape_configs:
  - job_name: dragonfly
    static_configs:
      - targets: ['localhost:6379']
    metrics_path: /metrics
    scheme: http
```

For Kubernetes, use the admin port 9999 or configure a ServiceMonitor.

### Generate dashboards and alerts

```bash
jb install
make
```

This produces:
- `dashboards_out/` - JSON dashboards
- `prometheus_rules_out/prometheus_alerts.yaml` - Alert rules

### Config options

Edit `config.libsonnet` to customize:

- `filteringSelector` - Static label selector for all queries
- `alertsHighMemoryUsageWarning` - Memory % threshold (default: 80)
- `alertsHighMemoryUsageCritical` - Critical memory % (default: 95)
- `alertsHighConnectedClients` - Client count threshold (default: 1000)
- `alertsHighKeyspaceMissRate` - Keyspace miss % to alert (default: 50)

## Links

- [Dragonfly Documentation](https://www.dragonflydb.io/docs)
- [Dragonfly Monitoring](https://www.dragonflydb.io/docs/managing-dragonfly/monitoring)
