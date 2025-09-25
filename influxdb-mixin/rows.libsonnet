local g = import './g.libsonnet';

{
  new(this):
    {
      // ---
      // Cluster overview rows
      // ---

      // Cluster overview row
      influxdbClusterOverview:
        g.panel.row.new('InfluxDB cluster overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.alertsPanel { gridPos+: { w: 7 } },
          this.grafana.panels.serversPanel { gridPos+: { w: 17 } },
        ]),

      influxdbClusterOverviewQueriesAndOperations:
        g.panel.row.new('Queries and operations')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.topInstancesByHTTPAPIRequestsPanel { gridPos+: { w: 8 } },
          this.grafana.panels.httpAPIRequestDurationPanel { gridPos+: { w: 8 } },
          this.grafana.panels.httpAPIResponseCodesPanel { gridPos+: { w: 8 } },
          this.grafana.panels.httpQueryOperationsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.httpWriteOperationsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.topInstancesByIQLQueryRatePanel { gridPos+: { w: 8 } },
          this.grafana.panels.iqlQueryResponseTimePanel { gridPos+: { w: 8 } },
          this.grafana.panels.boltdbOperationsPanel { gridPos+: { w: 8 } },
        ]),

      influxdbClusterOverviewTaskScheduler:
        g.panel.row.new('Task scheduler')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.activeTasksPanel { gridPos+: { w: 12 } },
          this.grafana.panels.activeWorkersPanel { gridPos+: { w: 12 } },
          this.grafana.panels.executionTotalsPanel { gridPos+: { w: 12 } },
          this.grafana.panels.scheduleTotalsPanel { gridPos+: { w: 12 } },
        ]),

      influxdbClusterOverviewMemoryAndGC:
        g.panel.row.new('Go')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.topInstancesByHeapMemoryUsagePanel { gridPos+: { w: 12 } },
          this.grafana.panels.topInstancesByGCCPUUsagePanel { gridPos+: { w: 12 } },
        ]),

      // ---
      // Instance Dashboard Rows
      // ---

      influxdbInstanceOverview:
        g.panel.row.new('InfluxDB instance overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.instanceUptimePanel { gridPos+: { h: 8, w: 3 } },
          this.grafana.panels.instanceBucketsPanel { gridPos+: { h: 8, w: 3 } },
          this.grafana.panels.instanceUsersPanel { gridPos+: { h: 8, w: 3 } },
          this.grafana.panels.instanceReplicationsPanel { gridPos+: { h: 8, w: 3 } },
          this.grafana.panels.instanceRemotesPanel { gridPos+: { h: 8, w: 3 } },
          this.grafana.panels.instanceScrapersPanel { gridPos+: { h: 8, w: 3 } },
          this.grafana.panels.instanceDashboardsPanel { gridPos+: { h: 8, w: 3 } },
          this.grafana.panels.instanceThreadsPanel { gridPos+: { h: 8, w: 3 } },
        ]),


      influxdbInstanceOverviewQueriesAndOperations:
        g.panel.row.new('Queries and operations')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.instanceHTTPAPIRequestsPanel { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.instanceActiveQueriesPanel { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.instanceHTTPOperationsPanel { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.instanceHTTPOperationDataPanel { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.instanceIQLRatePanel { gridPos+: { h: 8, w: 8 } },
          this.grafana.panels.instanceIQLResponseTimePanel { gridPos+: { h: 8, w: 8 } },
          this.grafana.panels.instanceBoltDBOperationsPanel { gridPos+: { h: 8, w: 8 } },
        ]),

      influxdbInstanceOverviewTaskScheduler:
        g.panel.row.new('Task scheduler')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.instanceActiveTasksPanel { gridPos+: { h: 8, w: 8 } },
          this.grafana.panels.instanceActiveWorkersPanel { gridPos+: { h: 8, w: 8 } },
          this.grafana.panels.instanceWorkerUsagePanel { gridPos+: { h: 8, w: 8 } },
          this.grafana.panels.instanceExecutionsPanel { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.instanceSchedulesPanel { gridPos+: { h: 8, w: 12 } },
        ]),

      influxdbInstanceOverviewGo:
        g.panel.row.new('Go')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          this.grafana.panels.instanceGoLastGCPanel { gridPos+: { h: 8, w: 6 } },
          this.grafana.panels.instanceGoGCTimePanel { gridPos+: { h: 8, w: 9 } },
          this.grafana.panels.instanceGoGCCPUUsagePanel { gridPos+: { h: 8, w: 9 } },
          this.grafana.panels.instanceGoHeapMemoryUsagePanel { gridPos+: { h: 8, w: 12 } },
          this.grafana.panels.instanceGoThreadsPanel { gridPos+: { h: 8, w: 12 } },
        ]),
    },
}
