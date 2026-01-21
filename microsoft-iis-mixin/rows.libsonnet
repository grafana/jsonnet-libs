local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    // Overview dashboard rows
    overviewRequests:
      g.panel.row.new('Requests and errors')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.requests { gridPos+: { w: 12 } },
        panels.requestErrors { gridPos+: { w: 12 } },
      ]),

    overviewAsyncIO:
      g.panel.row.new('Async I/O')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.blockedAsyncIORequests { gridPos+: { w: 12 } },
        panels.rejectedAsyncIORequests { gridPos+: { w: 12 } },
      ]),

    overviewTraffic:
      g.panel.row.new('Traffic')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.trafficSent { gridPos+: { w: 12 } },
        panels.trafficReceived { gridPos+: { w: 12 } },
        panels.filesSent { gridPos+: { w: 12 } },
        panels.filesReceived { gridPos+: { w: 12 } },
      ]),

    overviewConnections:
      g.panel.row.new('Connections')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.currentConnections { gridPos+: { w: 12 } },
        panels.attemptedConnections { gridPos+: { w: 12 } },
      ]),

    overviewCache:
      g.panel.row.new('Cache')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.fileCacheHitRatio { gridPos+: { w: 12 } },
        panels.uriCacheHitRatio { gridPos+: { w: 12 } },
        panels.metadataCacheHitRatio { gridPos+: { w: 12 } },
        panels.outputCacheHitRatio { gridPos+: { w: 12 } },
      ]),

    // Applications dashboard rows
    applicationsRequests:
      g.panel.row.new('Requests')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.workerRequests { gridPos+: { w: 12 } },
        panels.workerRequestErrors { gridPos+: { w: 12 } },
      ]),

    applicationsWebsocket:
      g.panel.row.new('Websocket')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.websocketConnectionAttempts { gridPos+: { w: 12 } },
        panels.websocketConnectionSuccessRate { gridPos+: { w: 12 } },
        panels.currentWorkerThreads { gridPos+: { w: 12 } },
        panels.workerThreadPoolUtilization { gridPos+: { w: 12 } },
      ]),

    applicationsWorkerProcesses:
      g.panel.row.new('Worker processes')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.currentWorkerProcesses { gridPos+: { w: 12 } },
        panels.workerProcessFailures { gridPos+: { w: 12 } },
        panels.workerProcessStartupFailures { gridPos+: { w: 8 } },
        panels.workerProcessShutdownFailures { gridPos+: { w: 8 } },
        panels.workerProcessPingFailures { gridPos+: { w: 8 } },
      ]),

    applicationsCache:
      g.panel.row.new('Cache')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.workerFileCacheHitRatio { gridPos+: { w: 12 } },
        panels.workerUriCacheHitRatio { gridPos+: { w: 12 } },
        panels.workerMetadataCacheHitRatio { gridPos+: { w: 12 } },
        panels.workerOutputCacheHitRatio { gridPos+: { w: 12 } },
      ]),
  },
}
