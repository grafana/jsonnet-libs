local g = import './g.libsonnet';

{
  new(this): {
    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.overviewActiveResourceManagers { gridPos+: { h: 4, w: 6 } },
          this.grafana.panels.overviewActiveCoordinators { gridPos+: { h: 4, w: 6 } },
          this.grafana.panels.overviewActiveWorkers { gridPos+: { h: 4, w: 6 } },
          this.grafana.panels.overviewInactiveWorkers { gridPos+: { h: 4, w: 6 } },
          this.grafana.panels.overviewCompletedQueries { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.overviewAlertsPanel { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.overviewUserErrorFailureRate { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.overviewQueuedQueries { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.overviewBlockedNodes { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.overviewInternalErrorFailureRate { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.overviewClusterMemoryDistributed { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.overviewInsufficientResourceFailures { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.overviewDataProcessingThroughput { gridPos+: { h: 9, w: 24 } },
        ],
      ),

    coordinator:
      g.panel.row.new('Coordinator')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.coordinatorNonheapMemoryUsage { gridPos+: { w: 6 } },
          this.grafana.panels.coordinatorHeapMemoryUsage { gridPos+: { w: 6 } },
          this.grafana.panels.coordinatorErrorFailures { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorNormalQueries { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorAbnormalQueries { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorNormalQueryRate { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorAbnormalQueryRate { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorQueryExecutionTime { gridPos+: { w: 24 } },
          this.grafana.panels.coordinatorCPUTimeConsumed { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorCPUInputThroughput { gridPos+: { w: 12 } },
        ],
      ),
    coordinatorJVM:
      g.panel.row.new('JVM')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.coordinatorGarbageCollections { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorJVMGarbageCollectionDuration { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorJVMMemoryCommitted { gridPos+: { w: 12 } },
          this.grafana.panels.coordinatorJVMMemoryUsage { gridPos+: { w: 12 } },
        ],
      ),

    worker:
      g.panel.row.new('Worker')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.workerNonHeapMemoryUsage { gridPos+: { w: 3 } },
          this.grafana.panels.workerHeapMemoryUsage { gridPos+: { w: 3 } },
          this.grafana.panels.workerQueuedTasks { gridPos+: { w: 6 } },
          this.grafana.panels.workerFailedCompletedTasks { gridPos+: { w: 12 } },
          this.grafana.panels.workerOutputPositions { gridPos+: { w: 12 } },
          this.grafana.panels.workerExecutorPoolSize { gridPos+: { w: 12 } },
          this.grafana.panels.workerMemoryPool { gridPos+: { w: 12 } },
          this.grafana.panels.workerDataProcessingThroughput { gridPos+: { w: 12 } },
        ],
      ),
    workerJVM:
      g.panel.row.new('JVM')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.workerJVMGarbageCollectorCount { gridPos+: { w: 12 } },
          this.grafana.panels.workerJVMGarbageCollectionDuration { gridPos+: { w: 12 } },
          this.grafana.panels.workerJVMMemoryCommitted { gridPos+: { w: 12 } },
          this.grafana.panels.workerJVMMemoryUsage { gridPos+: { w: 12 } },
        ],
      ),
  },
}
