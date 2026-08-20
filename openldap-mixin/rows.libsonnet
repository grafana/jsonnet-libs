local g = import './g.libsonnet';

{
  new(this):
    local panels = this.grafana.panels;
    {
      overview:
        g.panel.row.new('Overview')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.uptime { gridPos+: { w: 8, h: 6 } },
          panels.referrals { gridPos+: { w: 8, h: 6 } },
          panels.alerts { gridPos+: { w: 8, h: 6 } },
        ]),

      connections:
        g.panel.row.new('Connections')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.connections { gridPos+: { w: 8, h: 6 } },
          panels.waiters { gridPos+: { w: 8, h: 6 } },
          panels.networkConnectivity { gridPos+: { w: 8, h: 6 } },
        ]),

      operations:
        g.panel.row.new('Operations')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.directoryEntries { gridPos+: { w: 8, h: 6 } },
          panels.pduProcessed { gridPos+: { w: 8, h: 6 } },
          panels.authenticationAttempts { gridPos+: { w: 8, h: 6 } },
          panels.coreOperations { gridPos+: { w: 12, h: 6 } },
          panels.auxiliaryOperations { gridPos+: { w: 12, h: 6 } },
        ]),

      threads:
        g.panel.row.new('Threads')
        + g.panel.row.withCollapsed(false)
        + g.panel.row.withPanels([
          panels.primaryThreadActivity { gridPos+: { w: 12, h: 6 } },
          panels.threadQueueManagement { gridPos+: { w: 12, h: 6 } },
        ]),
    },
}
