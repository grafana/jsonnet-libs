# PostgreSQL Observability Library

An observability library for PostgreSQL monitoring. Generates Grafana dashboards and Prometheus alerts organized by priority and actionability.

## Design Philosophy

This library is designed around what DBAs actually need to know, organized in tiers of priority:

| Tier | Question | Dashboard Row |
|------|----------|---------------|
| **1. Health** | Is there a problem RIGHT NOW? | Always visible |
| **2. Problems** | What needs immediate attention? | Alert-worthy |
| **3. Performance** | Is performance acceptable? | Time series |
| **4. Maintenance** | What needs maintenance? | Actionable tasks |
| **5. Queries** | Which query is causing issues? | Root cause analysis |
| **6. Settings** | What's the PostgreSQL configuration? | Reference |

## Installation as Library

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/postgres-observ-lib
```

Then use in your jsonnet:

```jsonnet
local postgres = import 'postgres-observ-lib/main.libsonnet';

postgres.new()
+ postgres.withConfigMixin({
  filteringSelector: 'job="postgres"',
})
```

## Building Dashboards & Alerts

Generate Grafana dashboards and Prometheus alerts:

```sh
make
```

This will:
1. Install dependencies (`jb install`)
2. Generate dashboards to `dashboards_out/`
3. Generate alerts to `prometheus_rules_out/`
4. Run the alert tests in `tests/`

### Available Make Commands

| Command | Description |
|---------|-------------|
| `make` | Install deps, generate dashboards and alerts, and run the alert tests |
| `make build` | Install deps |
| `make dashboards_out` | Generate only dashboards |
| `make prometheus_alerts.yaml` | Generate only alerts |
| `make clean` | Remove generated files |
| `make lint` | Lint jsonnet files |
| `make fmt` | Format jsonnet files |
| `make test` | Run the alert tests with promtool |

### Output Files

```
dashboards_out/
├── postgres-cluster.json     # Cluster-wide overview dashboard
├── postgres-overview.json    # Instance-level overview dashboard
├── postgres-performance-maintenance.json  # Instance performance and maintenance dashboard
└── postgres-queries.json     # Query performance dashboard

