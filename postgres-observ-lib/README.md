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
| **6. Settings** | What's the PostgreSQL configuration? | Reference |
| **5. Queries** | Which query is causing issues? | Root cause analysis |

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
make build
```

This will:
1. Install dependencies (`jb install`)
2. Generate dashboards to `dashboards_out/`
3. Generate alerts to `prometheus_rules_out/`

### Available Make Commands

| Command | Description |
|---------|-------------|
| `make build` | Install deps + generate dashboards and alerts |
| `make dashboards` | Generate only dashboards |
| `make alerts` | Generate only alerts |
| `make clean` | Remove generated files |
| `make lint` | Lint jsonnet files |
| `make fmt` | Format jsonnet files |
| `make test` | Run lint + build |

### Output Files

```
dashboards_out/
├── postgres-cluster.json     # Cluster-wide overview dashboard
├── postgres-overview.json    # Instance-level overview dashboard
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
│ Resources: [Connections] [Cache Hit] [DB Size] [WAL]        │
└──────────────────────────────────────────────────────────────┘
```

Click on an instance row to drill down to the instance-level dashboard.

### PostgreSQL Overview (Instance)

Single pane of glass for PostgreSQL instance health:

```
┌──────────────────────────────────────────────────────────────┐
│ Health: [UP] [Uptime] [Role] [Conn%] [Cache%] [Deadlocks]   │
│         [Rep Lag] [Replicas] [Slot Lag] [Gauges]            │
├──────────────────────────────────────────────────────────────┤
│ Problems: [Long Queries] [Blocked] [Idle TX] [Archive Fail] │
│           [Checkpoint] [Lock Util] [Inactive Slots] [Errors]│
├──────────────────────────────────────────────────────────────┤
│ Performance: [TPS] [QPS] [Rows] [Connections] [Cache Hit]   │
│              [Buffers] [Disk Reads] [Temp Bytes] [Checkpoint]│
├──────────────────────────────────────────────────────────────┤
│ Maintenance: [Vacuum Needed] [Oldest Vacuum] [Seq Scans]    │
│              [Unused Indexes] [DB Size] [WAL Size]          │
│              [Vacuum Table] [Index Table] [Analyze Status]  │
├──────────────────────────────────────────────────────────────┤
│ Settings: [PostgreSQL Configuration Parameters Table]       │
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
| `backendWrites` | bgwriter can't keep up |
| `conflicts` | Queries cancelled due to recovery conflicts |
| `lockUtilization` | Lock usage percentage |
| `inactiveReplicationSlots` | Slots not actively streaming |
| `exporterErrors` | Exporter scrape failures |

### Tier 3: Performance (Trends)

| Signal | What it tells you |
|--------|-------------------|
| `transactionsPerSecond` | Throughput |
| `queriesPerSecond` | Query rate (requires pg_stat_statements) |
| `activeConnections` | Connection trend |
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
| `buffersCheckpoint` | Buffers cleaned by bgwriter |

### Tier 4: Maintenance (Actionable)

| Signal | What it tells you |
|--------|-------------------|
| `tablesNeedingVacuum` | Ratio of tables with >10% dead tuples |
| `oldestVacuum` | Is autovacuum working? |
| `deadTupleRatio` | Per-table vacuum priority |
| `lastVacuumAge` | Time since each table was vacuumed |
| `sequentialScanRatio` | Missing indexes? |
| `unusedIndexes` | Wasted disk space |
| `unusedIndexesList` | Detailed unused index list |
| `indexTableSize` | Index size per table |
| `databaseSize` | Capacity planning |
| `walSize` | WAL accumulation |
| `oldestAnalyze` | Is autoanalyze working? |
| `lastAnalyzeAge` | Time since each table was analyzed |

### Tier 5: Queries (Root Cause)

| Signal | What it tells you |
|--------|-------------------|
| `topQueriesByTotalTime` | Optimization targets |
| `slowestQueriesByMeanTime` | Slowest individual queries |
| `mostFrequentQueries` | Cache candidates |
| `topQueriesByRows` | Queries returning most rows |
| `queryStats` | Full query statistics |

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
| `currentPrimary` | Current primary instance |
| `instanceRole` | Role per instance |
| `roleChanges` | Failover detection |
| `tpsByInstance` | TPS per instance |
| `qpsByInstance` | QPS per instance |
| `totalDatabaseSize` | Total data size |

