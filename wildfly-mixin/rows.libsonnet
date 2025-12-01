local g = import './g.libsonnet';

{
  new(this): {
    requestsRow:
      g.panel.row.new('Requests')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.requestsPanel { gridPos+: { w: 12 } },
        this.grafana.panels.requestErrorsPanel { gridPos+: { w: 12 } },
      ]),
    networkRow:
      g.panel.row.new('Network')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.networkReceivedThroughputPanel { gridPos+: { w: 12 } },
        this.grafana.panels.networkSentThroughputPanel { gridPos+: { w: 12 } },
      ]),
    connectionsRow:
      g.panel.row.new('Connections')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.connectionsActivePanel { gridPos+: { w: 12 } },
        this.grafana.panels.connectionsIdlePanel { gridPos+: { w: 12 } },
      ]),
    transactionsRow:
      g.panel.row.new('Transactions')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.transactionsCreatedPanel { gridPos+: { w: 12 } },
        this.grafana.panels.transactionsInFlightPanel { gridPos+: { w: 12 } },
        this.grafana.panels.transactionsAbortedPanel { gridPos+: { w: 24 } },
      ]),
    sessionsRow:
      g.panel.row.new('Sessions')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        this.grafana.panels.sessionsActivePanel { gridPos+: { w: 24 } },
        this.grafana.panels.sessionsExpiredPanel { gridPos+: { w: 12 } },
        this.grafana.panels.sessionsRejectedPanel { gridPos+: { w: 12 } },
      ]),
  },
}
