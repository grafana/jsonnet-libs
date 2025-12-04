// Tier 2: Active Problems Panels
local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals):: {
    // Long-running queries
    longRunningQueries:
      signals.problems.longRunningQueries.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'yellow' },
        { value: 3, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Queries running longer than 5 minutes. Check pg_stat_activity for details.'
      ),

    // Blocked queries
    blockedQueries:
      signals.problems.blockedQueries.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'yellow' },
        { value: 5, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Queries waiting for locks. Indicates lock contention.'
      ),

    // Idle in transaction
    idleInTransaction:
      signals.problems.idleInTransaction.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 5, color: 'yellow' },
        { value: 20, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Connections idle in transaction. Can hold locks and block others.'
      ),

    // WAL archive failures
    walArchiveFailures:
      signals.problems.walArchiveFailures.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withReduceOptions({ calcs: ['diff'] })
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'WAL archive failures. Non-zero indicates backup problems!'
      ),

    // Checkpoint warnings
    checkpointWarnings:
      signals.problems.checkpointWarnings.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.withUnit('percentunit')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.1, color: 'yellow' },
        { value: 0.3, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Ratio of requested vs timed checkpoints. High = checkpoint_completion_target needs tuning.'
      ),

    // Backend writes
    backendWrites:
      signals.problems.backendWrites.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Buffers written by backends (not bgwriter). Should be near zero.'
      ),

    // Combined problems row panel
    problemsSummary:
      g.panel.timeSeries.new('Active Problems')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + signals.problems.longRunningQueries.asPanelMixin()
      + signals.problems.blockedQueries.asPanelMixin()
      + signals.problems.idleInTransaction.asPanelMixin(),

    // ============================================
    // Additional panels from upstream postgres_mixin
    // ============================================

    // Conflicts and Deadlocks (combined panel from upstream)
    conflictsDeadlocks:
      g.panel.timeSeries.new('Conflicts / Deadlocks')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('short')
      + signals.health.deadlocks.asPanelMixin()
      + signals.problems.conflicts.asPanelMixin()
      + g.panel.timeSeries.panelOptions.withDescription(
        'Deadlocks and conflicts (replica recovery cancellations).'
      ),

    // Lock utilization
    lockUtilization:
      signals.problems.lockUtilization.asGauge()
      + g.panel.gauge.standardOptions.withUnit('percentunit')
      + g.panel.gauge.standardOptions.withMin(0)
      + g.panel.gauge.standardOptions.withMax(1)
      + g.panel.gauge.standardOptions.color.withMode('thresholds')
      + g.panel.gauge.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 0.05, color: 'yellow' },
        { value: 0.1, color: 'orange' },
        { value: 0.2, color: 'red' },
      ])
      + g.panel.gauge.options.withMinVizHeight(200)
      + g.panel.gauge.options.withMinVizWidth(200)
      + g.panel.gauge.options.withShowThresholdLabels(false)
      + g.panel.gauge.panelOptions.withDescription(
        'Lock utilization as percentage of max_locks_per_transaction * max_connections.'
      ),

    // Inactive replication slots
    inactiveReplicationSlots:
      signals.problems.inactiveReplicationSlots.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.options.withGraphMode('area')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'Inactive replication slots. Can cause WAL to accumulate and fill disk!'
      ),

    // Exporter errors
    exporterErrors:
      signals.problems.exporterErrors.asStat()
      + commonlib.panels.generic.stat.info.stylize()
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.options.withColorMode('value')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        { value: 0, color: 'green' },
        { value: 1, color: 'red' },
      ])
      + g.panel.stat.panelOptions.withDescription(
        'PostgreSQL exporter scrape errors.'
      ),
  },
}

