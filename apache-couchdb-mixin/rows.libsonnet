local g = import './g.libsonnet';

{
  new(this): {
    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.overviewNumberOfClustersPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.overviewNumberOfNodesPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.overviewClusterHealthPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.overviewOpenOSFilesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewOpenDatabasesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewDatabaseWritesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewDatabaseReadsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewViewReadsPanel { gridPos+: { w: 8 } },
          this.grafana.panels.overviewViewTimeoutsPanel { gridPos+: { w: 8 } },
          this.grafana.panels.overviewTemporaryViewReadsPanel { gridPos+: { w: 8 } },
        ],
      ),

    overviewRequests:
      g.panel.row.new('Requests')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.overviewRequestMethodsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewRequestLatencyPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewBulkRequestsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewResponseStatusOverviewPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewGoodResponseStatusesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewErrorResponseStatusesPanel { gridPos+: { w: 12 } },
        ],
      ),

    overviewReplication:
      g.panel.row.new('Replication')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.overviewReplicatorChangesManagerDeathsPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.overviewReplicatorChangesQueueDeathsPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.overviewReplicatorChangesReaderDeathsPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.overviewReplicatorConnectionOwnerCrashesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewReplicatorConnectionWorkerCrashesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewReplicatorJobsCrashesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.overviewReplicatorJobsQueuedPanel { gridPos+: { w: 12 } },
        ],
      ),

    nodes:
      g.panel.row.new('Nodes')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.nodeErlangMemoryUsagePanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.nodeOpenOSFilesPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.nodeOpenDatabasesPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.nodeDatabaseWritesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.nodeDatabaseReadsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.nodeViewReadsPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.nodeViewTimeoutsPanel { gridPos+: { h: 6, w: 8 } },
          this.grafana.panels.nodeTemporaryViewReadsPanel { gridPos+: { h: 6, w: 8 } },
        ],
      ),

    nodeRequests:
      g.panel.row.new('Requests')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.nodeBulkRequestsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.nodeAverageRequestLatencyPanel { gridPos+: { w: 12 } },
          this.grafana.panels.nodeRequestMethodsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.nodeResponseStatusOverviewPanel { gridPos+: { w: 12 } },
          this.grafana.panels.nodeGoodResponseStatusesPanel { gridPos+: { w: 12 } },
          this.grafana.panels.nodeErrorResponseStatusesPanel { gridPos+: { w: 12 } },
        ],
      ),

    nodeLogs:
      g.panel.row.new('Logs')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels(
        [
          this.grafana.panels.nodeLogTypesPanel { gridPos+: { w: 24 } },
        ],
      ),
  },


}
