local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

{
  new(this): {
    local config = this.config,
    local signals = this.signals,
    local instanceLabel = xtd.array.slice(config.instanceLabels, -1)[0],

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
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL is down.',
              description: 'PostgreSQL instance {{ $labels.%s }} is not responding.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLHighConnectionUsage',
            expr: '(%s) > %g' % [signals.health.connectionUtilization.asRuleExpression(), config.alertHighConnectionUsageWarningThreshold / 100],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL connection usage is high.',
              description: 'PostgreSQL {{ $labels.%s }} is at {{ $value | humanizePercentage }} connection capacity.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLLowCacheHitRatio',
            expr: '(%s) < %g' % [signals.health.cacheHitRatio.asRuleExpression(), config.alertLowCacheHitRatioWarningThreshold / 100],
            'for': '15m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL cache hit ratio is low.',
              description: 'PostgreSQL {{ $labels.%s }} cache hit ratio is {{ $value | humanizePercentage }}. Consider increasing shared_buffers.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLReplicationLag',
            expr: '(%s) > %s' % [signals.health.replicationLag.asRuleExpression(), config.alertReplicationLagWarningThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL replication lag is high.',
              description: 'Replica {{ $labels.%s }} is {{ printf "%%.0f" $value }}s behind primary.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLDeadlocks',
            expr: '(%s) > %s' % [signals.health.deadlocks.asRuleExpression(), config.alertDeadlocksWarningThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL deadlocks detected.',
              description: 'PostgreSQL {{ $labels.%s }} database {{ $labels.datname }} has deadlocks.' % instanceLabel,
            },
          },

          // Active Problems Alerts
          {
            alert: 'PostgreSQLLongRunningQuery',
            expr: '(%s) > %s' % [signals.problems.longestActiveTransaction.asRuleExpression(), config.alertLongRunningQueryWarningThreshold],
            'for': '1m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has long-running query.',
              description: 'Query on {{ $labels.%s }} has been running for {{ $value | humanizeDuration }}.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLBlockedQueries',
            expr: 'sum by (%s) (%s) > %s' % [signals.problems.blockedQueries.vars.agg, signals.problems.blockedQueries.asRuleExpression(), config.alertBlockedQueriesWarningThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has blocked queries.',
              description: 'PostgreSQL {{ $labels.%s }} has {{ $value }} queries waiting for locks.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLWALArchiveFailure',
            expr: '(%s) > 0' % signals.problems.walArchiveFailures.withRangeFunction('rate').asRuleExpression(),
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL WAL archiving is failing.',
              description: 'PostgreSQL {{ $labels.%s }} is failing to archive WAL files. Backups may be incomplete!' % instanceLabel,
            },
          },

          // Maintenance Alerts
          {
            alert: 'PostgreSQLHighDeadTuples',
            expr: '(%s) > %g and (%s) > %s' % [
              signals.maintenance.deadTupleRatio.asRuleExpression(),
              config.alertHighDeadTuplesWarningThreshold / 100,
              signals.maintenance.deadTuples.asRuleExpression(),
              config.alertHighDeadTuplesMinDeadTuples,
            ],
            'for': '30m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL table needs vacuum.',
              description: 'Table {{ $labels.schemaname }}.{{ $labels.relname }} has {{ $value | humanizePercentage }} dead tuples.',
            },
          },
          {
            alert: 'PostgreSQLVacuumNotRunning',
            // Written out to keep tables never vacuumed, which the dashboard's vacuum age signal leaves out.
            expr: |||
              (
                time() - (
                  pg_stat_user_tables_last_autovacuum{%(filteringSelector)s} > pg_stat_user_tables_last_vacuum{%(filteringSelector)s}
                  or
                  pg_stat_user_tables_last_vacuum{%(filteringSelector)s}
                )
              ) > %(alertVacuumNotRunningWarningThreshold)s
              and
              pg_stat_user_tables_n_dead_tup{%(filteringSelector)s} > %(alertVacuumNotRunningDeadTuples)s
            ||| % config { alertVacuumNotRunningWarningThreshold: config.alertVacuumNotRunningWarningThreshold * 86400 },
            'for': '1h',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL table has not been vacuumed.',
              description: 'Table {{ $labels.schemaname }}.{{ $labels.relname }} has not been vacuumed in over %g days.' % config.alertVacuumNotRunningWarningThreshold,
            },
          },

          {
            alert: 'PostgreSQLTooManyRollbacks',
            expr: '(%s) > %g' % [signals.performance.rollbackRatio.asRuleExpression(), config.alertTooManyRollbacksWarningThreshold / 100],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has too many rollbacks.',
              description: 'PostgreSQL {{ $labels.%s }} has rollback ratio of {{ $value | humanizePercentage }}.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLTooManyLocksAcquired',
            expr: '(%s) > %g' % [signals.problems.lockUtilization.asRuleExpression(), config.alertTooManyLocksAcquiredWarningThreshold / 100],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has acquired too many locks.',
              description: 'PostgreSQL {{ $labels.%s }} lock utilization is {{ $value | humanizePercentage }}.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLInactiveReplicationSlot',
            expr: '(%s) == 0' % signals.problems.replicationSlotActive.asRuleExpression(),
            'for': '30m',
            keep_firing_for: '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL has inactive replication slot.',
              description: 'PostgreSQL {{ $labels.%s }} replication slot {{ $labels.slot_name }} is not actively streaming. WAL files may accumulate!' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLReplicationRoleChanged',
            // No 'for': the expression is true for under 5 minutes after a role change, so a 5m 'for' never fires.
            expr: '(%s) > 0' % signals.cluster.roleChanges.asRuleExpression(),
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL replication role changed.',
              description: 'PostgreSQL {{ $labels.%s }} replication role has changed. Verify if this is expected failover.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLExporterErrors',
            expr: '(%s) > 0' % signals.problems.exporterErrors.asRuleExpression(),
            'for': '30m',
            keep_firing_for: '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL exporter has errors.',
              description: 'PostgreSQL exporter for {{ $labels.%s }} is experiencing scrape errors.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLHighQps',
            expr: 'sum by (%s) (%s) > %s' % [signals.performance.transactionsPerSecond.vars.agg, signals.performance.transactionsPerSecond.asRuleExpression(), config.alertHighQpsWarningThreshold],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'warning' },
            annotations: {
              summary: 'PostgreSQL has high transactions per second.',
              description: 'PostgreSQL {{ $labels.%s }} has {{ $value | humanize }} transactions per second.' % instanceLabel,
            },
          },
          {
            alert: 'PostgreSQLReplicationLagCritical',
            expr: '((%s) > %s) and on (%s) ((%s) == 1)' % [
              signals.health.replicationLag.asRuleExpression(),
              config.alertReplicationLagCriticalThreshold,
              signals.health.isReplica.vars.agg,
              signals.health.isReplica.asRuleExpression(),
            ],
            'for': '5m',
            keep_firing_for: '5m',
            labels: { severity: 'critical' },
            annotations: {
              summary: 'PostgreSQL replication lag is critically high.',
              description: 'Replica {{ $labels.%s }} is {{ printf "%%.0f" $value }}s behind primary. The threshold is %ss. Check for network issues or load imbalances.' % [instanceLabel, config.alertReplicationLagCriticalThreshold],
            },
          },
        ],
      },
    ],
  },
}
