local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    clientRow:
      g.panel.row.new('Client')
      + g.panel.row.withPanels([
        panels.clientRequests { gridPos: { w: 16 } },
        panels.clientRequestErrors { gridPos: { w: 8 } },
        panels.clientCacheHitRatio { gridPos: { w: 8 } },
        panels.clientRequestSentThroughput { gridPos: { w: 8 } },
        panels.clientHTTPReceivedThroughput { gridPos: { w: 8 } },
        panels.clientCacheHitThroughput { gridPos: { w: 8 } },
        panels.httpRequestServiceTime { gridPos: { w: 16 } },
        panels.cacheHitServiceTime { gridPos: { w: 16 } },
        panels.cacheMissesServiceTime { gridPos: { w: 8 } },
      ]),

    serverRow:
      g.panel.row.new('Server')
      + g.panel.row.withPanels([
        panels.serverRequests { gridPos: { w: 16 } },
        panels.serverRequestErrors { gridPos: { w: 8 } },
        panels.serverRequestSentThroughput { gridPos: { w: 8 } },
        panels.serverObjectSwap { gridPos: { w: 8 } },
        panels.dnsLookupServiceTime { gridPos: { w: 8 } },
        panels.serverReceivedThroughput { gridPos: { w: 24 } },
      ]),
  },
}
