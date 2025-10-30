local g = (import './g.libsonnet');
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      //
      // Overview Dashboard Panels
      //

      // Panel 1: DAG file parsing errors
      dagFileParsingErrorsPanel:
        g.panel.timeSeries.new('DAG file parsing errors')
        + g.panel.timeSeries.panelOptions.withDescription('The number of errors from trying to parse DAG files in an Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.dags.parsingErrors.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(1),
        ]),

      // Panel 2: SLA misses
      slaIssuesPanel:
        g.panel.timeSeries.new('SLA misses')
        + g.panel.timeSeries.panelOptions.withDescription('The number of Service Level Agreement misses for any DAG runs in the Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.tasks.slaMisses.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(80),
        ]),

      // Panel 3: Task failures
      taskFailuresPanel:
        g.panel.timeSeries.new('Task failures')
        + g.panel.timeSeries.panelOptions.withDescription('The overall task instances failures for an Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.tasks.failures.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(1),
        ]),

      // Panel 4: DAG success duration
      dagSuccessDurationPanel:
        g.panel.timeSeries.new('DAG success duration')
        + g.panel.timeSeries.panelOptions.withDescription('The average time taken for recent successful DAG runs by DAG ID in the Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.dags.avgSuccessDuration.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      // Panel 5: DAG failed duration
      dagFailedDurationPanel:
        g.panel.timeSeries.new('DAG failed duration')
        + g.panel.timeSeries.panelOptions.withDescription('The average time taken for recent failed DAG runs by DAG ID in the Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.dags.avgFailedDuration.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      // Panel 6: Task duration (bargauge)
      taskDurationPanel:
        g.panel.barGauge.new('Task duration')
        + g.panel.barGauge.panelOptions.withDescription('The average time taken for recent task runs by Task ID in the Apache Airflow system.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.tasks.avgDuration.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.barGauge.standardOptions.withUnit('s')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.color.withMode('thresholds')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('green')
          + g.panel.barGauge.thresholdStep.withValue(null),
        ])
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withShowUnfilled(true)
        + g.panel.barGauge.options.reduceOptions.withCalcs(['lastNotNull']),

      // Panel 7: Task count summary (piechart)
      taskCountSummaryPanel:
        g.panel.pieChart.new('Task count summary')
        + g.panel.pieChart.panelOptions.withDescription('The number of task counts by DAG ID in the Apache Airflow system.')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.tasks.finishTotal.withExprWrappersMixin(['sum by(job, instance, dag_id, state) (', ')'])
          .asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withLegendFormat('{{dag_id}} - {{state}}'),
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.tooltip.withMode('multi'),

      // Panel 8: Task counts
      taskCountsPanel:
        g.panel.timeSeries.new('Task counts')
        + g.panel.timeSeries.panelOptions.withDescription('The number of task counts by Task ID in the Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.tasks.finishTotal.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
        ])
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      //
      // Scheduler Details Panels
      //

      // Panel 9: DAG schedule delay
      dagScheduleDelayPanel:
        g.panel.timeSeries.new('DAG schedule delay')
        + g.panel.timeSeries.panelOptions.withDescription('The amount of average delay between recent scheduled DAG runtime and the actual DAG runtime by DAG ID in the Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.dags.avgScheduleDelay.asTarget()
          + g.query.prometheus.withInterval('1m')
          + g.query.prometheus.withLegendFormat('{{instance}} - {{dag_id}}'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      // Panel 10: Scheduler tasks
      schedulerTasksPanel:
        g.panel.timeSeries.new('Scheduler tasks')
        + g.panel.timeSeries.panelOptions.withDescription('The number of current tasks that the scheduler is handling in the Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.scheduler.tasksExecutable.asTarget()
          + g.query.prometheus.withLegendFormat('{{instance}} - executable'),
          signals.scheduler.tasksStarving.asTarget()
          + g.query.prometheus.withLegendFormat('{{instance}} - starving'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      // Panel 11: Executor tasks
      executorTasksPanel:
        g.panel.timeSeries.new('Executor tasks')
        + g.panel.timeSeries.panelOptions.withDescription('The number of current tasks that the executors are handling in the Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.executor.runningTasks.asTarget()
          + g.query.prometheus.withLegendFormat('{{instance}} - running'),
          signals.executor.queuedTasks.asTarget()
          + g.query.prometheus.withLegendFormat('{{instance}} - queued'),
          signals.executor.openSlots.asTarget()
          + g.query.prometheus.withLegendFormat('{{instance}} - open'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      // Panel 12: Pool task slots
      poolTaskSlotsPanel:
        g.panel.timeSeries.new('Pool task slots')
        + g.panel.timeSeries.panelOptions.withDescription('The number of task slots available in the pools of the Apache Airflow system.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.pools.runningSlots.asTarget()
          + g.query.prometheus.withLegendFormat('{{pool_name}} - running'),
          signals.pools.queuedSlots.asTarget()
          + g.query.prometheus.withLegendFormat('{{pool_name}} - queued'),
          signals.pools.starvingTasks.asTarget()
          + g.query.prometheus.withLegendFormat('{{pool_name}} - starving'),
          signals.pools.openSlots.asTarget()
          + g.query.prometheus.withLegendFormat('{{pool_name}} - open'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.standardOptions.withMin(0)
        + g.panel.timeSeries.standardOptions.withDecimals(0)
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green')
          + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red')
          + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi'),

      //
      // Logs Dashboard Panels
      //

      // Panel 13: Task logs
      taskLogsPanel:
        g.panel.logs.new('Task logs')
        + g.panel.logs.panelOptions.withDescription('Logs for each individual task run on the DAGs.')
        + g.panel.logs.queryOptions.withTargets([
          g.query.loki.new(
            '${loki_datasource}',
            '{' + this.config.filteringSelector + ', dag_id=~"$dag_id", task_id=~"$task_id", filename=~".*/airflow/logs/dag_id.*"} |= ``'
          ),
        ])
        + g.panel.logs.options.withEnableLogDetails(true)
        + g.panel.logs.options.withShowCommonLabels(false)
        + g.panel.logs.options.withShowTime(false)
        + g.panel.logs.options.withWrapLogMessage(false),

      // Panel 14: Scheduler logs
      schedulerLogsPanel:
        g.panel.logs.new('Scheduler logs')
        + g.panel.logs.panelOptions.withDescription('Logs for the scheduler in the Apache Airflow system.')
        + g.panel.logs.queryOptions.withTargets([
          g.query.loki.new(
            '${loki_datasource}',
            '{' + this.config.filteringSelector + ', filename=~".*/airflow/logs/scheduler/.*"} |= ``'
          ),
        ])
        + g.panel.logs.options.withEnableLogDetails(true)
        + g.panel.logs.options.withShowCommonLabels(false)
        + g.panel.logs.options.withShowTime(false)
        + g.panel.logs.options.withWrapLogMessage(false),
    },
}
