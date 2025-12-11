local g = import './g.libsonnet';

{
  new(this)::
    {
      local panels = this.grafana.panels,

      // Cluster overview row
      clusterOverviewRow:
        g.panel.row.new('Cluster overview')
        + g.panel.row.withPanels([
          panels.clusterNodeAvailabilityGauge { gridPos: { w: 8 } },
          panels.clusterPoolAvailabilityGauge { gridPos: { w: 8 } },
          panels.clusterVirtualServerAvailabilityGauge { gridPos: { w: 8 } },
          panels.clusterTopActiveServersideNodesBarGauge { gridPos: { w: 12 } },
          panels.clusterTopOutboundTrafficNodesBarGauge { gridPos: { w: 12 } },
          panels.clusterTopActiveMembersInPoolsBarGauge { gridPos: { w: 8 } },
          panels.clusterTopRequestedPoolsBarGauge { gridPos: { w: 8 } },
          panels.clusterTopQueueDepthBarGauge { gridPos: { w: 8 } },
          panels.clusterTopUtilizedVirtualServersBarGauge { gridPos: { w: 12 } },
          panels.clusterTopLatencyVirtualServersBarGauge { gridPos: { w: 12 } },
        ]),

      // Node overview row
      nodeOverviewRow:
        g.panel.row.new('Node overview')
        + g.panel.row.withPanels([
          panels.nodeAvailabilityStatusTable { gridPos: { w: 24 } },
          panels.nodeRequestsTimeSeries { gridPos: { w: 12 } },
          panels.nodeActiveSessionsTimeSeries { gridPos: { w: 12 } },
          panels.nodeConnectionsTimeSeries { gridPos: { w: 24 } },
          panels.nodeTrafficInboundTimeSeries { gridPos: { w: 12 } },
          panels.nodeTrafficOutboundTimeSeries { gridPos: { w: 12 } },
          panels.nodePacketsInboundTimeSeries { gridPos: { w: 12 } },
          panels.nodePacketsOutboundTimeSeries { gridPos: { w: 12 } },
        ]),

      // Pool overview row
      poolOverviewRow:
        g.panel.row.new('Pool overview')
        + g.panel.row.withPanels([
          panels.poolAvailabilityStatusTable { gridPos: { w: 24 } },
          panels.poolRequestsTimeSeries { gridPos: { w: 12 } },
          panels.poolMembersTimeSeries { gridPos: { w: 12 } },
          panels.poolConnectionsTimeSeries { gridPos: { w: 12 } },
          panels.poolConnectionQueueDepthTimeSeries { gridPos: { w: 12 } },
          panels.poolConnectionQueueServicedTimeSeries { gridPos: { w: 24 } },
          panels.poolTrafficInboundTimeSeries { gridPos: { w: 12 } },
          panels.poolTrafficOutboundTimeSeries { gridPos: { w: 12 } },
          panels.poolPacketsInboundTimeSeries { gridPos: { w: 12 } },
          panels.poolPacketsOutboundTimeSeries { gridPos: { w: 12 } },
        ]),

      // Virtual Server overview row
      virtualServerOverviewRow:
        g.panel.row.new('Virtual server overview')
        + g.panel.row.withPanels([
          panels.virtualServerAvailabilityStatusTable { gridPos: { w: 24 } },
          panels.virtualServerRequestsTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerAvgConnectionDurationTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerConnectionsTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerEphemeralConnectionsTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerTrafficInboundTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerTrafficOutboundTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerEphemeralTrafficInboundTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerEphemeralTrafficOutboundTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerPacketsInboundTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerPacketsOutboundTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerEphemeralPacketsInboundTimeSeries { gridPos: { w: 12 } },
          panels.virtualServerEphemeralPacketsOutboundTimeSeries { gridPos: { w: 12 } },
        ]),
    },
}
