local g = import './g.libsonnet';
{
  new(this):
    {
      local panels = this.grafana.panels,

      overview:
        g.panel.row.new('Overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.proxies { gridPos+: { w: 4, h: 4 } },
          panels.gateways { gridPos+: { w: 4, h: 4 } },
          panels.virtualServices { gridPos+: { w: 4, h: 4 } },
          panels.alertsPanel { gridPos+: { w: 12, h: 8 } },
          panels.destinationRules { gridPos+: { w: 4, h: 4 } },
          panels.serviceEntries { gridPos+: { w: 4, h: 4 } },
          panels.workloadEntries { gridPos+: { w: 4, h: 4 } },
          panels.openFileDescriptors { gridPos+: { w: 12, h: 6 } },
          panels.vCPUUsage { gridPos+: { w: 12, h: 6 } },
          panels.heapMemory { gridPos+: { w: 12, h: 6 } },
          panels.virtualAndResidentMemory { gridPos+: { w: 12, h: 6 } },
          panels.httpGRPCRequests { gridPos+: { w: 16, h: 6 } },
          panels.httpResponseOverview { gridPos+: { w: 8, h: 6 } },
        ]),

      controlPlane:
        g.panel.row.new('Control plane')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.xDSPushes { gridPos+: { w: 8, h: 6 } },
          panels.xDSPushDelay { gridPos+: { w: 8, h: 6 } },
          panels.galleyValidations { gridPos+: { w: 8, h: 6 } },
          panels.xDSEnvoyThroughput { gridPos+: { w: 8, h: 6 } },
          panels.xDSErrors { gridPos+: { w: 8, h: 6 } },
          panels.sidecarInjections { gridPos+: { w: 8, h: 6 } },
        ]),

      services:
        g.panel.row.new('Services')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.services { gridPos+: { w: 24, h: 8 } },
        ]),

      clientServiceDetails:
        g.panel.row.new('Client details')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.clientServiceHTTPGRPCRequests { gridPos+: { w: 12, h: 6 } },
          panels.clientServiceHTTPGRPCRequestDelay { gridPos+: { w: 12, h: 6 } },
          panels.clientServiceHTTPGRPCRequestThroughput { gridPos+: { w: 12, h: 6 } },
          panels.clientServiceHTTPGRPCResponseThroughput { gridPos+: { w: 12, h: 6 } },
          panels.clientServiceHTTPResponseOverview { gridPos+: { w: 8, h: 6 } },
          panels.clientServiceHTTPResponses { gridPos+: { w: 16, h: 6 } },
          panels.clientServiceGRPCResponseOverview { gridPos+: { w: 8, h: 6 } },
          panels.clientServiceGRPCResponses { gridPos+: { w: 16, h: 6 } },
          panels.clientServiceTCPRequestThroughput { gridPos+: { w: 12, h: 6 } },
          panels.clientServiceTCPResponseThroughput { gridPos+: { w: 12, h: 6 } },
        ]),

      serverServiceDetails:
        g.panel.row.new('Server details')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.serverServiceHTTPGRPCRequests { gridPos+: { w: 12, h: 6 } },
          panels.serverServiceHTTPGRPCRequestDelay { gridPos+: { w: 12, h: 6 } },
          panels.serverServiceHTTPGRPCRequestThroughput { gridPos+: { w: 12, h: 6 } },
          panels.serverServiceHTTPGRPCResponseThroughput { gridPos+: { w: 12, h: 6 } },
          panels.serverServiceHTTPResponseOverview { gridPos+: { w: 8, h: 6 } },
          panels.serverServiceHTTPResponses { gridPos+: { w: 16, h: 6 } },
          panels.serverServiceGRPCResponseOverview { gridPos+: { w: 8, h: 6 } },
          panels.serverServiceGRPCResponses { gridPos+: { w: 16, h: 6 } },
          panels.serverServiceTCPRequestThroughput { gridPos+: { w: 12, h: 6 } },
          panels.serverServiceTCPResponseThroughput { gridPos+: { w: 12, h: 6 } },
        ]),

      serviceWorkloads:
        g.panel.row.new('Workloads')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.workloads { gridPos+: { w: 24, h: 8 } },
        ]),

      clientWorkloadDetails:
        g.panel.row.new('Client details')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.clientWorkloadHTTPGRPCRequests { gridPos+: { w: 12, h: 6 } },
          panels.clientWorkloadHTTPGRPCRequestDelay { gridPos+: { w: 12, h: 6 } },
          panels.clientWorkloadHTTPGRPCRequestThroughput { gridPos+: { w: 12, h: 6 } },
          panels.clientWorkloadHTTPGRPCResponseThroughput { gridPos+: { w: 12, h: 6 } },
          panels.clientWorkloadHTTPResponseOverview { gridPos+: { w: 8, h: 6 } },
          panels.clientWorkloadHTTPResponses { gridPos+: { w: 16, h: 6 } },
          panels.clientWorkloadGRPCResponseOverview { gridPos+: { w: 8, h: 6 } },
          panels.clientWorkloadGRPCResponses { gridPos+: { w: 16, h: 6 } },
          panels.clientWorkloadTCPRequestThroughput { gridPos+: { w: 12, h: 6 } },
          panels.clientWorkloadTCPResponseThroughput { gridPos+: { w: 12, h: 6 } },
        ]),

      serverWorkloadDetails:
        g.panel.row.new('Server details')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.serverWorkloadHTTPGRPCRequests { gridPos+: { w: 12, h: 6 } },
          panels.serverWorkloadHTTPGRPCRequestDelay { gridPos+: { w: 12, h: 6 } },
          panels.serverWorkloadHTTPGRPCRequestThroughput { gridPos+: { w: 12, h: 6 } },
          panels.serverWorkloadHTTPGRPCResponseThroughput { gridPos+: { w: 12, h: 6 } },
          panels.serverWorkloadHTTPResponseOverview { gridPos+: { w: 8, h: 6 } },
          panels.serverWorkloadHTTPResponses { gridPos+: { w: 16, h: 6 } },
          panels.serverWorkloadGRPCResponseOverview { gridPos+: { w: 8, h: 6 } },
          panels.serverWorkloadGRPCResponses { gridPos+: { w: 16, h: 6 } },
          panels.serverWorkloadTCPRequestThroughput { gridPos+: { w: 12, h: 6 } },
          panels.serverWorkloadTCPResponseThroughput { gridPos+: { w: 12, h: 6 } },
        ]),
    },
}
