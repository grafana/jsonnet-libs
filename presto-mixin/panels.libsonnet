local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      /*
      -------------------------
      Overview
      -------------------------
      */
      overviewActiveResourceManagers:
        commonlib.panels.generic.stat.info.new('Active resource managers', targets=[signals.overview.activeResourceManagers.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Active resource managers')
        + g.panel.stat.standardOptions.withUnit('none'),

      overviewActiveCoordinators:
        commonlib.panels.generic.stat.info.new('Active coordinators', targets=[signals.overview.activeCoordinators.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Active coordinators')
        + g.panel.stat.standardOptions.withUnit('none'),

      overviewActiveWorkers:
        commonlib.panels.generic.stat.info.new('Active workers', targets=[signals.overview.activeWorkers.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Active workers')
        + g.panel.stat.standardOptions.withUnit('none'),

      overviewInactiveWorkers:
        commonlib.panels.generic.stat.info.new('Inactive workers', targets=[signals.overview.inactiveWorkers.asTarget()])
        + g.panel.stat.panelOptions.withDescription('Inactive workers')
        + g.panel.stat.standardOptions.withUnit('none'),

      overviewCompletedQueries:
        commonlib.panels.generic.timeSeries.base.new('Completed queries - one minute count', targets=[signals.overview.completedQueries.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewAlertsPanel: {
        title: 'Alerts',
        type: 'alertlist',
        targets: [],
        options: {
          alertInstanceLabelFilter: '{job=~"${job:regex}", presto_cluster=~"${presto_cluster:regex}"}',
          alertName: '',
          dashboardAlerts: false,
          maxItems: 20,
          sortOrder: 1,
          stateFilter: {
            'error': true,
            firing: true,
            noData: false,
            normal: true,
            pending: true,
          },
          viewMode: 'list',
        },
      },

      overviewUserErrorFailureRate:
        commonlib.panels.generic.timeSeries.base.new('User error failures - one minute rate',
                                                     targets=[signals.overview.userErrorFailures.asTarget()])
        + g.panel.timeSeries.panelOptions.withDescription('The rate of user error failures occurring across clusters.')
        + g.panel.timeSeries.standardOptions.withUnit('err/s'),

      overviewQueuedQueries:
        commonlib.panels.generic.timeSeries.base.new('Queued queries',
                                                     targets=[signals.overview.queuedQueries.asTarget()])
        + g.panel.timeSeries.panelOptions.withDescription('The number of queued queries.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),


      overviewBlockedNodes:
        commonlib.panels.generic.timeSeries.base.new('Blocked nodes',
                                                     targets=[signals.overview.blockedNodes.asTarget()])
        + g.panel.timeSeries.panelOptions.withDescription('The number of nodes that are blocked due to memory restrictions.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      overviewInternalErrorFailureRate:
        commonlib.panels.generic.timeSeries.base.new('Internal error failures - one minute rate',
                                                     targets=[signals.overview.internalErrorFailures.asTarget()])
        + g.panel.timeSeries.panelOptions.withDescription('The rate of internal error failures occurring across clusters.')
        + g.panel.timeSeries.standardOptions.withUnit('err/s'),


      overviewClusterMemoryDistributed:
        commonlib.panels.generic.timeSeries.base.new('Cluster memory distributed bytes',
                                                     targets=[signals.overview.clusterMemoryDistributedBytesReserved.asTarget(), signals.overview.clusterMemoryDistributedBytesFree.asTarget()])
        + g.panel.timeSeries.panelOptions.withDescription('The amount of memory available across the clusters.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),


      overviewInsufficientResourceFailures:
        commonlib.panels.generic.timeSeries.base.new('Insufficient resource failures - one minute rate',
                                                     targets=[signals.overview.insufficientResourceFailures.asTarget()])
        + g.panel.timeSeries.panelOptions.withDescription('The rate that failures are occurring due to insufficient resources.')
        + g.panel.timeSeries.standardOptions.withUnit('err/s'),

      overviewDataProcessingThroughput:
        commonlib.panels.generic.timeSeries.base.new('Data processing throughput - one minute rate',
                                                     targets=[signals.overview.dataProcessingThroughputInput.asTarget(), signals.overview.dataProcessingThroughputOutput.asTarget()])
        + g.panel.timeSeries.panelOptions.withDescription('The rate at which volumes of data are being processed.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      /*
      -------------------------
      Coordinator
      -------------------------
      */

      coordinatorNonheapMemoryUsage:
        g.panel.gauge.new('Non-heap memory usage')
        + g.panel.gauge.queryOptions.withTargets(signals.coordinator.nonheapMemoryUsage.asTarget())
        + g.panel.gauge.panelOptions.withDescription('Non-heap memory usage')
        + g.panel.gauge.standardOptions.withUnit('percentunit')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0),
          g.panel.gauge.standardOptions.threshold.step.withColor('#EAB839')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.7),
          g.panel.gauge.standardOptions.threshold.step.withColor('light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.8),
        ]),

      coordinatorHeapMemoryUsage:
        g.panel.gauge.new('Heap memory usage')
        + g.panel.gauge.queryOptions.withTargets(signals.coordinator.heapMemoryUsage.asTarget())
        + g.panel.gauge.panelOptions.withDescription('Heap memory usage')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0),
          g.panel.gauge.standardOptions.threshold.step.withColor('#EAB839')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.7),
          g.panel.gauge.standardOptions.threshold.step.withColor('light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.8),
        ])
        + g.panel.gauge.standardOptions.withUnit('percentunit'),

      coordinatorErrorFailures:
        commonlib.panels.generic.timeSeries.base.new('Error failures - one minute count', targets=[signals.coordinator.errorFailuresInternal.asTarget()])
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      coordinatorNormalQueries:
        commonlib.panels.generic.timeSeries.base.new('Normal query - one minute count', targets=[
          signals.coordinator.queryCompleted.asTarget(),
          signals.coordinator.queryRunning.asTarget(),
          signals.coordinator.queryStarted.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      coordinatorAbnormalQueries:
        commonlib.panels.generic.timeSeries.base.new('Abnormal query - one minute count', targets=[
          signals.coordinator.abnormalQueryFailed.asTarget(),
          signals.coordinator.abnormalQueryAbandoned.asTarget(),
          signals.coordinator.abnormalQueryCanceled.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      coordinatorNormalQueryRate:
        commonlib.panels.generic.timeSeries.base.new('Normal query - one minute rate', targets=[
          signals.coordinator.normalQueryCompletedRate.asTarget(),
          signals.coordinator.normalQueryRunningRate.asTarget(),
          signals.coordinator.normalQueryStartedRate.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      coordinatorAbnormalQueryRate:
        commonlib.panels.generic.timeSeries.base.new('Abnormal query - one minute rate', targets=[
          signals.coordinator.abnormalQueryFailedRate.asTarget() { interval: '1m' },
          signals.coordinator.abnormalQueryAbandonedRate.asTarget() { interval: '1m' },
          signals.coordinator.abnormalQueryCanceledRate.asTarget() { interval: '1m' },
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      coordinatorQueryExecutionTime:
        commonlib.panels.generic.timeSeries.base.new('Query execution time - one minute count', targets=[
          signals.coordinator.queryExecutionTimeP50.asTarget(),
          signals.coordinator.queryExecutionTimeP75.asTarget(),
          signals.coordinator.queryExecutionTimeP95.asTarget(),
          signals.coordinator.queryExecutionTimeP99.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      coordinatorCPUTimeConsumed:
        commonlib.panels.cpu.timeSeries.base.new('CPU time consumed - one minute count', targets=[
          signals.coordinator.cpuTimeConsumed.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      coordinatorCPUInputThroughput:
        commonlib.panels.cpu.timeSeries.base.new('CPU input throughput - one minute count', targets=[
          signals.coordinator.cpuInputThroughput.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      coordinatorGarbageCollections:
        commonlib.panels.generic.timeSeries.base.new('Garbage collection count / $__interval', targets=[
          signals.coordinator.jvmGarbageCollectorCount.asTarget() { interval: '2m' },
        ])
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      coordinatorJVMGarbageCollectionDuration:
        commonlib.panels.generic.timeSeries.base.new(
          'Garbage collection duration',
          targets=[
            signals.coordinator.jvmGarbageCollectionDuration.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The average duration for each garbage collection operation in the JVM.')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      coordinatorJVMMemoryUsage:
        commonlib.panels.generic.timeSeries.base.new('Memory used', targets=[
          signals.coordinator.jvmHeapMemoryUsage.asTarget(),
          signals.coordinator.jvmNonHeapMemoryUsage.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The heap and non-heap memory used by the JVM.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),

      coordinatorJVMMemoryCommitted:
        commonlib.panels.generic.timeSeries.base.new('Memory committed', targets=[
          signals.coordinator.jvmHeapMemoryCommitted.asTarget(),
          signals.coordinator.jvmNonHeapMemoryCommitted.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The heap and non-heap memory committed by the JVM.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),


      /*
      -------------------------
      Worker
      -------------------------
      */

      workerNonHeapMemoryUsage:
        g.panel.gauge.new('Non-heap memory usage')
        + g.panel.gauge.queryOptions.withTargets(signals.worker.nonheapMemoryUsage.asTarget())
        + g.panel.gauge.panelOptions.withDescription('Non-heap memory usage')
        + g.panel.gauge.standardOptions.withUnit('percentunit')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0),
          g.panel.gauge.standardOptions.threshold.step.withColor('#EAB839')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.7),
          g.panel.gauge.standardOptions.threshold.step.withColor('light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.8),
        ]),

      workerHeapMemoryUsage:
        g.panel.gauge.new('Heap memory usage')
        + g.panel.gauge.queryOptions.withTargets(signals.worker.heapMemoryUsage.asTarget())
        + g.panel.gauge.panelOptions.withDescription('Heap memory usage')
        + g.panel.gauge.standardOptions.withUnit('percentunit')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.standardOptions.threshold.step.withColor('light-green')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0),
          g.panel.gauge.standardOptions.threshold.step.withColor('#EAB839')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.7),
          g.panel.gauge.standardOptions.threshold.step.withColor('light-red')
          + g.panel.gauge.standardOptions.threshold.step.withValue(0.8),
        ]),


      workerQueuedTasks:
        commonlib.panels.generic.timeSeries.base.new('Queued tasks', targets=[
          signals.worker.queuedTasks.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The number of tasks that are being queued by the task executor.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      workerFailedCompletedTasks:
        commonlib.panels.generic.timeSeries.base.new('Failed & completed tasks', targets=[
          signals.worker.failedTasks.asTarget() { interval: '1m' },
          signals.worker.completedTasks.asTarget() { interval: '1m' },
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The rate at which tasks have failed and completed.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('ops'),

      workerOutputPositions:
        commonlib.panels.generic.timeSeries.base.new('Output positions - one minute rate', targets=[
          signals.worker.outputPositions.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The rate of rows (or records) produced by an operation.')
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      workerExecutorPoolSize:
        commonlib.panels.generic.timeSeries.base.new('Executor pool size', targets=[
          signals.worker.taskNotificationExecutorPoolSize.asTarget(),
          signals.worker.processExecutorCorePoolSize.asTarget(),
          signals.worker.processExecutorPoolSize.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The pool size of the task notification executor.')
        + g.panel.timeSeries.standardOptions.withUnit('none')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      workerMemoryPool:
        commonlib.panels.generic.timeSeries.base.new('Memory pool', targets=[
          signals.worker.memoryPoolFreeBytes.asTarget(),
          signals.worker.memoryPoolReservedFreeBytes.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The amount of Presto memory available.')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      workerDataProcessingThroughput:
        commonlib.panels.generic.timeSeries.base.new('Data processing throughput - one minute rate', targets=[
          signals.worker.dataProcessingInput.asTarget(),
          signals.worker.dataProcessingOutput.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The rate at which volumes of data are being processed.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      // Worker JVM

      workerJVMGarbageCollectorCount:
        commonlib.panels.generic.timeSeries.base.new('Garbage collection count / $__interval', targets=[
          signals.worker.garbageCollectionCount.asTarget() { interval: '2m' },
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The recent increase in the number of garbage collection events for the JVM.')
        + g.panel.timeSeries.standardOptions.withUnit('none'),

      workerJVMGarbageCollectionDuration:
        commonlib.panels.generic.timeSeries.base.new('Garbage collection duration', targets=[
          signals.worker.garbageCollectionDuration.asTarget() { interval: '2m' },
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The average duration for each garbage collection operation in the JVM.')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),


      workerJVMMemoryUsage:
        commonlib.panels.generic.timeSeries.base.new('Memory used', targets=[
          signals.worker.jvmHeapMemoryUsage.asTarget(),
          signals.worker.jvmNonHeapMemoryUsage.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The heap and non-heap memory used by the JVM.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),

      workerJVMMemoryCommitted:
        commonlib.panels.generic.timeSeries.base.new('Memory committed', targets=[
          signals.worker.jvmHeapMemoryCommitted.asTarget(),
          signals.worker.jvmNonHeapMemoryCommitted.asTarget(),
        ])
        + g.panel.timeSeries.panelOptions.withDescription('The heap and non-heap memory committed by the JVM.')
        + g.panel.timeSeries.options.legend.withAsTable(true)
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('decbytes'),

    },
}
