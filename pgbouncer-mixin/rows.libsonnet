local g = import './g.libsonnet';

// All panel positioning lives here: every panel belongs to a row and carries an
// explicit gridPos w/h, so dashboards.libsonnet only assembles dashboards.
{
  new(this): {
    local panels = this.grafana.panels,

    // Overview dashboard rows
    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.clientsWaitingConnections { gridPos+: { w: 4, h: 4 } },
        panels.activeClientConnections { gridPos+: { w: 4, h: 4 } },
        panels.activeServerConnections { gridPos+: { w: 4, h: 4 } },
        panels.maxDatabaseConnections { gridPos+: { w: 4, h: 4 } },
        panels.maxUserConnections { gridPos+: { w: 4, h: 4 } },
        panels.maxClientConnections { gridPos+: { w: 4, h: 4 } },
      ]),

    queries:
      g.panel.row.new('Queries')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.queriesPooled { gridPos+: { w: 12, h: 6 } },
        panels.queryDuration { gridPos+: { w: 12, h: 6 } },
      ]),

    network:
      g.panel.row.new('Network')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.networkTraffic { gridPos+: { w: 24, h: 6 } },
      ]),

    transactions:
      g.panel.row.new('Transactions')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.transactionRate { gridPos+: { w: 12, h: 6 } },
        panels.transactionAverageDuration { gridPos+: { w: 12, h: 6 } },
      ]),

    server:
      g.panel.row.new('Server')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.serverConnections { gridPos+: { w: 24, h: 6 } },
      ]),

    client:
      g.panel.row.new('Client')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.granularActiveClientConnections { gridPos+: { w: 8, h: 6 } },
        panels.clientsWaiting { gridPos+: { w: 8, h: 6 } },
        panels.maxClientWaitTime { gridPos+: { w: 8, h: 6 } },
      ]),

    // Cluster overview dashboard rows
    clusterOverview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.topDatabaseActiveConnection { gridPos+: { w: 12, h: 6 } },
        panels.alertsPanel { gridPos+: { w: 12, h: 6 } },
        panels.topDatabaseQueryPooled { gridPos+: { w: 12, h: 6 } },
        panels.topDatabaseQueryDuration { gridPos+: { w: 12, h: 6 } },
        panels.topDatabaseNetworkTraffic { gridPos+: { w: 24, h: 6 } },
      ]),
  },
}
