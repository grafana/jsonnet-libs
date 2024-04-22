local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this):
    {
      local t = this.grafana.targets,
      local stat = g.panel.stat,
      local table = g.panel.table,
      local barGauge = g.panel.barGauge,

      vmOnStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs on',
          targets=[t.vmOnStatus],
          description=''
        )
        + stat.options.withGraphMode('none'),

      vmOffStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs off',
          targets=[t.vmOffStatus],
          description=''
        )
        + stat.options.withGraphMode('none'),

      vmSuspendedStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs suspended',
          targets=[t.vmSuspendedStatus],
          description=''
        )
        + stat.options.withGraphMode('none'),

      vmTemplateStatus:
        commonlib.panels.generic.stat.info.new(
          'VM templates',
          targets=[t.vmTemplateStatus],
          description=''
        )
        + stat.options.withGraphMode('none'),

      clusterCountStatus:
        commonlib.panels.generic.stat.info.new(
          'Cluster count',
          targets=[t.clusterCountStatus],
          description=''
        )
        + stat.options.withGraphMode('none'),

      resourcePoolCountStatus:
        commonlib.panels.generic.stat.info.new(
          'Resource Pool Count',
          targets=[t.resourcePoolCountStatus],
          description=''
        )
        + stat.options.withGraphMode('none'),

      esxiHostsActiveStatus:
        commonlib.panels.generic.stat.info.new(
          'Active ESXi Hosts',
          targets=[t.esxiHostsActiveStatus],
          description=''
        )
        + stat.options.withGraphMode('none'),

      esxiHostsInactiveStatus:
        commonlib.panels.generic.stat.info.new(
          'Inactive ESXi Hosts',
          targets=[t.esxiHostsInactiveStatus],
          description=''
        )
        + stat.options.withGraphMode('none'),

      topCPUUtilizationClusters:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU Utilization Clusters',
          targets=[t.topCPUUtilizationClusters],
          description=''
        ),

      topMemoryUtilizationClusters:
        commonlib.panels.generic.timeSeries.base.new(
          'Top Memory Utilization Clusters',
          targets=[t.topMemoryUtilizationClusters],
          description=''
        ),

      clustersTable:
        g.panel.table.new(
          'Clusters table',
          targets=[t.clustersTable],
          description=''
        ),

      topCPUUsageResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU usage resource pools',
          targets=[t.topCPUUsageResourcePools],
          description=''
        ),

      topMemoryUsageResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory usage resource pools',
          targets=[t.topMemoryUsageResourcePools],
          description=''
        ),

      topCPUShareResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU share resource pools',
          targets=[t.topCPUShareResourcePools],
          description=''
        ),

      topMemoryShareResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory share resource pools',
          targets=[t.topMemoryShareResourcePools],
          description=''
        ),

      topCPUUtilizationEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU Utilization ESXi Hosts',
          targets=[t.topCPUUtilizationEsxiHosts],
          description=''
        ),

      topMemoryUsageEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory usage ESXi hosts',
          targets=[t.topMemoryUsageEsxiHosts],
          description=''
        ),

      topNetworksActiveEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top networks active ESXi hosts',
          targets=[t.topNetworksActiveEsxiHosts],
          description=''
        ),

      topPacketErrorEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top packet error ESXi hosts',
          targets=[t.topPacketErrorEsxiHosts],
          description=''
        ),

      datastoresTable:
        g.panel.table.new(
          'Datastores table',
          targets=[t.datastoresTable],
          description=''
        ),

      hostCPUUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Host CPU usage',
          targets=[t.hostCPUUsage],
          description=''
        ),

      hostCPUUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Host CPU utilization',
          targets=[t.hostCPUUtilization],
          description=''
        ),

      hostMemoryUsage:
        g.panel.timeSeries.new(
          'Host memory usage',
          targets=[t.hostMemoryUsage],
          description=''
        ),

      hostMemoryUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Host memory utilization',
          targets=[t.hostMemoryUtilization],
          description=''
        ),

      modifiedMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Modified memory',
          targets=[t.modifiedMemory],
          description=''
        ),

      networkThroughputRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Network throughput rate',
          targets=[t.networkThroughputRate],
          description=''
        ),

      packetRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Packet rate',
          targets=[t.packetRate],
          description=''
        ),

      VMTable:
        g.panel.table.new(
          'VMs table',
          targets=[t.VMTable],
          description=''
        ),

      disksTable:
        g.panel.table.new(
          'Disks table',
          targets=[t.disksTable],
          description=''
        ),

      clusterCPUEffective:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster CPU effective',
          targets=[t.clusterCPUEffective],
          description=''
        ),

      clusterCPULimit:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster CPU limit',
          targets=[t.clusterCPULimit],
          description=''
        ),

      clusterCPUUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster CPU utilization',
          targets=[t.clusterCPUUtilization],
          description=''
        ),

      clusterMemoryEffective:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster memory effective',
          targets=[t.clusterMemoryEffective],
          description=''
        ),

      clusterMemoryLimit:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster memory limit',
          targets=[t.clusterMemoryLimit],
          description=''
        ),

      clusterMemoryUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster memory utilization',
          targets=[t.clusterMemoryUtilization],
          description=''
        ),

      esxiHostsTable:
        g.panel.table.new(
          'ESXi hosts table',
          targets=[t.esxiHostsTable],
          description=''
        ),
    },
}