prometheus_rules_out/
└── prometheus_alerts.yaml    # Prometheus alerting rules
```

### Installing in Grafana

**Option 1: Import via UI**
1. Open Grafana → Dashboards → Import
2. Upload JSON file from `dashboards_out/`
3. Select your Prometheus data source

**Option 2: Provisioning**
```sh
cp dashboards_out/*.json /etc/grafana/provisioning/dashboards/
```

### Installing Prometheus Alerts

```sh
cp prometheus_rules_out/prometheus_alerts.yaml /etc/prometheus/rules/
# Reload Prometheus
curl -X POST http://localhost:9090/-/reload
```

## Dashboards

### PostgreSQL Cluster Overview

Top-level view of the entire PostgreSQL cluster:

```
┌──────────────────────────────────────────────────────────────┐
│ Cluster Health: [Status] [Instances] [Primary] [Replicas]   │
│                 [Max Lag] [Cache] [Connections] [Deadlocks] │
│                 [Alerts]                                    │
├──────────────────────────────────────────────────────────────┤
│ Cluster Instances: [Instance Table] [Role History]          │
│                    [Failover Events Timeline]               │
├──────────────────────────────────────────────────────────────┤
│ Cluster Problems: [Long Queries] [Blocked] [Idle TX]        │
│                   [Archive Fail] [Lock Util] [Exporter Err] │
├──────────────────────────────────────────────────────────────┤
│ Replication: [Lag by Instance] [Slot Lag] [WAL Position]    │
├──────────────────────────────────────────────────────────────┤
│ Throughput: [TPS] [QPS] [Writes] [Reads] [Read/Write Ratio] │
├──────────────────────────────────────────────────────────────┤
│ Resources: [Connections] [Cache Hit]                        │
└──────────────────────────────────────────────────────────────┘
```

Click on an instance row to drill down to the instance-level dashboard.

### PostgreSQL Overview (Instance)

Single pane of glass for PostgreSQL instance health:

```
┌──────────────────────────────────────────────────────────────┐
│ Health: [UP] [Uptime] [Role] [Conn%] [Cache%] [Deadlocks]   │
│         [Rep Lag] [Replicas] [Slot Lag] [Gauges] [Alerts]   │
├──────────────────────────────────────────────────────────────┤
│ Problems: [Long Queries] [Blocked] [Idle TX] [Archive Fail] │
│           [Checkpoint] [Lock Util] [Inactive Slots] [Errors]│
├──────────────────────────────────────────────────────────────┤
│ Settings: [PostgreSQL Configuration Parameters Table]       │
└──────────────────────────────────────────────────────────────┘
```

### PostgreSQL instance performance and maintenance

Trends and maintenance work for one instance:

```
┌──────────────────────────────────────────────────────────────┐
│ Performance: [TPS] [QPS] [Rows] [Connections] [Cache Hit]   │
│              [Buffers] [Disk Reads] [Temp Bytes] [Checkpoint]│
├──────────────────────────────────────────────────────────────┤
│ Maintenance: [Vacuum Needed] [Oldest Vacuum] [Seq Scans]    │
│              [Unused Indexes] [DB Size]                     │
│              [Vacuum Table] [Index Table] [Analyze Status]  │
└──────────────────────────────────────────────────────────────┘
```

### PostgreSQL Query Performance

Requires `pg_stat_statements` extension:

```
┌──────────────────────────────────────────────────────────────┐
│ [Top Queries by Time] [Slowest Queries] [Most Frequent]     │
├──────────────────────────────────────────────────────────────┤
│ [Top Queries by Rows] [Query Statistics Table]              │
└──────────────────────────────────────────────────────────────┘
```

## Signal Tiers

### Tier 1: Health (Critical - Always Visible)

| Signal | What it tells you |
|--------|-------------------|
| `up` | Is PostgreSQL responding? |
| `uptime` | How long since last restart? |
| `isReplica` | Is this a primary or replica? |
| `connectionUtilization` | Am I running out of connections? (>80% warning) |
| `cacheHitRatio` | Is memory working? (should be >95%) |
| `replicationLag` | Is replication healthy? |
| `connectedReplicas` | How many replicas connected? (primary only) |
| `replicationSlotLag` | WAL bytes pending in slots |
| `deadlocks` | Are transactions fighting? |

### Tier 2: Problems (Alert-worthy)

| Signal | What it tells you |
|--------|-------------------|
| `longRunningQueries` | Queries > 5 minutes |
| `blockedQueries` | Queries waiting for locks |
| `idleInTransaction` | Connections holding locks without work |
| `walArchiveFailures` | Backup problems! |
| `checkpointWarnings` | I/O pressure indicator |
| `conflicts` | Queries cancelled due to recovery conflicts |
| `lockUtilization` | Lock usage percentage |
| `inactiveReplicationSlots` | Slots not actively streaming |
| `exporterErrors` | Exporter scrape failures |

### Tier 3: Performance (Trends)

| Signal | What it tells you |
|--------|-------------------|
| `transactionsPerSecond` | Throughput |
| `queriesPerSecond` | Query rate (requires pg_stat_statements) |
| `tempBytesWritten` | work_mem too small? |
| `diskReadWriteRatio` | Cache misses |
| `checkpointDuration` | Buffer allocation rate |
| `rollbackRatio` | Application issues |
| `rowsFetched` | Rows fetched per second |
| `rowsReturned` | Rows returned per second |
| `rowsInserted` | Insert rate |
| `rowsUpdated` | Update rate |
| `rowsDeleted` | Delete rate |
| `buffersAlloc` | Buffer allocations |
| `buffersCheckpoint` | Buffers written by checkpoints |

### Tier 4: Maintenance (Actionable)

| Signal | What it tells you |
|--------|-------------------|
| `tablesNeedingVacuum` | Ratio of tables with >10% dead tuples |
| `oldestVacuum` | Is vacuum keeping up? |
| `deadTupleRatio` | Per-table vacuum priority |
| `deadTuples` | Dead tuples per table |
| `lastVacuumAge` | Time since each table was vacuumed |
| `sequentialScanRatio` | Missing indexes? |
| `unusedIndexes` | Wasted disk space |
| `databaseSize` | Capacity planning |
| `oldestAnalyze` | Is autoanalyze working? |
| `lastAnalyzeAge` | Time since each table was analyzed |

### Tier 5: Queries (Root Cause)

| Signal | What it tells you |
|--------|-------------------|
| `topQueriesByTotalTime` | Optimization targets |
| `slowestQueriesByMeanTime` | Slowest individual queries |
| `mostFrequentQueries` | Cache candidates |
| `topQueriesByRows` | Queries returning most rows |
| `queryTotalTime` | Execution time per query since stats reset |

### Tier 6: Settings (Reference)

| Signal | What it tells you |
|--------|-------------------|
| `allSettings` | PostgreSQL configuration parameters |

### Cluster Signals

For cluster-wide monitoring:

| Signal | What it tells you |
|--------|-------------------|
| `clusterStatus` | All instances up? |
| `totalInstances` | Instance count |
| `upInstances` | Healthy instance count |
| `primaryCount` | Should be exactly 1 |
| `replicaCount` | Replica count |
| `maxReplicationLag` | Worst lag across replicas |
| `worstCacheHitRatio` | Lowest cache efficiency |
| `worstConnectionUtilization` | Highest connection usage |
| `totalDeadlocks` | Cluster-wide deadlocks |
| `instanceRole` | Role per instance |
| `roleChanges` | Failover detection |
| `tpsByInstance` | TPS per instance |
| `qpsByInstance` | QPS per instance |

## Alerts

| Alert | Default Threshold | Severity |
|-------|-------------------|----------|
| `PostgreSQLDown` | pg_up == 0 | critical |
| `PostgreSQLHighConnectionUsage` | >80% | warning |
| `PostgreSQLLowCacheHitRatio` | <90% | warning |
| `PostgreSQLReplicationLag` | >30s | warning |
| `PostgreSQLReplicationLagCritical` | >1h | critical |
| `PostgreSQLDeadlocks` | >1 per 5 min | warning |
| `PostgreSQLLongRunningQuery` | >5min | warning |
| `PostgreSQLBlockedQueries` | >1 waiting | warning |
| `PostgreSQLWALArchiveFailure` | any | critical |
| `PostgreSQLHighDeadTuples` | >10% and >10,000 dead tuples | warning |
| `PostgreSQLVacuumNotRunning` | >7 days | warning |
| `PostgreSQLTooManyRollbacks` | >10% | warning |
| `PostgreSQLTooManyLocksAcquired` | >20% | warning |
| `PostgreSQLInactiveReplicationSlot` | any | critical |
| `PostgreSQLReplicationRoleChanged` | any | warning |
| `PostgreSQLExporterErrors` | any | critical |
| `PostgreSQLHighQps` | >10000 | warning |

Default thresholds can be modified in `config.libsonnet`:

```jsonnet
{
  alertHighConnectionUsageWarningThreshold: 80,  // > percent of max_connections

  alertLowCacheHitRatioWarningThreshold: 90,  // < percent

  alertReplicationLagWarningThreshold: 30,  // > seconds
  alertReplicationLagCriticalThreshold: 3600,  // > seconds

  alertDeadlocksWarningThreshold: 1,  // > deadlocks in 5 minutes

  alertLongRunningQueryWarningThreshold: 300,  // > seconds

  alertBlockedQueriesWarningThreshold: 1,  // > queries

  alertHighDeadTuplesWarningThreshold: 10,  // > percent of tuples that are dead
  alertHighDeadTuplesMinDeadTuples: 10000,  // > dead tuples

  alertVacuumNotRunningWarningThreshold: 7,  // > days
  alertVacuumNotRunningDeadTuples: 10000,  // > dead tuples

  alertTooManyRollbacksWarningThreshold: 10,  // > percent of transactions rolled back

  alertTooManyLocksAcquiredWarningThreshold: 20,  // > percent of the lock table size

  alertHighQpsWarningThreshold: 10000,  // > transactions per second
}
```

### Upgrading from the `alerts` object

The `alert<Name><Tier>Threshold` keys replace the nested `alerts` object. Update custom configurations to use the new keys below.

| Old key | New key |
|---------|---------|
| `alerts.connectionUtilization.warn` | `alertHighConnectionUsageWarningThreshold` |
| `alerts.cacheHitRatio.warn` | `alertLowCacheHitRatioWarningThreshold` |
| `alerts.replicationLag.warn` | `alertReplicationLagWarningThreshold` |
| `alerts.replicationLag.critical` | `alertReplicationLagCriticalThreshold` |
| `alerts.deadlocks.warn` | `alertDeadlocksWarningThreshold` |
| `alerts.longRunningQuery.warn` | `alertLongRunningQueryWarningThreshold` |
| `alerts.blockedQueries.warn` | `alertBlockedQueriesWarningThreshold` |
| `alerts.deadTupleRatio.warn` | `alertHighDeadTuplesWarningThreshold` |
| `alerts.vacuumAge.warn` | `alertVacuumNotRunningWarningThreshold` |
| `alerts.rollbackRatio.warn` | `alertTooManyRollbacksWarningThreshold` |
| `alerts.lockUtilization.warn` | `alertTooManyLocksAcquiredWarningThreshold` |
| `alerts.qps.warn` | `alertHighQpsWarningThreshold` |

`alertsFilteringSelector` is deprecated. Alerts use `filteringSelector`.

## Configuration

Override any setting from `config.libsonnet` with `withConfigMixin`. This example lists each setting other than the alert thresholds, with its default.

```jsonnet
local postgres = import 'postgres-observ-lib/main.libsonnet';

postgres.new()
+ postgres.withConfigMixin({
  // Label matchers added to every query and alert, such as 'job="integrations/postgres_exporter"'
  filteringSelector: '',
  // Labels that group instances. Each one is a dashboard variable.
  groupLabels: ['job', 'postgres_cluster', 'cluster'],
  // Labels that identify an instance
  instanceLabels: ['instance'],

  // Prefix of the dashboard UIDs
  uid: 'postgres',
  // Text added before each dashboard title, such as 'Production / '
  dashboardNamePrefix: '',
  dashboardTags: ['postgres', 'database'],
  dashboardPeriod: 'now-1h',
  // Empty uses the Grafana default
  dashboardTimezone: '',
  dashboardRefresh: '1m',

  // See "PostgreSQL Version Compatibility"
  metricsSource: ['prometheus', 'prometheus_pg17_plus'],
})
```

## Prerequisites

### Basic Monitoring

Uses standard `postgres_exporter` metrics with the following collectors enabled:

1. `stat_statements`
2. `postmaster`
3. `statio_user_indexes`
4. `long_running_transactions`
5. `database`
6. `locks`
7. `replication`
8. `stat_bgwriter`
9. `stat_database`
10. `stat_user_tables`
11. `stat_checkpointer`, on PostgreSQL 17 and later

In Alloy, list the collectors in `enabled_collectors` in `prometheus.exporter.postgres`. With a standalone `postgres_exporter`, enable each one with `--collector.<name>`.

Tested with PostgreSQL 16 and the `postgres_exporter` embedded in Grafana Alloy v1.21.3, Grafana's version of `postgres_exporter` v0.19.0.

### PostgreSQL Cluster Label

The PostgreSQL cluster overview dashboard groups servers by the `postgres_cluster` label. Give a primary and its replicas the same `postgres_cluster` value where they are scraped. For example, in Alloy, add this rule to the `discovery.relabel` block:

```alloy
rule {
  target_label = "postgres_cluster"
  replacement  = "<your-cluster-name>"
}
```

Servers without the label appear as one cluster.

### Query Analysis (Tier 5)

Requires `pg_stat_statements` extension:

```sql
-- postgresql.conf
shared_preload_libraries = 'pg_stat_statements'

-- After restart
CREATE EXTENSION pg_stat_statements;
```

## PostgreSQL Version Compatibility

PostgreSQL 17 moved the checkpoint statistics from `pg_stat_bgwriter` to a new view, `pg_stat_checkpointer`. `postgres_exporter` reports buffers written by checkpoints under a different metric name depending on the PostgreSQL version:

- **PostgreSQL 16 and earlier**: `pg_stat_bgwriter_buffers_checkpoint_total`, from the `stat_bgwriter` collector
- **PostgreSQL 17 and later**: `pg_stat_checkpointer_buffers_written_total`, from the `stat_checkpointer` collector

By default, `metricsSource` lists two metrics sources, `prometheus` and `prometheus_pg17_plus`. The dashboards work on either PostgreSQL version, and on a fleet that runs both.

On PostgreSQL 17 and later, enable the `stat_checkpointer` collector. It is off by default in `postgres_exporter`. If the Buffers activity panel shows no checkpoint writes for a PostgreSQL 17 server, the collector is off.

If all your servers run one PostgreSQL version, you can list only its metrics source:

```jsonnet
postgres.new()
+ postgres.withConfigMixin({
  // PostgreSQL 16 and earlier only
  metricsSource: ['prometheus'],

  // OR PostgreSQL 17 and later only
  metricsSource: ['prometheus_pg17_plus'],
})
```

## Extensibility

### Adding New Metrics Sources

The library uses a multi-source signal pattern. `prometheus_pg17_plus` shows how a metrics source is added:

1. Add the source to `metricsSource` in `config.libsonnet`:
```jsonnet
{
  metricsSource: ['prometheus', 'prometheus_pg17_plus'],
}
```

2. Add an expression for the new metrics source to each signal whose metric differs. Signals without one use the `prometheus` expression:
```jsonnet
// signals/performance.libsonnet
buffersCheckpoint: {
  sources: {
    prometheus: { expr: 'pg_stat_bgwriter_buffers_checkpoint_total{%(queriesSelector)s}' },
    prometheus_pg17_plus: { expr: 'pg_stat_checkpointer_buffers_written_total{%(queriesSelector)s}' },
  },
}
```

### Signal File Structure

Each signal file in `signals/` follows this pattern:

```jsonnet
function(config) {
  filteringSelector: config.filteringSelector,
  groupLabels: config.groupLabels,
  instanceLabels: config.instanceLabels,
  aggLevel: 'instance',
  aggFunction: 'sum',
  discoveryMetric: {
    prometheus: 'pg_up',
  },
  signals: {
    mySignal: {
      name: 'My Signal',
      description: 'What this tells the DBA',
      type: 'gauge',  // or 'counter', 'raw'
      unit: 'short',  // Grafana unit
      sources: {
        prometheus: {
          expr: 'my_metric{%(queriesSelector)s}',
        },
      },
    },
  },
}
```

### Using as a Mixin

The library exports a monitoring mixin format:

```jsonnet
local postgres = import 'postgres-observ-lib/main.libsonnet';

// Get mixin format
local mixin = postgres.new().asMonitoringMixin();

// mixin.grafanaDashboards - dashboard JSON objects
// mixin.prometheusAlerts - alert rules
// mixin.prometheusRules - recording rules (empty currently)
```

Or directly import `mixin.libsonnet`:

```jsonnet
(import 'postgres-observ-lib/mixin.libsonnet')
```

## File Structure

```
postgres-observ-lib/
├── config.libsonnet          # Configuration (labels, thresholds, settings)
├── main.libsonnet            # Entry point and signal orchestration
├── mixin.libsonnet           # Mixin export wrapper
├── g.libsonnet               # Grafonnet import alias
├── signals/
│   ├── health.libsonnet      # Tier 1: Critical health
│   ├── problems.libsonnet    # Tier 2: Active problems
│   ├── performance.libsonnet # Tier 3: Performance trends
│   ├── maintenance.libsonnet # Tier 4: Maintenance tasks
│   ├── queries.libsonnet     # Tier 5: Query analysis
│   ├── cluster.libsonnet     # Cluster-wide signals
│   └── settings.libsonnet    # PostgreSQL settings
├── panels/
│   ├── main.libsonnet        # Panel orchestration
│   ├── health.libsonnet
│   ├── problems.libsonnet
│   ├── performance.libsonnet
│   ├── maintenance.libsonnet
│   ├── queries.libsonnet
│   ├── cluster.libsonnet     # Cluster dashboard panels
│   └── settings.libsonnet    # Settings table panel
├── rows.libsonnet            # Dashboard row organization
├── dashboards.libsonnet      # Dashboard definitions
└── alerts.libsonnet          # Prometheus alerts
```

## Comparison to Other Approaches

| Aspect | Raw Metrics | This Library |
|--------|-------------|--------------|
| Signals | 100+ metrics | ~50 focused |
| Organization | By source table | By DBA priority |
| Dashboards | Metric dump | Actionable tiers |
| Learning curve | High | Low |
| Customization | Maximum | Sufficient |
| Cluster view | Manual | Built-in |

## License

Apache 2.0
