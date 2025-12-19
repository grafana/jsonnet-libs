local g = (import './g.libsonnet');
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      //
      // Overview Dashboard Panels
      //
      dagFileParsingErrorsPanel:
        commonlib.panels.generic.timeSeries.base.new('DAG file parsing errors', targets=[signals.overview.dagParsingErrors.asTarget()])
        + g.panel.timeSeries.panelOptions.withDescription('The number of errors from trying to parse DAG files in an Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      slaIssuesPanel:
        commonlib.panels.generic.timeSeries.base.new('SLA misses', targets=[
          signals.overview.taskSlaMisses.asTarget() { interval: '2m' },
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of Service Level Agreement misses for any DAG runs in the Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      taskFailuresPanel:
        commonlib.panels.generic.timeSeries.base.new('Task failures', targets=[
          signals.overview.taskFailures.asTarget() { interval: '2m' },
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The overall task instances failures for an Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      dagSuccessDurationPanel:
        commonlib.panels.generic.timeSeries.base.new('DAG success duration', targets=[
          signals.overview.dagAvgSuccessDuration.asTarget() { interval: '2m' },
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The average time taken for recent successful DAG runs by DAG ID in the Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      dagFailedDurationPanel:
        commonlib.panels.generic.timeSeries.base.new('DAG failed duration', targets=[
          signals.overview.dagAvgFailedDuration.asTarget() { interval: '2m' },
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The average time taken for recent failed DAG runs by DAG ID in the Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      taskDurationPanel:
        g.panel.barGauge.new('Task duration')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.overview.taskAvgDuration.asTarget() { interval: '2m' },
        ])
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.panelOptions.withDescription('The average time taken for recent task runs by Task ID in the Apache Airflow system.')
        + g.panel.barGauge.standardOptions.withUnit('s'),

      taskCountSummaryPanel:
        g.panel.pieChart.new(
          'Task count summary'
        )
        + g.panel.pieChart.queryOptions.withTargets([
          signals.overview.taskFinishTotalSum.asTarget() { interval: '2m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.legend.withAsTable(true)
        + g.panel.pieChart.panelOptions.withDescription('The number of task counts by DAG ID in the Apache Airflow system.')
        + g.panel.pieChart.standardOptions.withUnit('none'),

      taskCountsPanel:
        commonlib.panels.generic.timeSeries.base.new('Task counts', targets=[
          signals.overview.taskFinishTotal.asTarget() { interval: '2m' },
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of task counts by Task ID in the Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      //
      // Scheduler Details Panels
      //

      dagScheduleDelayPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'DAG schedule delay',
          targets=[
            signals.overview.dagAvgScheduleDelay.asTarget() { interval: '2m' },
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The amount of average delay between recent scheduled DAG runtime and the actual DAG runtime by DAG ID in the Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      schedulerTasksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Scheduler tasks',
          targets=[
            signals.overview.schedulerTasksExecutable.asTarget(),
            signals.overview.schedulerTasksStarving.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of current tasks that the scheduler is handling in the Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      executorTasksPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Executor tasks',
          targets=[
            signals.overview.executorRunningTasks.asTarget(),
            signals.overview.executorQueuedTasks.asTarget(),
            signals.overview.executorOpenSlots.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of current tasks that the executors are handling in the Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      poolTaskSlotsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Pool task slots',
          targets=[
            signals.overview.poolRunningSlots.asTarget(),
            signals.overview.poolQueuedSlots.asTarget(),
            signals.overview.poolStarvingTasks.asTarget(),
            signals.overview.poolOpenSlots.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of current task slots that the pools are handling in the Apache Airflow system.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),
    },
}
