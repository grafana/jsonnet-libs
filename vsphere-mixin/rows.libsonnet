local g = import './g.libsonnet';

// All panel layout lives here: every panel belongs to a row and carries an
// explicit width and height, so dashboards.libsonnet only has to assemble rows.
{
  new(this): {
    local panels = this.grafana.panels,

    overview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.clustersCountStatus { gridPos+: { w: 6, h: 4 } },
        panels.hostsCountStatus { gridPos+: { w: 6, h: 4 } },
        panels.resourcePoolsCountStatus { gridPos+: { w: 6, h: 4 } },
        panels.vmsCountStatus { gridPos+: { w: 6, h: 4 } },
        panels.clusteredVMsOnStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusteredVMsOffStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusteredVMsSuspendedStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusteredVMTemplatesCountStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusteredHostsActiveStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusteredHostsInactiveStatus { gridPos+: { w: 4, h: 4 } },
      ]),

    clusters:
      g.panel.row.new('Clusters')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.topCPUUtilizationClusters { gridPos+: { w: 12, h: 6 } },
        panels.topMemoryUtilizationClusters { gridPos+: { w: 12, h: 6 } },
        panels.clustersTable { gridPos+: { w: 24, h: 6 } },
      ]),

    resourcePools:
      g.panel.row.new('Resource pools')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.topCPUUsageResourcePools { gridPos+: { w: 12, h: 8 } },
        panels.topMemoryUsageResourcePools { gridPos+: { w: 12, h: 8 } },
        panels.topCPUShareResourcePools { gridPos+: { w: 12, h: 8 } },
        panels.topMemoryShareResourcePools { gridPos+: { w: 12, h: 8 } },
      ]),

    overviewHosts:
      g.panel.row.new('ESXi hosts')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.topCPUUtilizationHosts { gridPos+: { w: 12, h: 8 } },
        panels.topMemoryUtilizationHosts { gridPos+: { w: 12, h: 8 } },
        panels.topDiskAvgLatencyHosts { gridPos+: { w: 12, h: 8 } },
        panels.topPacketErrorRateHosts { gridPos+: { w: 12, h: 8 } },
      ]),

    datastores:
      g.panel.row.new('Datastores')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.datastoreTable { gridPos+: { w: 24, h: 6 } },
      ]),

    clusterOverview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.clusterVMsOnStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusterVMsOffStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusterVMsSuspendedStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusterHostsActiveStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusterHostsInactiveStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusterResourcePoolsStatus { gridPos+: { w: 4, h: 4 } },
        panels.clusterCPULimit { gridPos+: { w: 8, h: 6 } },
        panels.clusterCPUEffective { gridPos+: { w: 8, h: 6 } },
        panels.clusterCPUUtilization { gridPos+: { w: 8, h: 6 } },
        panels.clusterMemoryLimit { gridPos+: { w: 8, h: 6 } },
        panels.clusterMemoryEffective { gridPos+: { w: 8, h: 6 } },
        panels.clusterMemoryUtilization { gridPos+: { w: 8, h: 6 } },
      ]),

    clusterHosts:
      g.panel.row.new('ESXi hosts')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.clusterHostsTable { gridPos+: { w: 24, h: 6 } },
      ]),

    clusterVMs:
      g.panel.row.new('VMs')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.clusterVMsTable { gridPos+: { w: 24, h: 6 } },
      ]),

    hostOverview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.hostCPUUsage { gridPos+: { w: 12, h: 6 } },
        panels.hostCPUUtilization { gridPos+: { w: 12, h: 6 } },
        panels.hostMemoryUsage { gridPos+: { w: 12, h: 6 } },
        panels.hostMemoryUtilization { gridPos+: { w: 12, h: 6 } },
        panels.hostModifiedMemory { gridPos+: { w: 24, h: 6 } },
        panels.hostNetworkThroughputRate { gridPos+: { w: 12, h: 6 } },
        panels.hostPacketErrorRate { gridPos+: { w: 12, h: 6 } },
      ]),

    hostVMs:
      g.panel.row.new('VMs')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.hostVMsTable { gridPos+: { w: 24, h: 6 } },
      ]),

    hostDisks:
      g.panel.row.new('Disks')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.hostDisksTable { gridPos+: { w: 24, h: 6 } },
      ]),

    virtualMachineOverview:
      g.panel.row.new('Overview')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.vmCPUUsage { gridPos+: { w: 12, h: 6 } },
        panels.vmCPUUtilization { gridPos+: { w: 12, h: 6 } },
        panels.vmMemoryUsage { gridPos+: { w: 12, h: 6 } },
        panels.vmMemoryUtilization { gridPos+: { w: 12, h: 6 } },
        panels.vmModifiedMemory { gridPos+: { w: 24, h: 6 } },
        panels.vmNetworkThroughputRate { gridPos+: { w: 12, h: 6 } },
        panels.vmPacketDropRate { gridPos+: { w: 12, h: 6 } },
      ]),

    virtualMachineDisks:
      g.panel.row.new('Disks')
      + g.panel.row.withCollapsed(false)
      + g.panel.row.withPanels([
        panels.vmDiskUsage { gridPos+: { w: 12, h: 6 } },
        panels.vmDiskUtilization { gridPos+: { w: 12, h: 6 } },
        panels.vmDisksTable { gridPos+: { w: 24, h: 6 } },
      ]),
  },
}
