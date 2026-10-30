{
  new(this): {
    local config = this.config,
    local signals = this.signals,
    local agg = std.join(', ', config.groupLabels + config.instanceLabels),

    groups: [
      {
        name: 'PostgreSQL',
        rules: [
          // Critical Health Alerts
          {
            alert: 'PostgreSQLDown',
            expr: '(%s) == 0' % signals.health.up.asRuleExpression(),
            'for': '1m',
            keep_firing_for: '5m',
            labels: { severity: config.alertDownSeverity },
            annotations: {
              summary: 'PostgreSQL is down.',
              description: 'PostgreSQL instance {{ $labels.instance }} is not responding.',
            },
          },
          {
            alert: 'PostgreSQLHighConnectionUsage',
            expr: '(%s) > %g' % [signals.health.connectionUtilization.asRuleExpression(), config.alertHighConnectionUsageThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertHighConnectionUsageSeverity },
            annotations: {
              summary: 'PostgreSQL connection usage is high.',
              description: 'PostgreSQL {{ $labels.instance }} is at {{ $value | humanizePercentage }} connection capacity.',
            },
          },
          {
            alert: 'PostgreSQLLowCacheHitRatio',
            expr: '(%s) < %g' % [signals.health.cacheHitRatio.asRuleExpression(), config.alertLowCacheHitRatioThreshold],
            'for': '15m',
            keep_firing_for: '5m',
            labels: { severity: config.alertLowCacheHitRatioSeverity },
            annotations: {
              summary: 'PostgreSQL cache hit ratio is low.',
              description: 'PostgreSQL {{ $labels.instance }} cache hit ratio is {{ $value | humanizePercentage }}. Consider increasing shared_buffers.',
            },
          },
          {
            alert: 'PostgreSQLReplicationLag',
            expr: '(%s) > %s' % [signals.health.replicationLag.asRuleExpression(), config.alertReplicationLagThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertReplicationLagSeverity },
            annotations: {
              summary: 'PostgreSQL replication lag is high.',
              description: 'Replica {{ $labels.instance }} is {{ $value }}s behind primary.',
            },
          },
          {
            alert: 'PostgreSQLDeadlocks',
            expr: 'increase(pg_stat_database_deadlocks{%(filteringSelector)s}[5m]) > %(alertDeadlocksThreshold)s' % config,
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertDeadlocksSeverity },
            annotations: {
              summary: 'PostgreSQL deadlocks detected.',
              description: 'PostgreSQL {{ $labels.instance }} database {{ $labels.datname }} has deadlocks.',
            },
          },

          // Active Problems Alerts
          {
            alert: 'PostgreSQLLongRunningQuery',
            expr: '(%s) > %s' % [signals.problems.longestActiveTransaction.asRuleExpression(), config.alertLongRunningQueryThreshold],
            'for': '1m',
            keep_firing_for: '5m',
            labels: { severity: config.alertLongRunningQuerySeverity },
            annotations: {
              summary: 'PostgreSQL has long-running query.',
              description: 'Query on {{ $labels.instance }} has been running for {{ $value | humanizeDuration }}.',
            },
          },
          {
            alert: 'PostgreSQLBlockedQueries',
            expr: 'sum by (%s) (%s) > %s' % [agg, signals.problems.blockedQueries.asRuleExpression(), config.alertBlockedQueriesThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertBlockedQueriesSeverity },
            annotations: {
              summary: 'PostgreSQL has blocked queries.',
              description: 'PostgreSQL {{ $labels.instance }} has {{ $value }} queries waiting for locks.',
            },
          },
          {
            alert: 'PostgreSQLWALArchiveFailure',
            expr: '(%s) > 0' % signals.problems.walArchiveFailures.withRangeFunction('rate').asRuleExpression(),
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertWALArchiveFailureSeverity },
            annotations: {
              summary: 'PostgreSQL WAL archiving is failing.',
              description: 'PostgreSQL {{ $labels.instance }} is failing to archive WAL files. Backups may be incomplete!',
            },
          },

          // Maintenance Alerts
          {
            alert: 'PostgreSQLHighDeadTuples',
            expr: '(%s) > %g' % [signals.maintenance.deadTupleRatio.asRuleExpression(), config.alertHighDeadTuplesThreshold],
            'for': '30m',
            keep_firing_for: '5m',
            labels: { severity: config.alertHighDeadTuplesSeverity },
            annotations: {
              summary: 'PostgreSQL table needs vacuum.',
              description: 'Table {{ $labels.schemaname }}.{{ $labels.relname }} has {{ $value | humanizePercentage }} dead tuples.',
            },
          },
          {
            alert: 'PostgreSQLVacuumNotRunning',
            expr: |||
              (time() - pg_stat_user_tables_last_autovacuum{%(filteringSelector)s}) > %(alertVacuumNotRunningThreshold)s
              and
              pg_stat_user_tables_n_dead_tup{%(filteringSelector)s} > %(alertVacuumNotRunningDeadTuples)s
            ||| % config,
            'for': '1h',
            keep_firing_for: '5m',
            labels: { severity: config.alertVacuumNotRunningSeverity },
            annotations: {
              summary: 'PostgreSQL table has not been vacuumed.',
              description: 'Table {{ $labels.schemaname }}.{{ $labels.relname }} has not been vacuumed in over %g days.' % (config.alertVacuumNotRunningThreshold / 86400),
            },
          },

          {
            alert: 'PostgreSQLTooManyRollbacks',
            expr: '(%s) > %g' % [signals.performance.rollbackRatio.asRuleExpression(), config.alertTooManyRollbacksThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertTooManyRollbacksSeverity },
            annotations: {
              summary: 'PostgreSQL has too many rollbacks.',
              description: 'PostgreSQL {{ $labels.instance }} has rollback ratio of {{ $value | humanizePercentage }}.',
            },
          },
          {
            alert: 'PostgreSQLTooManyLocksAcquired',
            expr: '(%s) > %g' % [signals.problems.lockUtilization.asRuleExpression(), config.alertTooManyLocksAcquiredThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertTooManyLocksAcquiredSeverity },
            annotations: {
              summary: 'PostgreSQL has acquired too many locks.',
              description: 'PostgreSQL {{ $labels.instance }} lock utilization is {{ $value | humanizePercentage }}.',
            },
          },
          {
            alert: 'PostgreSQLInactiveReplicationSlot',
            expr: '(%s) > 0' % signals.problems.nonStreamingReplicaLag.asRuleExpression(),
            'for': '30m',
            keep_firing_for: '5m',
            labels: { severity: config.alertInactiveReplicationSlotSeverity },
            annotations: {
              summary: 'PostgreSQL has inactive replication slot.',
              description: 'PostgreSQL {{ $labels.instance }} has a replication slot not actively streaming. WAL files may accumulate!',
            },
          },
          {
            alert: 'PostgreSQLReplicationRoleChanged',
            expr: '(%s) > 0' % signals.cluster.roleChanges.asRuleExpression(),
            keep_firing_for: '5m',
            labels: { severity: config.alertReplicationRoleChangedSeverity },
            annotations: {
              summary: 'PostgreSQL replication role changed.',
              description: 'PostgreSQL {{ $labels.instance }} replication role has changed. Verify if this is expected failover.',
            },
          },
          {
            alert: 'PostgreSQLExporterErrors',
            expr: '(%s) > 0' % signals.problems.exporterErrors.asRuleExpression(),
            'for': '30m',
            keep_firing_for: '5m',
            labels: { severity: config.alertExporterErrorsSeverity },
            annotations: {
              summary: 'PostgreSQL exporter has errors.',
              description: 'PostgreSQL exporter for {{ $labels.instance }} is experiencing scrape errors.',
            },
          },
          {
            alert: 'PostgreSQLHighQps',
            expr: 'sum by (%s) (%s) > %s' % [agg, signals.performance.transactionsPerSecond.asRuleExpression(), config.alertHighQpsThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertHighQpsSeverity },
            annotations: {
              summary: 'PostgreSQL has high QPS.',
              description: 'PostgreSQL {{ $labels.instance }} has {{ $value | humanize }} queries per second.',
            },
          },
          {
            alert: 'PostgreSQLReplicationLagCritical',
            expr: '((%s) > %s) and on (%s) ((%s) == 1)' % [
              signals.health.replicationLag.asRuleExpression(),
              config.alertReplicationLagCriticalThreshold,
              agg,
              signals.health.isReplica.asRuleExpression(),
            ],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: config.alertReplicationLagCriticalSeverity },
            annotations: {
              summary: 'PostgreSQL replication lag exceeds 1 hour.',
              description: 'Replica {{ $labels.instance }} is {{ $value }}s behind primary. Check for network issues or load imbalances.',
            },
          },
        ],
      },
    ],
  },
}
