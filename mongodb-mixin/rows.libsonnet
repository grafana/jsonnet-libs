local g = import './g.libsonnet';

{
  new(this): {
    // Overview dashboard rows
    overviewHealth:
      g.panel.row.new('Health')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.overviewTotalInstances { gridPos+: { w: 4, h: 6 } },
        this.grafana.panels.overviewInstancesUp { gridPos+: { w: 4, h: 6 } },
        this.grafana.panels.overviewInstancesDown { gridPos+: { w: 4, h: 6 } },
        this.grafana.panels.overviewTotalConnections { gridPos+: { w: 4, h: 6 } },
        this.grafana.panels.overviewTotalOps { gridPos+: { w: 4, h: 6 } },
        this.grafana.panels.overviewMaxReplicationLag { gridPos+: { w: 4, h: 6 } },
        this.grafana.panels.overviewInstanceStates { gridPos+: { w: 24, h: 6 } },
      ]),

    overviewPerformance:
      g.panel.row.new('Performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.overviewConnectionsByInstance { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.overviewOpsByInstance { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.overviewReplicationLagByInstance { gridPos+: { w: 24, h: 8 } },
      ]),

    // Instance dashboard rows
    instanceOverview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.instanceUptime { gridPos+: { w: 6, h: 6 } },
        this.grafana.panels.instanceQps { gridPos+: { w: 6, h: 6 } },
        this.grafana.panels.instanceReplicaSetState { gridPos+: { w: 6, h: 6 } },
        this.grafana.panels.instanceLatency { gridPos+: { w: 6, h: 6 } },
      ]),

    instanceServiceSummary:
      g.panel.row.new('Service summary')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.instanceCommandOps { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.instanceConnections { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.instanceDocumentOps { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.instanceLatencyDetail { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.instanceQueuedOps { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.instanceCursors { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.instanceScannedAndMoved { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.instanceGetLastErrorWriteOps { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.instanceGetLastErrorWriteTime { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.instanceAsserts { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.instanceQueryEfficiency { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.instancePageFaults { gridPos+: { w: 8, h: 8 } },
      ]),

    // ReplicaSet dashboard rows
    replicasetOverview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.replicasetMembers { gridPos+: { w: 8, h: 6 } },
        this.grafana.panels.replicasetLastElection { gridPos+: { w: 8, h: 6 } },
        this.grafana.panels.replicasetAvgLag { gridPos+: { w: 8, h: 6 } },
        this.grafana.panels.replicasetVersions { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.replicasetStates { gridPos+: { w: 12, h: 8 } },
      ]),

    replicasetPerformance:
      g.panel.row.new('Performance')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.replicasetReplicationLag { gridPos+: { w: 24, h: 8 } },
        this.grafana.panels.replicasetOperations { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.replicasetElections { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.replicasetHeartbeatTime { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.replicasetMemberPing { gridPos+: { w: 12, h: 8 } },
      ]),

    replicasetOplogDetails:
      g.panel.row.new('Oplog details')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.replicasetOplogBufferedOps { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.replicasetOplogGetmoreTime { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.replicasetOplogRecoveryWindow { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.replicasetOplogProcessingTime { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.replicasetOplogOperations { gridPos+: { w: 8, h: 8 } },
      ]),

    // Cluster dashboard rows
    clusterOverview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterShardsTotal { gridPos+: { w: 3, h: 6 } },
        this.grafana.panels.clusterShardedDbs { gridPos+: { w: 3, h: 6 } },
        this.grafana.panels.clusterUnshardedDbs { gridPos+: { w: 3, h: 6 } },
        this.grafana.panels.clusterDrainingShards { gridPos+: { w: 3, h: 6 } },
        this.grafana.panels.clusterShardedCollections { gridPos+: { w: 3, h: 6 } },
        this.grafana.panels.clusterChunksTotal { gridPos+: { w: 3, h: 6 } },
        this.grafana.panels.clusterBalancerEnabled { gridPos+: { w: 3, h: 6 } },
        this.grafana.panels.clusterChunksBalanced { gridPos+: { w: 3, h: 6 } },
        this.grafana.panels.clusterCollectionsInShardsTable { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterCollectionSizeInShardsTable { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterShardServicesQps { gridPos+: { w: 24, h: 8 } },
        this.grafana.panels.clusterConfigServicesQps { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterMongosServicesQps { gridPos+: { w: 12, h: 8 } },
      ]),

    clusterChunks:
      g.panel.row.new('Chunks in shards')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterChunksInShardsTable { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterChunksDynamic { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterChunkSplitEvents { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterChunkMoveEvents { gridPos+: { w: 12, h: 8 } },
      ]),

    clusterIndexes:
      g.panel.row.new('Indexes in shards')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterIndexesPerShardTable { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterIndexesDynamic { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterIndexSizePerShardTable { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterIndexSizeDynamic { gridPos+: { w: 12, h: 8 } },
      ]),

    clusterConnections:
      g.panel.row.new('Connections')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterConnectionsCurrent { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.clusterConnectionsAvailable { gridPos+: { w: 8, h: 8 } },
        this.grafana.panels.clusterConnectionsPerShard { gridPos+: { w: 8, h: 8 } },
      ]),

    clusterOperations:
      g.panel.row.new('Operations')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterOpsPerShard { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterOpsByType { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterOpsByServiceName { gridPos+: { w: 24, h: 8 } },
      ]),

    clusterCursors:
      g.panel.row.new('Cursors')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterCursorsPerShard { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterCursorsTotal { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterCursorsByInstance { gridPos+: { w: 24, h: 8 } },
      ]),

    clusterAdditionalInfo:
      g.panel.row.new('Additional info')
      + g.panel.row.withCollapsed(true)
      + g.panel.row.withPanels([
        this.grafana.panels.clusterReplicationLagBySet { gridPos+: { w: 12, h: 8 } },
        this.grafana.panels.clusterOplogRangeBySet { gridPos+: { w: 12, h: 8 } },
      ]),
  },
}
