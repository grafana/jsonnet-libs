local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    clientRow:
      g.panel.row.new('Client')
      + g.panel.row.withPanels([
        panels.clientRequests { gridPos: { h: 8, w: 8, x: 0, y: 1 } },
        panels.clientRequestErrors { gridPos: { h: 8, w: 8, x: 8, y: 1 } },
        panels.clientCacheHitRatio { gridPos: { h: 8, w: 8, x: 16, y: 1 } },
        panels.clientRequestSentThroughput { gridPos: { h: 7, w: 8, x: 0, y: 9 } },
        panels.clientHTTPReceivedThroughput { gridPos: { h: 7, w: 8, x: 8, y: 9 } },
        panels.clientCacheHitThroughput { gridPos: { h: 7, w: 8, x: 16, y: 9 } },
        panels.httpRequestServiceTime { gridPos: { h: 7, w: 8, x: 0, y: 16 } },
        panels.cacheHitServiceTime { gridPos: { h: 7, w: 8, x: 8, y: 16 } },
        panels.cacheMissesServiceTime { gridPos: { h: 7, w: 8, x: 16, y: 16 } },
      ]),

    serverRow:
      g.panel.row.new('Server')
      + g.panel.row.withPanels([
        panels.serverRequests { gridPos: { h: 8, w: 8, x: 0, y: 24 } },
        panels.serverRequestErrors { gridPos: { h: 8, w: 8, x: 8, y: 24 } },
        panels.serverRequestSentThroughput { gridPos: { h: 8, w: 8, x: 16, y: 24 } },
        panels.serverObjectSwap { gridPos: { h: 8, w: 8, x: 0, y: 32 } },
        panels.dnsLookupServiceTime { gridPos: { h: 8, w: 8, x: 8, y: 32 } },
        panels.serverReceivedThroughput { gridPos: { h: 8, w: 8, x: 16, y: 32 } },
      ]),

    logsRow:
      g.panel.row.new('Logs')
      + g.panel.row.withPanels([
        panels.cacheLogs { gridPos: { h: 6, w: 24, x: 0, y: 40 } },
        panels.accessLogs { gridPos: { h: 6, w: 24, x: 0, y: 46 } },
      ]),
  },
}
