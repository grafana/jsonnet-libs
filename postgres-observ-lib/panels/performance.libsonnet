// Tier 3: Performance Trends Panels
local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals):: {
    // Transactions per second
    transactionsPerSecond:
      signals.performance.transactionsPerSecond.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Combined commits and rollbacks per second.'
      ),

    // Active connections
    activeConnections:
      signals.performance.activeConnections.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.panelOptions.withDescription(
        'Total active connections over time.'
      ),

    // Connection utilization over time
    connectionUtilizationTimeSeries:
      signals.health.connectionUtilization.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0.8, color: 'yellow' },
        { value: 0.95, color: 'red' },
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line'),

    // Temp bytes written
    tempBytesWritten:
      signals.performance.tempBytesWritten.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('bytes')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Bytes written to temp files. High values indicate work_mem is too small.'
      ),

    // Disk reads
    diskReads:
      signals.performance.diskReadWriteRatio.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Blocks read from disk (not cache). Spikes indicate cache misses.'
      ),

    // Cache hit ratio over time
    cacheHitRatioTimeSeries:
      signals.health.cacheHitRatio.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMin(0)
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0, color: 'red' },
        { value: 0.8, color: 'orange' },
        { value: 0.9, color: 'yellow' },
        { value: 0.95, color: 'green' },
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Cache hit ratio over time. Should stay above 95%.'
      ),

    // Buffers allocated rate
    checkpointDuration:
      signals.performance.checkpointDuration.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Rate of new buffer allocations per second. High values indicate memory pressure.'
      ),

    // Rollback ratio
    rollbackRatio:
      signals.performance.rollbackRatio.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0.05, color: 'yellow' },
        { value: 0.1, color: 'red' },
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Percentage of transactions rolled back. High values indicate application issues.'
      ),

    // ============================================
    // Rows Activity (from upstream postgres_mixin)
    // ============================================

    // Rows activity panel - combined view
    rowsActivity:
      g.panel.timeSeries.new('Rows Activity')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('rows/s')
      + signals.performance.rowsFetched.asPanelMixin()
      + signals.performance.rowsReturned.asPanelMixin()
      + signals.performance.rowsInserted.asPanelMixin()
      + signals.performance.rowsUpdated.asPanelMixin()
      + signals.performance.rowsDeleted.asPanelMixin()
      + g.panel.timeSeries.panelOptions.withDescription(
        'Row-level activity showing reads (fetched/returned) and writes (inserted/updated/deleted).'
      ),

    // ============================================
    // Buffer Activity (from upstream postgres_mixin)
    // ============================================

    // Buffers activity panel - combined view
    buffersActivity:
      g.panel.timeSeries.new('Buffers Activity')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + signals.performance.buffersAlloc.asPanelMixin()
      + signals.performance.buffersCheckpoint.asPanelMixin()
      + signals.performance.buffersClean.asPanelMixin()
      + signals.performance.buffersBackend.asPanelMixin()
      + signals.performance.buffersBackendFsync.asPanelMixin()
      + g.panel.timeSeries.panelOptions.withDescription(
        'Buffer pool activity: allocations, cleaned by bgwriter, and max written stops (I/O pressure indicator).'
      ),
  },
}
