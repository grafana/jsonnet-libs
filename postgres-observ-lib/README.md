# PostgreSQL Observability Library

A observability library for PostgreSQL monitoring. Generates Grafana dashboards and Prometheus alerts organized by priority and actionability.

## Design Philosophy

This library is designed around what DBAs actually need to know, organized in tiers of priority:

| Tier | Question | Signals | Dashboard Row |
|------|----------|---------|---------------|
| **1. Health** | Is there a problem RIGHT NOW? | 6 | Always visible |
| **2. Problems** | What needs immediate attention? | 6 | Alert-worthy |
| **3. Performance** | Is performance acceptable? | 6 | Time series |
| **4. Maintenance** | What needs maintenance? | 7 | Actionable tasks |
| **5. Queries** | Which query is causing issues? | 5 | Root cause analysis |


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

### Output Files

```
dashboards_out/
├── postgres-overview.json    # Main overview dashboard
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

### PostgreSQL Overview
Single pane of glass for PostgreSQL health:

```
┌──────────────────────────────────────────────────────────────┐
│ Health: [UP] [Uptime] [Conn%] [Cache%] [RepLag] [Deadlocks] │
├──────────────────────────────────────────────────────────────┤
│ Problems: [Long Queries] [Blocked] [Idle TX] [Archive Fail] │
├──────────────────────────────────────────────────────────────┤
│ Performance: [TPS] [Connections] [Cache Hit] [Disk Reads]   │
├──────────────────────────────────────────────────────────────┤
│ Maintenance: [Vacuum Needed] [Dead Tuples] [Unused Indexes] │
└──────────────────────────────────────────────────────────────┘
```

### PostgreSQL Query Performance
Requires `pg_stat_statements` extension:

```
┌──────────────────────────────────────────────────────────────┐
│ [Top Queries by Time] [Slowest Queries] [Most Frequent]     │
├──────────────────────────────────────────────────────────────┤
│ [Queries Using Temp Files] [Query Statistics Table]         │
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

### Tier 3: Performance (Trends)

| Signal | What it tells you |
|--------|-------------------|
| `transactionsPerSecond` | Throughput |
| `activeConnections` | Connection trend |
| `tempBytesWritten` | work_mem too small? |
| `diskReads` | Cache misses |
| `checkpointDuration` | I/O bottleneck indicator |
| `rollbackRatio` | Application issues |

### Tier 4: Maintenance (Actionable)

| Signal | What it tells you |
|--------|-------------------|
| `tablesNeedingVacuum` | Count of tables with >10% dead tuples |
| `oldestVacuum` | Is autovacuum working? |
| `deadTupleRatio` | Per-table vacuum priority |
| `sequentialScanRatio` | Missing indexes? |
| `unusedIndexes` | Wasted disk space |
| `databaseSize` | Capacity planning |
| `walSize` | WAL accumulation |

### Tier 5: Queries (Root Cause)

| Signal | What it tells you |
|--------|-------------------|
| `topQueriesByTotalTime` | Optimization targets |
| `slowestQueriesByMeanTime` | Slowest individual queries |
| `mostFrequentQueries` | Cache candidates |
| `queriesUsingTempFiles` | Need more work_mem |
| `queryCacheHitRatio` | Query-level cache efficiency |

## Alerts

All alerts are configured with sensible defaults that can be customized:

| Alert | Default Threshold | Severity |
|-------|-------------------|----------|
| `PostgreSQLDown` | pg_up == 0 | critical |
| `PostgreSQLHighConnectionUsage` | >80% | warning |
| `PostgreSQLLowCacheHitRatio` | <90% | warning |
| `PostgreSQLReplicationLag` | >30s | warning |
| `PostgreSQLDeadlocks` | any | warning |
| `PostgreSQLLongRunningQuery` | >5min | warning |
| `PostgreSQLBlockedQueries` | any | warning |
| `PostgreSQLWALArchiveFailure` | any | critical |
| `PostgreSQLHighDeadTuples` | >10% | warning |
| `PostgreSQLVacuumNotRunning` | >7 days | warning |

## Configuration

```jsonnet
local postgres = import 'postgres-observ-lib/main.libsonnet';

postgres.new()
+ postgres.withConfigMixin({
  // Filtering
  filteringSelector: 'job="postgres"',
  groupLabels: ['job'],
  instanceLabels: ['instance'],
  
  // Dashboard
  uid: 'postgres',
  dashboardNamePrefix: 'Production / ',
  dashboardTags: ['postgres', 'database'],
  
  // Feature flags
  enableQueryAnalysis: true,  // requires pg_stat_statements
  
  // Alert thresholds
  alerts: {
    connectionUtilization: { warn: 80, critical: 95 },
    cacheHitRatio: { warn: 90 },
    replicationLag: { warn: 30, critical: 120 },
    deadlocks: { warn: 1 },
    longRunningQuery: { warn: 300 },
    blockedQueries: { warn: 1 },
    deadTupleRatio: { warn: 10, critical: 20 },
    vacuumAge: { warn: 7 },
  },
})
```

## Prerequisites

### Basic Monitoring
Uses standard `postgres_exporter` metrics - no additional configuration needed.

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
      type: 'gauge',  // or 'counter'
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

### Adding Custom Signals

To add a new signal tier, create a new file in `signals/` and import it in `main.libsonnet`:

```jsonnet
// main.libsonnet
local signalDefs = {
  health: (import './signals/health.libsonnet')(this.config),
  // ... existing tiers
  custom: (import './signals/custom.libsonnet')(this.config),  // Add new tier
},
```

## File Structure

```
postgres-observ-lib/
├── config.libsonnet       # Configuration (labels, thresholds, settings)
├── main.libsonnet         # Entry point and signal orchestration
├── signals/
│   ├── health.libsonnet      # Tier 1: Critical health
│   ├── problems.libsonnet    # Tier 2: Active problems
│   ├── performance.libsonnet # Tier 3: Performance trends
│   ├── maintenance.libsonnet # Tier 4: Maintenance tasks
│   └── queries.libsonnet     # Tier 5: Query analysis
├── panels/
│   ├── health.libsonnet
│   ├── problems.libsonnet
│   ├── performance.libsonnet
│   ├── maintenance.libsonnet
│   └── queries.libsonnet
├── rows.libsonnet         # Dashboard row organization
├── dashboards.libsonnet   # Dashboard definitions
└── alerts.libsonnet       # Prometheus alerts
```

## Comparison to Other Approaches

| Aspect | Raw Metrics | This Library |
|--------|-------------|--------------|
| Signals | 100+ metrics | ~30 focused |
| Organization | By source table | By DBA priority |
| Dashboards | Metric dump | Actionable tiers |
| Learning curve | High | Low |
| Customization | Maximum | Sufficient |

## License

Apache 2.0
