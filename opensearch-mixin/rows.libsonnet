local g = import './g.libsonnet';

{
  new(this): {
    clusterOverviewRow:
      g.panel.row.new('Cluster overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterStatusPanel { gridPos+: { w: 5, h: 6 } },
        this.grafana.panels.nodeCountPanel { gridPos+: { w: 5, h: 6 } },
        this.grafana.panels.dataNodeCountPanel { gridPos+: { w: 5, h: 6 } },
        this.grafana.panels.shardCountPanel { gridPos+: { w: 5, h: 6 } },
        this.grafana.panels.activeShardsPercentagePanel { gridPos+: { w: 4, h: 6 } },
      ]),

    clusterRolesRow:
      g.panel.row.new('Node roles')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterOSRoles { gridPos+: { w: 24 } },
        this.grafana.panels.clusterOSRolesTimeline { gridPos+: { w: 24 } },
      ]),

    resourceUsageRow:
      g.panel.row.new('Resource usage')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.topNodesByCPUUsagePanel { gridPos+: { w: 8 } },
        this.grafana.panels.breakersTrippedPanel { gridPos+: { w: 8 } },
        this.grafana.panels.shardStatusPanel { gridPos+: { w: 8 } },
      ]),

    storageAndTasksRow:
      g.panel.row.new('Storage and tasks')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.topNodesByDiskUsagePanel { gridPos+: { w: 8 } },
        this.grafana.panels.totalDocumentsPanel { gridPos+: { w: 16 } },
        this.grafana.panels.pendingTasksPanel { gridPos+: { w: 8 } },
        this.grafana.panels.storeSizePanel { gridPos+: { w: 8 } },
        this.grafana.panels.maxTaskWaitTimePanel { gridPos+: { w: 8 } },
      ]),

    searchPerformanceRow:
      g.panel.row.new('Search performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.topIndicesByRequestRatePanel { gridPos+: { w: 8 } },
        this.grafana.panels.topIndicesByRequestLatencyPanel { gridPos+: { w: 8 } },
        this.grafana.panels.topIndicesByCombinedCacheHitRatioPanel { gridPos+: { w: 8 } },
      ]),

    ingestPerformanceRow:
      g.panel.row.new('Ingest performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.topNodesByIngestRatePanel { gridPos+: { w: 8 } },
        this.grafana.panels.topNodesByIngestLatencyPanel { gridPos+: { w: 8 } },
        this.grafana.panels.topNodesByIngestErrorsPanel { gridPos+: { w: 8 } },
      ]),

    indexingPerformanceRow:
      g.panel.row.new('Indexing performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.topIndicesByIndexRatePanel { gridPos+: { w: 8 } },
        this.grafana.panels.topIndicesByIndexLatencyPanel { gridPos+: { w: 8 } },
        this.grafana.panels.topIndicesByIndexFailuresPanel { gridPos+: { w: 8 } },
      ]),

    // Node Overview Dashboard Rows
    nodeRolesRow:
      g.panel.row.new('Node Roles')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.nodeOSRolesTimeline { gridPos+: { w: 24 } },
      ]),

    nodeHealthRow:
      g.panel.row.new('Node health')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.nodeCpuUsage { gridPos+: { w: 6 } },
        this.grafana.panels.nodeMemoryUsage { gridPos+: { w: 6 } },
        this.grafana.panels.nodeIO { gridPos+: { w: 6 } },
        this.grafana.panels.nodeOpenConnections { gridPos+: { w: 6 } },
        this.grafana.panels.nodeDiskUsage { gridPos+: { w: 6 } },
        this.grafana.panels.nodeMemorySwap { gridPos+: { w: 6 } },
        this.grafana.panels.nodeNetworkTraffic { gridPos+: { w: 6 } },
        this.grafana.panels.circuitBreakers { gridPos+: { w: 6 } },
      ]),

    nodeJVMRow:
      g.panel.row.new('Node JVM')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.jvmHeapUsedVsCommitted { gridPos+: { w: 6 } },
        this.grafana.panels.jvmNonheapUsedVsCommitted { gridPos+: { w: 6 } },
        this.grafana.panels.jvmThreads { gridPos+: { w: 6 } },
        this.grafana.panels.jvmBufferPools { gridPos+: { w: 6 } },
        this.grafana.panels.jvmUptime { gridPos+: { w: 6 } },
        this.grafana.panels.jvmGarbageCollections { gridPos+: { w: 6 } },
        this.grafana.panels.jvmGarbageCollectionTime { gridPos+: { w: 6 } },
        this.grafana.panels.jvmBufferPoolUsage { gridPos+: { w: 6 } },
      ]),

    threadPoolsRow:
      g.panel.row.new('Thread pools')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.threadPoolThreads { gridPos+: { w: 12 } },
        this.grafana.panels.threadPoolTasks { gridPos+: { w: 12 } },
      ]),


    // Search and Index Overview Dashboard Rows
    searchAndIndexRequestPerformanceRow:
      g.panel.row.new('Request performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.searchRequestRatePanel { gridPos+: { w: 6 } },
        this.grafana.panels.searchRequestLatencyPanel { gridPos+: { w: 6 } },
        this.grafana.panels.searchCacheHitRatioPanel { gridPos+: { w: 6 } },
        this.grafana.panels.searchCacheEvictionsPanel { gridPos+: { w: 6 } },
      ]),

    searchAndIndexIndexingPerformanceRow:
      g.panel.row.new('Indexing performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.indexingRatePanel { gridPos+: { w: 6 } },
        this.grafana.panels.indexingLatencyPanel { gridPos+: { w: 6 } },
        this.grafana.panels.indexingFailuresPanel { gridPos+: { w: 6 } },
        this.grafana.panels.flushLatencyPanel { gridPos+: { w: 6 } },
        this.grafana.panels.mergeTimePanel { gridPos+: { w: 6 } },
        this.grafana.panels.refreshLatencyPanel { gridPos+: { w: 6 } },
        this.grafana.panels.translogOperationsPanel { gridPos+: { w: 6 } },
        this.grafana.panels.docsDeletedPanel { gridPos+: { w: 6 } },
      ]),

    searchAndIndexCapacityRow:
      g.panel.row.new('Index capacity')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.documentsIndexedPanel { gridPos+: { w: 6 } },
        this.grafana.panels.segmentCountPanel { gridPos+: { w: 6 } },
        this.grafana.panels.mergeCountPanel { gridPos+: { w: 6 } },
        this.grafana.panels.cacheSizePanel { gridPos+: { w: 6 } },
        this.grafana.panels.searchAndIndexStoreSizePanel { gridPos+: { w: 6 } },
        this.grafana.panels.segmentSizePanel { gridPos+: { w: 6 } },
        this.grafana.panels.mergeSizePanel { gridPos+: { w: 6 } },
        this.grafana.panels.searchAndIndexShardCountPanel { gridPos+: { w: 6 } },
      ]),
  },
}