## Alerts

All alerts are configured with sensible defaults that can be customized:

| Alert | Default Threshold | Severity |
|-------|-------------------|----------|
| `PostgreSQLDown` | pg_up == 0 | critical |
| `PostgreSQLHighConnectionUsage` | >80% | warning |
| `PostgreSQLLowCacheHitRatio` | <90% | warning |
| `PostgreSQLReplicationLag` | >30s | warning |
| `PostgreSQLReplicationLagCritical` | >1h | critical |
| `PostgreSQLDeadlocks` | any | warning |
| `PostgreSQLLongRunningQuery` | >5min | warning |
| `PostgreSQLBlockedQueries` | any | warning |
| `PostgreSQLWALArchiveFailure` | any | critical |
| `PostgreSQLHighDeadTuples` | >10% | warning |
| `PostgreSQLVacuumNotRunning` | >7 days | warning |
| `PostgreSQLTooManyRollbacks` | >10% | warning |
| `PostgreSQLTooManyLocksAcquired` | >20% | warning |
| `PostgreSQLInactiveReplicationSlot` | any | critical |
| `PostgreSQLReplicationRoleChanged` | any | warning |
| `PostgreSQLExporterErrors` | any | critical |
| `PostgreSQLHighQPS` | >10000 | warning |

## Configuration

```jsonnet
local postgres = import 'postgres-observ-lib/main.libsonnet';

postgres.new()
+ postgres.withConfigMixin({
  // Filtering
  filteringSelector: '',  // Used in dashboard queries
  alertsFilteringSelector: 'job=~".+", instance=~".+"',  // Used in alert rules
  groupLabels: ['job', 'cluster'],
  instanceLabels: ['instance'],
  
  // Dashboard
  uid: 'postgres',
  dashboardNamePrefix: 'Production / ',
  dashboardTags: ['postgres', 'database'],
  
  // Metrics source - extensible for future sources
  metricsSource: ['postgres_exporter'],
  
  // Feature flags
  enableQueryAnalysis: true,  // requires pg_stat_statements
  
  // Alert thresholds
  alerts: {
    connectionUtilization: { warn: 80, critical: 95 },
    cacheHitRatio: { warn: 90 },
    replicationLag: { warn: 30, critical: 3600 },
    deadlocks: { warn: 1 },
    longRunningQuery: { warn: 300 },
    blockedQueries: { warn: 1 },
    deadTupleRatio: { warn: 10, critical: 20 },
    vacuumAge: { warn: 7 },
    rollbackRatio: { warn: 10 },
    lockUtilization: { warn: 20 },
    qps: { warn: 10000 },
  },
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

Tested with postgres_exporter version 0.18.1 and PostgreSQL v17.

### Query Analysis (Tier 5)

Requires `pg_stat_statements` extension:

```sql
-- postgresql.conf
shared_preload_libraries = 'pg_stat_statements'

-- After restart
CREATE EXTENSION pg_stat_statements;
```

## Extensibility

### Adding New Metrics Sources

The library uses a multi-source signal pattern. To add a new metrics source (e.g., CloudWatch):

1. Add the source to `config.libsonnet`:
```jsonnet
{
  metricsSource: ['postgres_exporter', 'cloudwatch'],
}
```

2. Add expressions for the new source in each signal file:
```jsonnet
// signals/health.libsonnet
signals: {
  up: {
    sources: {
      postgres_exporter: { expr: 'pg_up{%(queriesSelector)s}' },
      cloudwatch: { expr: 'aws_rds_...' },  // Add new source
    },
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
    postgres_exporter: 'pg_up',
  },
  signals: {
    mySignal: {
      name: 'My Signal',
      description: 'What this tells the DBA',
      type: 'gauge',  // or 'counter', 'raw'
      unit: 'short',  // Grafana unit
      sources: {
        postgres_exporter: {
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
