local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    // ── cluster overview ──────────────────────────────────────────────────
    clusterOverviewStatus:
      g.panel.row.new('Status')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.liveNodes { gridPos+: { w: 6, h: 6 } },
        panels.zookeeperStatus { gridPos+: { w: 6, h: 6 } },
        panels.zookeeperEnsembleSize { gridPos+: { w: 6, h: 6 } },
        panels.alerts { gridPos+: { w: 6, h: 6 } },
        panels.shardState { gridPos+: { w: 4, h: 6 } },
        panels.shardStatus { gridPos+: { w: 8, h: 6 } },
        panels.replicaState { gridPos+: { w: 4, h: 6 } },
        panels.replicaStatus { gridPos+: { w: 8, h: 6 } },
      ]),

    clusterOverviewTopMetrics:
      g.panel.row.new('Top metrics')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.topCPULoadByNode { gridPos+: { w: 12, h: 6 } },
        panels.topHeapMemoryUsageByNode { gridPos+: { w: 12, h: 6 } },
        panels.topMeanQueriesByNode { gridPos+: { w: 12, h: 6 } },
        panels.topUpdateHandlersByNode { gridPos+: { w: 12, h: 6 } },
        panels.topIndexSizeByNode { gridPos+: { w: 12, h: 6 } },
        panels.topCacheHitRatioByNode { gridPos+: { w: 12, h: 6 } },
      ]),

    clusterOverviewErrors:
      g.panel.row.new('Errors')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.topCoreErrorsByNode { gridPos+: { w: 12, h: 6 } },
        panels.topNodeErrors { gridPos+: { w: 12, h: 6 } },
      ]),

    // ── query performance ─────────────────────────────────────────────────
    queryPerformanceQueryLoad:
      g.panel.row.new('Query load')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.updateHandlers { gridPos+: { w: 24, h: 6 } },
        panels.coreSearchAndRetrievalQueryLoad { gridPos+: { w: 12, h: 6 } },
        panels.specializedQueryLoad { gridPos+: { w: 12, h: 6 } },
        panels.coreSearchAndRetrieval95pQueryLatency { gridPos+: { w: 12, h: 6 } },
        panels.specialized95pQueryLatency { gridPos+: { w: 12, h: 6 } },
        panels.coreSearchAndRetrieval99pQueryLatency { gridPos+: { w: 12, h: 6 } },
        panels.specialized99pQueryLatency { gridPos+: { w: 12, h: 6 } },
      ]),

    queryPerformanceLocalQueries:
      g.panel.row.new('Local queries')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.coreSearchAndRetrievalLocalQueryLoad { gridPos+: { w: 12, h: 6 } },
        panels.specializedLocalQueryLoad { gridPos+: { w: 12, h: 6 } },
        panels.coreSearchAndRetrievalLocal95pQueryLatency { gridPos+: { w: 12, h: 6 } },
        panels.specializedLocal95pQueryLatency { gridPos+: { w: 12, h: 6 } },
        panels.coreSearchAndRetrievalLocal99pQueryLatency { gridPos+: { w: 12, h: 6 } },
        panels.specializedLocal99pQueryLatency { gridPos+: { w: 12, h: 6 } },
      ]),

    queryPerformanceCacheMetrics:
      g.panel.row.new('Cache metrics')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.cacheEvictions { gridPos+: { w: 12, h: 6 } },
        panels.cacheHitRatio { gridPos+: { w: 12, h: 6 } },
      ]),

    queryPerformanceTimeouts:
      g.panel.row.new('Timeouts')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.coreTimeouts { gridPos+: { w: 12, h: 6 } },
        panels.nodeTimeouts { gridPos+: { w: 12, h: 6 } },
      ]),

    queryPerformanceErrors:
      g.panel.row.new('Errors')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.queryErrorRate { gridPos+: { w: 12, h: 6 } },
        panels.queryClientErrors { gridPos+: { w: 12, h: 6 } },
      ]),

    // ── resource monitoring ───────────────────────────────────────────────
    resourceMonitoringOverview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.connections { gridPos+: { w: 12, h: 6 } },
        panels.threads { gridPos+: { w: 12, h: 6 } },
        panels.nodeCoreFSUsage { gridPos+: { w: 12, h: 6 } },
        panels.numberOfFileDescriptors { gridPos+: { w: 12, h: 6 } },
      ]),

    resourceMonitoringJVM:
      g.panel.row.new('JVM metrics')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.garbageCollections { gridPos+: { w: 12, h: 6 } },
        panels.garbageCollectionTime { gridPos+: { w: 12, h: 6 } },
        panels.cpuAverageLoad { gridPos+: { w: 12, h: 6 } },
        panels.osMemory { gridPos+: { w: 12, h: 6 } },
        panels.memoryUsed { gridPos+: { w: 12, h: 6 } },
        panels.memoryCommitted { gridPos+: { w: 12, h: 6 } },
      ]),

    resourceMonitoringJetty:
      g.panel.row.new('Jetty metrics')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.requests { gridPos+: { w: 12, h: 6 } },
        panels.responses { gridPos+: { w: 12, h: 6 } },
        panels.dispatches { gridPos+: { w: 24, h: 6 } },
      ]),
  },
}
