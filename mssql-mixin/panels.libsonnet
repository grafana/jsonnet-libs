local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this)::
    {
      local signals = this.signals,
      local stat = g.panel.stat,
      local fieldOverride = g.panel.table.fieldOverride,
      local alertList = g.panel.alertList,
      local pieChart = g.panel.pieChart,
      local barGauge = g.panel.barGauge,

      connectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Connections',
          targets=[signals.connections.mssqlConnections.asTarget()],
          description='The number of network connections to each database.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('connections')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(54)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      batchRequestsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Batch requests',
          targets=[
            signals.connections.batchRequests.asTarget() { interval: '1m' },
          ],
          description='Number of batch requests.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('reqps')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      severeErrorsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Severe errors',
          targets=[signals.connections.severeErrors.asTarget() { interval: '1m' }],
          description='Number of severe errors that caused connections to be killed.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('errors')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      deadlocksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Deadlocks',
          targets=[signals.connections.deadlocks.asTarget() { interval: '1m' }],
          description='Rate of deadlocks occurring over time.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('deadlocks')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      osMemoryUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'OS memory usage',
          targets=[signals.memory.osMemoryUsage.asTarget()],
          description='The amount of physical memory available and used by SQL Server.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(51)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      memoryManagerPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory manager',
          targets=[signals.memory.memoryManagerTotal.asTarget(), signals.memory.memoryManagerTarget.asTarget()],
          description='The committed memory and target committed memory for the SQL Server memory manager. See https://learn.microsoft.com/en-us/sql/relational-databases/performance-monitor/monitor-memory-usage?view=sql-server-ver16#isolating-memory-used-by-'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(51)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      committedMemoryUtilizationPanel:
        g.panel.gauge.new(title='Committed memory utilization')
        + g.panel.gauge.queryOptions.withTargets([
          signals.memory.committedMemoryUtilization.asTarget(),
        ])
        + g.panel.gauge.panelOptions.withDescription('The committed memory utilization')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.gauge.standardOptions.withUnit('percent'),

      databaseWriteStallDurationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database write stall duration',
          targets=[signals.database.databaseWriteStallDuration.asTarget() { interval: '1m' }],
          description='The current stall (latency) for database writes.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      databaseReadStallDurationPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Database read stall duration',
          targets=[signals.database.databaseReadStallDuration.asTarget() { interval: '1m' }],
          description='The current stall (latency) for database reads.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      transactionLogExpansionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Transaction log expansions',
          targets=[signals.database.transactionLogExpansions.asTarget() { interval: '1m' }],
          description='Number of times the transaction log has been expanded for a database.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('expansions')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      pageFileMemoryPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Page file memory',
          targets=[signals.memory.pageFileMemory.asTarget()],
          description='Memory used for the OS page file.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(50)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      bufferCacheHitPercentagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Buffer cache hit percentage',
          targets=[signals.memory.bufferCacheHitPercentage.asTarget()],
          description='Percentage of page found and read from the SQL Server buffer cache.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      pageCheckpointsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Page checkpoints',
          targets=[signals.memory.pageCheckpoints.asTarget()],
          description='Rate of page checkpoints per second.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('checkpoints/s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),

      pageFaultsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Page faults',
          targets=[signals.memory.pageFaults.asTarget() { interval: '1m' }],
          description='The number of page faults that were incurred by the SQL Server process.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('faults')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(0)
        + g.panel.timeSeries.fieldConfig.defaults.custom.withSpanNulls(false),
    },
}
