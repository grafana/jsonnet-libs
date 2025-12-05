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

    // QPS - Queries per second
    queriesPerSecond:
      signals.performance.queriesPerSecond.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Queries per second. Requires pg_stat_statements extension.'
      ),

    connectionUtilizationTimeSeries:
      signals.health.connectionUtilization.asTimeSeries()
      + commonlib.panels.generic.timeSeries.percentage.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0.8, color: 'yellow' },
        { value: 0.95, color: 'red' },
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line'),

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

    cacheHitRatioTimeSeries:
      signals.health.cacheHitRatio.asTimeSeries()
      + commonlib.panels.generic.timeSeries.percentage.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
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

    checkpointDuration:
      signals.performance.checkpointDuration.asTimeSeries()
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Rate of new buffer allocations per second. High values indicate memory pressure.'
      ),

    rollbackRatio:
      signals.performance.rollbackRatio.asTimeSeries()
      + commonlib.panels.generic.timeSeries.percentage.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('percentunit')
      + g.panel.timeSeries.standardOptions.withMax(1)
      + g.panel.timeSeries.standardOptions.thresholds.withSteps([
        { value: 0.05, color: 'yellow' },
        { value: 0.1, color: 'red' },
      ])
      + g.panel.timeSeries.fieldConfig.defaults.custom.thresholdsStyle.withMode('line')
      + g.panel.timeSeries.panelOptions.withDescription(
        'Percentage of transactions rolled back. High values indicate application issues.'
      ),

    rowsActivity:
      g.panel.timeSeries.new('Rows Activity')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('rows/s')
      + signals.performance.rowsFetched.asPanelMixin()
      + signals.performance.rowsReturned.asPanelMixin()
      + signals.performance.rowsInserted.asPanelMixin()
      + signals.performance.rowsUpdated.asPanelMixin()
      + signals.performance.rowsDeleted.asPanelMixin()
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withCalcs(['lastNotNull'])
      + g.panel.timeSeries.options.legend.withSortBy('Last *')
      + g.panel.timeSeries.options.legend.withSortDesc(true)
      + g.panel.timeSeries.panelOptions.withDescription(
        'Row-level activity showing reads (fetched/returned) and writes (inserted/updated/deleted).'
      ),

    buffersActivity:
      g.panel.timeSeries.new('Buffers Activity')
      + commonlib.panels.generic.timeSeries.base.stylize()
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + signals.performance.buffersAlloc.asPanelMixin()
      + signals.performance.buffersCheckpoint.asPanelMixin()
      + signals.performance.buffersClean.asPanelMixin()
      + signals.performance.buffersBackend.asPanelMixin()
      + g.panel.timeSeries.options.legend.withDisplayMode('table')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.legend.withCalcs(['lastNotNull'])
      + g.panel.timeSeries.options.legend.withSortBy('Last *')
      + g.panel.timeSeries.options.legend.withSortDesc(true)
      + g.panel.timeSeries.panelOptions.withDescription(
        'Buffer pool activity: allocations, cleaned by bgwriter, and max written stops (I/O pressure indicator).'
      ),

    // Read/Write ratio pie chart
    readWriteRatio:
      g.panel.pieChart.new('Read/Write Ratio')
      + g.panel.pieChart.panelOptions.withDescription(
        'Ratio of read operations (fetched) to write operations (insert+update+delete).'
      )
      + signals.performance.rowsFetched.asPanelMixin()
      + signals.performance.rowsInserted.asPanelMixin()
      + signals.performance.rowsUpdated.asPanelMixin()
      + signals.performance.rowsDeleted.asPanelMixin()
      + g.panel.pieChart.options.withPieType('donut')
      + g.panel.pieChart.options.withDisplayLabels([])
      + g.panel.pieChart.options.legend.withShowLegend(true)
      + g.panel.pieChart.options.legend.withDisplayMode('table')
      + g.panel.pieChart.options.legend.withPlacement('bottom')
      + g.panel.pieChart.options.legend.withValues(['value', 'percent'])
      + g.panel.pieChart.standardOptions.withUnit('rows/s'),
  },
}
