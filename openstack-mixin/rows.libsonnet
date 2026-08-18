local g = import './g.libsonnet';

{
  new(this): {
    local panels = this.grafana.panels,

    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.placementStatus { gridPos+: { w: 4, h: 8 } },
        panels.keystoneStatus { gridPos+: { w: 4, h: 8 } },
        panels.novaStatus { gridPos+: { w: 4, h: 8 } },
        panels.neutronStatus { gridPos+: { w: 4, h: 8 } },
        panels.cinderStatus { gridPos+: { w: 4, h: 8 } },
        panels.glanceStatus { gridPos+: { w: 4, h: 8 } },
        panels.alertsPanel { gridPos+: { w: 8, h: 8 } },
        panels.totalResources { gridPos+: { w: 16, h: 8 } },
        panels.vCPUUsedStat { gridPos+: { w: 4, h: 5 } },
        panels.RAMUsedStat { gridPos+: { w: 4, h: 5 } },
        panels.freeIPsStat { gridPos+: { w: 16, h: 5 } },
      ]),

    keystone:
      g.panel.row.new('Keystone service')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.domains { gridPos+: { w: 4, h: 8 } },
        panels.projects { gridPos+: { w: 4, h: 8 } },
        panels.regions { gridPos+: { w: 4, h: 8 } },
        panels.users { gridPos+: { w: 12, h: 8 } },
        panels.projectDetails { gridPos+: { w: 24, h: 8 } },
      ]),

    glance:
      g.panel.row.new('Glance service')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.glanceStatus { gridPos+: { w: 6, h: 8 } },
        panels.imageCount { gridPos+: { w: 18, h: 8 } },
        panels.images { gridPos+: { w: 24, h: 8 } },
      ]),

    nova:
      g.panel.row.new('Nova service')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.novaStatus { gridPos+: { w: 6, h: 8 } },
        panels.vms { gridPos+: { w: 18, h: 8 } },
        panels.instanceUsage { gridPos+: { w: 12, h: 8 } },
        panels.vCPUUsage { gridPos+: { w: 12, h: 8 } },
        panels.memoryUsage { gridPos+: { w: 12, h: 8 } },
        panels.novaAgents { gridPos+: { w: 12, h: 8 } },
      ]),

    neutron:
      g.panel.row.new('Neutron service')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.neutronStatus { gridPos+: { w: 6, h: 8 } },
        panels.networks { gridPos+: { w: 9, h: 8 } },
        panels.subnets { gridPos+: { w: 9, h: 8 } },
        panels.routers { gridPos+: { w: 12, h: 8 } },
        panels.routerDetails { gridPos+: { w: 12, h: 8 } },
        panels.ports { gridPos+: { w: 8, h: 8 } },
        panels.portDetails { gridPos+: { w: 16, h: 8 } },
        panels.floatingIPs { gridPos+: { w: 12, h: 8 } },
        panels.ipsUsed { gridPos+: { w: 12, h: 8 } },
        panels.securityGroups { gridPos+: { w: 12, h: 8 } },
        panels.neutronAgents { gridPos+: { w: 12, h: 8 } },
      ]),

    cinder:
      g.panel.row.new('Cinder service')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.cinderStatus { gridPos+: { w: 4, h: 8 } },
        panels.volumes { gridPos+: { w: 10, h: 8 } },
        panels.volumeStatus { gridPos+: { w: 10, h: 8 } },
        panels.volumeUsage { gridPos+: { w: 12, h: 8 } },
        panels.backupUsage { gridPos+: { w: 12, h: 8 } },
        panels.poolUsage { gridPos+: { w: 12, h: 8 } },
        panels.snapshots { gridPos+: { w: 12, h: 8 } },
        panels.cinderAgents { gridPos+: { w: 24, h: 8 } },
      ]),
  },
}
