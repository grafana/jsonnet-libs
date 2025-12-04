{
  new(this): {
    // Use alertsFilteringSelector for all alert rules (no Grafana variables)
    local alertConfig = this.config { filteringSelector: this.config.alertsFilteringSelector },
    
    groups: [
      {
        name: 'PostgreSQL',
        rules: [
          // Tier 1: Critical Health Alerts
          {
            alert: 'PostgreSQLDown',
            expr: 'pg_up{%(filteringSelector)s} == 0' % alertConfig,
            'for': '1m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL is down',
              description: 'PostgreSQL instance {{ $labels.instance }} is not responding.',
            },
          },
          {
            alert: 'PostgreSQLHighConnectionUsage',
            expr: |||
              (
                sum by (%(instanceLabels)s) (pg_stat_activity_count{%(filteringSelector)s})
                /
                pg_settings_max_connections{%(filteringSelector)s}
              ) > %(threshold)s
            ||| % alertConfig {
              instanceLabels: std.join(', ', alertConfig.instanceLabels),
              threshold: alertConfig.alerts.connectionUtilization.warn / 100,
            },
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL connection usage is high',
              description: 'PostgreSQL {{ $labels.instance }} is at {{ $value | humanizePercentage }} connection capacity.',
            },
          },
          {
            alert: 'PostgreSQLLowCacheHitRatio',
            expr: |||
              (
                sum by (%(instanceLabels)s) (pg_stat_database_blks_hit{%(filteringSelector)s})
                /
                (
                  sum by (%(instanceLabels)s) (pg_stat_database_blks_hit{%(filteringSelector)s})
                  +
                  sum by (%(instanceLabels)s) (pg_stat_database_blks_read{%(filteringSelector)s})
                )
              ) < %(threshold)s
            ||| % alertConfig {
              instanceLabels: std.join(', ', alertConfig.instanceLabels),
              threshold: alertConfig.alerts.cacheHitRatio.warn / 100,
            },
            'for': '15m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL cache hit ratio is low',
              description: 'PostgreSQL {{ $labels.instance }} cache hit ratio is {{ $value | humanizePercentage }}. Consider increasing shared_buffers.',
            },
          },
          {
            alert: 'PostgreSQLReplicationLag',
            expr: 'pg_replication_lag{%(filteringSelector)s} > %(threshold)s' % alertConfig {
              threshold: alertConfig.alerts.replicationLag.warn,
            },
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL replication lag is high',
              description: 'Replica {{ $labels.instance }} is {{ $value }}s behind primary.',
            },
          },
          {
            alert: 'PostgreSQLDeadlocks',
            expr: 'rate(pg_stat_database_deadlocks{%(filteringSelector)s}[5m]) > %(threshold)s' % alertConfig {
              threshold: alertConfig.alerts.deadlocks.warn / 300,  // per-second rate
            },
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL deadlocks detected',
              description: 'PostgreSQL {{ $labels.instance }} database {{ $labels.datname }} has deadlocks.',
            },
          },

          // Tier 2: Active Problems Alerts
          {
            alert: 'PostgreSQLLongRunningQuery',
            expr: |||
              pg_stat_activity_max_tx_duration{%(filteringSelector)s, state="active"} > %(threshold)s
            ||| % alertConfig {
              threshold: alertConfig.alerts.longRunningQuery.warn,
            },
            'for': '1m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has long-running query',
              description: 'Query on {{ $labels.instance }} has been running for {{ $value | humanizeDuration }}.',
            },
          },
          {
            alert: 'PostgreSQLBlockedQueries',
            expr: |||
              pg_locks_count{%(filteringSelector)s, mode="ExclusiveLock", granted="f"} > %(threshold)s
            ||| % alertConfig {
              threshold: alertConfig.alerts.blockedQueries.warn,
            },
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has blocked queries',
              description: 'PostgreSQL {{ $labels.instance }} has {{ $value }} queries waiting for locks.',
            },
          },
          {
            alert: 'PostgreSQLWALArchiveFailure',
            expr: 'rate(pg_stat_archiver_failed_count{%(filteringSelector)s}[5m]) > 0' % alertConfig,
            'for': '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL WAL archiving is failing',
              description: 'PostgreSQL {{ $labels.instance }} is failing to archive WAL files. Backups may be incomplete!',
            },
          },

          // Tier 4: Maintenance Alerts
          {
            alert: 'PostgreSQLHighDeadTuples',
            expr: |||
              (
                pg_stat_user_tables_n_dead_tup{%(filteringSelector)s}
                /
                (pg_stat_user_tables_n_live_tup{%(filteringSelector)s} + pg_stat_user_tables_n_dead_tup{%(filteringSelector)s} + 1)
              ) > %(threshold)s
            ||| % alertConfig {
              threshold: alertConfig.alerts.deadTupleRatio.warn / 100,
            },
            'for': '30m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL table needs vacuum',
              description: 'Table {{ $labels.schemaname }}.{{ $labels.relname }} has {{ $value | humanizePercentage }} dead tuples.',
            },
          },
          {
            alert: 'PostgreSQLVacuumNotRunning',
            expr: |||
              (time() - pg_stat_user_tables_last_autovacuum{%(filteringSelector)s}) > %(threshold)s
              and
              pg_stat_user_tables_n_dead_tup{%(filteringSelector)s} > 10000
            ||| % alertConfig {
              threshold: alertConfig.alerts.vacuumAge.warn * 86400,  // days to seconds
            },
            'for': '1h',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL table has not been vacuumed',
              description: 'Table {{ $labels.schemaname }}.{{ $labels.relname }} has not been vacuumed in over 7 days.',
            },
          },

          // ============================================
          // Alerts from upstream postgres_mixin
          // ============================================

          {
            alert: 'PostgreSQLTooManyRollbacks',
            expr: |||
              (
                sum by (%(instanceLabels)s) (rate(pg_stat_database_xact_rollback{%(filteringSelector)s}[5m]))
                /
                (
                  sum by (%(instanceLabels)s) (rate(pg_stat_database_xact_commit{%(filteringSelector)s}[5m]))
                  +
                  sum by (%(instanceLabels)s) (rate(pg_stat_database_xact_rollback{%(filteringSelector)s}[5m]))
                )
              ) > %(threshold)s
            ||| % alertConfig {
              instanceLabels: std.join(', ', alertConfig.instanceLabels),
              threshold: alertConfig.alerts.rollbackRatio.warn / 100,
            },
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has too many rollbacks',
              description: 'PostgreSQL {{ $labels.instance }} has rollback ratio of {{ $value | humanizePercentage }}.',
            },
          },
          {
            alert: 'PostgreSQLTooManyLocksAcquired',
            expr: |||
              max by (%(instanceLabels)s) (
                pg_locks_count{%(filteringSelector)s}
              )
              /
              on(%(instanceLabels)s) (
                pg_settings_max_locks_per_transaction{%(filteringSelector)s}
                *
                pg_settings_max_connections{%(filteringSelector)s}
              ) > %(threshold)s
            ||| % alertConfig {
              instanceLabels: std.join(', ', alertConfig.instanceLabels),
              threshold: alertConfig.alerts.lockUtilization.warn / 100,
            },
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has acquired too many locks',
              description: 'PostgreSQL {{ $labels.instance }} lock utilization is {{ $value | humanizePercentage }}.',
            },
          },
          {
            alert: 'PostgreSQLInactiveReplicationSlot',
            // Count replicas not in streaming state as proxy for inactive slots
            expr: 'count(pg_stat_replication_pg_wal_lsn_diff{%(filteringSelector)s, state!="streaming"}) > 0' % alertConfig,
            'for': '30m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL has inactive replication slot',
              description: 'PostgreSQL {{ $labels.instance }} has a replication slot not actively streaming. WAL files may accumulate!',
            },
          },
          {
            alert: 'PostgreSQLReplicationRoleChanged',
            expr: 'pg_replication_is_replica{%(filteringSelector)s} and changes(pg_replication_is_replica{%(filteringSelector)s}[1m]) > 0' % alertConfig,
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL replication role changed',
              description: 'PostgreSQL {{ $labels.instance }} replication role has changed. Verify if this is expected failover.',
            },
          },
          {
            alert: 'PostgreSQLExporterErrors',
            expr: 'pg_exporter_last_scrape_error{%(filteringSelector)s} > 0' % alertConfig,
            'for': '30m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL exporter has errors',
              description: 'PostgreSQL exporter for {{ $labels.instance }} is experiencing scrape errors.',
            },
          },
          {
            alert: 'PostgreSQLHighQPS',
            expr: |||
              sum by (%(instanceLabels)s) (
                rate(pg_stat_database_xact_commit{%(filteringSelector)s}[5m])
                +
                rate(pg_stat_database_xact_rollback{%(filteringSelector)s}[5m])
              ) > %(threshold)s
            ||| % alertConfig {
              instanceLabels: std.join(', ', alertConfig.instanceLabels),
              threshold: alertConfig.alerts.qps.warn,
            },
            'for': '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has high QPS',
              description: 'PostgreSQL {{ $labels.instance }} has {{ $value }} queries per second.',
            },
          },
          {
            alert: 'PostgreSQLReplicationLagCritical',
            expr: |||
              (pg_replication_lag{%(filteringSelector)s} > %(threshold)s)
              and on (%(instanceLabels)s) (pg_replication_is_replica{%(filteringSelector)s} == 1)
            ||| % alertConfig {
              instanceLabels: std.join(', ', alertConfig.instanceLabels),
              threshold: alertConfig.alerts.replicationLag.critical,
            },
            'for': '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL replication lag exceeds 1 hour',
              description: 'Replica {{ $labels.instance }} is {{ $value }}s behind primary. Check for network issues or load imbalances.',
            },
          },
        ],
      },
    ],
  },
}
