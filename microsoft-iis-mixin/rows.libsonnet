local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    // Overview dashboard rows
    overviewRequests:
      g.panel.row.new('Requests and Errors')
      + g.panel.row.withPanels([
        panels.requests { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.requestErrors { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
      ]),

    overviewAsyncIO:
      g.panel.row.new('Async I/O')
      + g.panel.row.withPanels([
        panels.blockedAsyncIORequests { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.rejectedAsyncIORequests { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
      ]),

    overviewTraffic:
      g.panel.row.new('Traffic')
      + g.panel.row.withPanels([
        panels.trafficSent { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.trafficReceived { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.filesSent { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.filesReceived { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    overviewConnections:
      g.panel.row.new('Connections')
      + g.panel.row.withPanels([
        panels.currentConnections { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.attemptedConnections { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
      ]),

    overviewLogs:
      g.panel.row.new('Logs')
      + g.panel.row.withPanels([
        panels.accessLogs { gridPos: { h: 10, w: 24, x: 0, y: 0 } },
      ]),

    overviewCache:
      g.panel.row.new('Cache')
      + g.panel.row.withPanels([
        panels.fileCacheHitRatio { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.uriCacheHitRatio { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.metadataCacheHitRatio { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.outputCacheHitRatio { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),

    // Applications dashboard rows
    applicationsRequests:
      g.panel.row.new('Requests')
      + g.panel.row.withPanels([
        panels.workerRequests { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.workerRequestErrors { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
      ]),

    applicationsWebsocket:
      g.panel.row.new('Websocket')
      + g.panel.row.withPanels([
        panels.websocketConnectionAttempts { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.websocketConnectionSuccessRate { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
      ]),

    applicationsWorkerProcesses:
      g.panel.row.new('Worker Processes')
      + g.panel.row.withPanels([
        panels.currentWorkerThreads { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.currentWorkerProcesses { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.workerProcessFailures { gridPos: { h: 8, w: 24, x: 0, y: 8 } },
      ]),

    applicationsCache:
      g.panel.row.new('Cache')
      + g.panel.row.withPanels([
        panels.workerFileCacheHitRatio { gridPos: { h: 8, w: 12, x: 0, y: 0 } },
        panels.workerUriCacheHitRatio { gridPos: { h: 8, w: 12, x: 12, y: 0 } },
        panels.workerMetadataCacheHitRatio { gridPos: { h: 8, w: 12, x: 0, y: 8 } },
        panels.workerOutputCacheHitRatio { gridPos: { h: 8, w: 12, x: 12, y: 8 } },
      ]),
  },
}
