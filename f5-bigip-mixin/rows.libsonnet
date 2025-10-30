local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    //
    // Cluster Overview Rows
    //
    clusterOverviewRow:
      g.panel.row.new('Overview')
      + g.panel.row.withPanels([
        panels.nodeAvailability { gridPos: { h: 5, w: 8, x: 0, y: 0 } },
        panels.poolAvailability { gridPos: { h: 5, w: 8, x: 8, y: 0 } },
        panels.virtualServerAvailability { gridPos: { h: 5, w: 8, x: 16, y: 0 } },
        panels.topActiveServersideNodes { gridPos: { h: 5, w: 12, x: 0, y: 5 } },
        panels.topOutboundTrafficNodes { gridPos: { h: 5, w: 12, x: 12, y: 5 } },
        panels.topActiveMembersInPools { gridPos: { h: 5, w: 8, x: 0, y: 10 } },
        panels.topRequestedPools { gridPos: { h: 5, w: 8, x: 8, y: 10 } },
        panels.topQueueDepthPools { gridPos: { h: 5, w: 8, x: 16, y: 10 } },
        panels.topUtilizedVirtualServers { gridPos: { h: 5, w: 12, x: 0, y: 15 } },
        panels.topLatencyVirtualServers { gridPos: { h: 5, w: 12, x: 12, y: 15 } },
      ]),

    //
    // Node Overview Rows
    //
    nodeStatusRow:
      g.panel.row.new('Status')
      + g.panel.row.withPanels([
        panels.nodeAvailabilityStatus { gridPos: { h: 9, w: 24, x: 0, y: 0 } },
      ]),

    nodeMetricsRow:
      g.panel.row.new('Metrics')
      + g.panel.row.withPanels([
        panels.nodeCurrentSessions { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.nodeRequests { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.nodeServersideBytesIn { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.nodeServersideBytesOut { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
        panels.nodeServersideCurrentConnections { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
        panels.nodeServersideMaxConnections { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
      ]),

    //
    // Pool Overview Rows
    //
    poolStatusRow:
      g.panel.row.new('Status')
      + g.panel.row.withPanels([
        panels.poolAvailabilityStatus { gridPos: { h: 9, w: 24, x: 0, y: 0 } },
      ]),

    poolMetricsRow:
      g.panel.row.new('Metrics')
      + g.panel.row.withPanels([
        panels.poolActiveMemberCount { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.poolConnectionQueueDepth { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.poolRequests { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.poolServersideBytesIn { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
        panels.poolServersideBytesOut { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
        panels.poolServersideCurrentConnections { gridPos: { h: 8, w: 12, x: 12, y: 16 } },
      ]),

    //
    // Virtual Server Overview Rows
    //
    virtualServerStatusRow:
      g.panel.row.new('Status')
      + g.panel.row.withPanels([
        panels.virtualServerAvailabilityStatus { gridPos: { h: 9, w: 24, x: 0, y: 0 } },
      ]),

    virtualServerClientsideMetricsRow:
      g.panel.row.new('Clientside Metrics')
      + g.panel.row.withPanels([
        panels.virtualServerClientsideCurrentConnections { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.virtualServerRequests { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.virtualServerClientsideBytesIn { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.virtualServerClientsideBytesOut { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
        panels.virtualServerMeanConnectionDuration { gridPos: { h: 8, w: 12, x: 0, y: 16 } },
      ]),

    virtualServerEphemeralMetricsRow:
      g.panel.row.new('Ephemeral Metrics')
      + g.panel.row.withPanels([
        panels.virtualServerEphemeralCurrentConnections { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.virtualServerEphemeralBytesIn { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.virtualServerEphemeralBytesOut { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
      ]),
  },
}
