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
      local fieldOverride = g.panel.table.fieldOverride,

      vmOnStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs on',
          targets=[t.vmOnStatus],
          description='The number of virtual machines currently powered on.'
        )
        + stat.options.withGraphMode('none'),

      vmOffStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs off',
          targets=[t.vmOffStatus],
          description='The number of virtual machines currently powered off.'
        )
        + stat.options.withGraphMode('none'),

      vmSuspendedStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs suspended',
          targets=[t.vmSuspendedStatus],
          description='The number of virtual machines currently in a suspended state.'
        )
        + stat.options.withGraphMode('none'),

      vmTemplateStatus:
        commonlib.panels.generic.stat.info.new(
          'VM templates',
          targets=[t.vmTemplateStatus],
          description='The number of virtual machine templates available.'
        )
        + stat.options.withGraphMode('none'),
      vmOnStatusCluster:
        commonlib.panels.generic.stat.info.new(
          'VMs on',
          targets=[t.vmOnStatusCluster],
          description='The number of virtual machines currently powered on within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      vmOffStatusCluster:
        commonlib.panels.generic.stat.info.new(
          'VMs off',
          targets=[t.vmOffStatusCluster],
          description='The number of virtual machines currently powered off within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      vmSuspendedStatusCluster:
        commonlib.panels.generic.stat.info.new(
          'VMs suspended',
          targets=[t.vmSuspendedStatusCluster],
          description='The number of virtual machines currently in a suspended state within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      vmTemplateStatusCluster:
        commonlib.panels.generic.stat.info.new(
          'VM templates',
          targets=[t.vmTemplateStatusCluster],
          description='The number of virtual machine templates available within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      clusterCountStatus:
        commonlib.panels.generic.stat.info.new(
          'Cluster count',
          targets=[t.clusterCountStatus],
          description='The total number of clusters in the vCenter environment.'
        )
        + stat.options.withGraphMode('none'),

      resourcePoolCountStatus:
        commonlib.panels.generic.stat.info.new(
          'Resource pool count',
          targets=[t.resourcePoolCountStatus],
          description='The total number of resource pools in the vCenter environment.'
        )
        + stat.options.withGraphMode('none'),

      esxiHostsActiveStatus:
        commonlib.panels.generic.stat.info.new(
          'Active ESXi hosts',
          targets=[t.esxiHostsActiveStatus],
          description='The number of ESXi hosts that are currently in an active state.'
        )
        + stat.options.withGraphMode('none'),

      esxiHostsInactiveStatus:
        commonlib.panels.generic.stat.info.new(
          'Inactive ESXi hosts',
          targets=[t.esxiHostsInactiveStatus],
          description='The number of ESXi hosts that are currently in an inactive state.'
        )
        + stat.options.withGraphMode('none'),

      esxiHostsActiveStatusCluster:
        commonlib.panels.generic.stat.info.new(
          'Active ESXi hosts',
          targets=[t.esxiHostsActiveStatusCluster],
          description='The number of ESXi hosts that are currently in an active state within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      esxiHostsInactiveStatusCluster:
        commonlib.panels.generic.stat.info.new(
          'Inactive ESXi hosts',
          targets=[t.esxiHostsInactiveStatusCluster],
          description='The number of ESXi hosts that are currently in an inactive state within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      topCPUUtilizationClusters:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU utilization by cluster',
          targets=[t.topCPUUtilizationClusters],
          description='The clusters with the highest CPU utilization percentage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentutil'),

      topMemoryUtilizationClusters:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory utilization by cluster',
          targets=[t.topMemoryUtilizationClusters],
          description='The clusters with the highest memory utilization percentage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percentutil'),

      clustersTable:
        commonlib.panels.generic.table.base.new(
          'Cluster summary',
          targets=[
            t.topMemoryUtilizationClusters + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.topCPUUtilizationClusters + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmNumberTotal + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='A table displaying information about the clusters in the vCenter environment.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percentunit')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        +
        table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percentunit')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vcenter_cluster_name',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'vcenter_cluster_name',
                  'Value #A',
                  'Value #B',
                  'Value #C',
                ],
              },
            },
          },
          {
            id: 'organize',
            options: {
              excludeByName: {},
              includeByName: {},
              indexByName: {},
              renameByName: {
                'Value #A': 'CPU utilization',
                'Value #B': 'Memory utilization',
                'Value #C': 'Number of VMs',
                'vcenter_cluster_name 1': 'Cluster',
              },
            },
          },
        ]),

      topCPUUsageResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU usage resource pools',
          targets=[t.topCPUUsageResourcePools],
          description='The resource pools with the highest CPU usage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topMemoryUsageResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory usage resource pools',
          targets=[t.topMemoryUsageResourcePools],
          description='The resource pools with the highest memory usage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('mbytes'),

      topCPUShareResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU share resource pools',
          targets=[t.topCPUShareResourcePools],
          description='The resource pools with the highest amount of CPU shares allocated.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('shares'),

      topMemoryShareResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory share resource pools',
          targets=[t.topMemoryShareResourcePools],
          description='The resource pools with the highest amount of memory shares allocated.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('shares'),

      topCPUUtilizationEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU utilization ESXi hosts',
          targets=[t.topCPUUtilizationEsxiHosts],
          description='The ESXi hosts with the highest CPU utilization percentage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topMemoryUsageEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory usage ESXi hosts',
          targets=[t.topMemoryUsageEsxiHosts],
          description='The ESXi hosts with the highest memory usage.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topNetworksActiveEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top networks active ESXi hosts',
          targets=[t.topNetworksActiveEsxiHosts],
          description='The ESXi hosts with the highest network throughput.'
        ),

      topPacketErrorEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top packet error ESXi hosts',
          targets=[t.topPacketErrorEsxiHosts],
          description='The ESXi hosts with the highest number of packet errors.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('err'),

      hostCPUUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Host CPU usage',
          targets=[t.hostCPUUsage],
          description='The amount of CPU used by the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      hostCPUUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Host CPU utilization',
          targets=[t.hostCPUUtilization],
          description='The CPU utilization percentage of the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      hostMemoryUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Host memory usage',
          targets=[t.hostMemoryUsage],
          description='The amount of memory used by the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      hostMemoryUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Host memory utilization',
          targets=[t.hostMemoryUtilization],
          description='The memory utilization percentage of the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      modifiedMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Modified memory',
          targets=[t.modifiedMemoryBallooned, t.modifiedMemorySwapped],
          description='The amount of memory that has been modified or ballooned on the ESXi host.'
        ) + g.panel.timeSeries.standardOptions.withUnit('mbytes'),

      networkThroughputRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Network throughput rate',
          targets=[t.networkTransmittedThroughputRate, t.networkReceivedThroughputRate],
          description='The rate of data transmitted or received over the network of the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KiBs'),

      packetRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Packet rate',
          targets=[t.packetReceivedRate, t.packetTransmittedRate],
          description='The rate of packets received or transmitted over the ESXi hosts networks.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('packet/s'),

      VMTableCluster:
        commonlib.panels.generic.table.base.new(
          'VMs table',
          targets=[
            t.vmCPUUtilizationCluster + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmMemoryUtilizationCluster + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmModifiedMemoryBalloonedCluster + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmModifiedMemorySwappedCluster + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmNetDiskThroughputCluster + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='A table displaying information about the virtual machines in the vCenter environment.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withProperty('custom.minWidth', 250)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percentunit')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withProperty('custom.minWidth', 250)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percentunit')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory ballooned')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory swapped')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk throughput')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vcenter_host_name',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'vcenter_host_name',
                  'Value #A',
                  'Value #D',
                  'Value #E',
                  'Value #F',
                  'Value #B',
                  'vcenter_vm_name 1',
                ],
              },
            },
          },
          {
            id: 'organize',
            options: {
              excludeByName: {},
              includeByName: {},
              indexByName: {
                'Value #A': 2,
                'Value #B': 6,
                'Value #D': 3,
                'Value #E': 4,
                'Value #F': 5,
                vcenter_host_name: 0,
                'vcenter_vm_name 1': 1,
              },
              renameByName: {
                'Value #A': 'CPU utilization',
                'Value #B': 'Disk throughput',
                'Value #C': '',
                'Value #D': 'Memory utilization',
                'Value #E': 'Memory ballooned',
                'Value #F': 'Memory swapped',
                vcenter_cluster_name: 'Cluster',
                'vcenter_cluster_name 1': 'Cluster',
                vcenter_host_name: 'Host',
                'vcenter_host_name 1': 'Host',
                vcenter_vm_name: 'Name',
                'vcenter_vm_name 1': 'Name',
                'vcenter_vm_name 2': '',
              },
            },
          },
        ]),

      disksTable:
        commonlib.panels.generic.table.base.new(
          'Disks table',
          targets=[
            t.hostDiskLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.diskThroughputRate + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='A table displaying information about the disks associated with the virtual machines.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory swapped')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk throughput')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vcenter_host_name',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'vcenter_host_name',
                  'Value #A',
                  'Value #B',
                ],
              },
            },
          },
          {
            id: 'organize',
            options: {
              excludeByName: {},
              includeByName: {},
              indexByName: {
                'Value #A': 2,
                'Value #B': 6,
                'Value #D': 3,
                'Value #E': 4,
                'Value #F': 5,
                vcenter_host_name: 0,
                'vcenter_vm_name 1': 1,
              },
              renameByName: {
                'Value #A': 'Latency',
                'Value #B': 'Throughput',
                vcenter_host_name: 'Host',
              },
            },
          },
        ]),

      vmCPUUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'CPU usage',
          targets=[t.vmCPUUsage],
          description='The amount of CPU used by the VMs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('rotmhz'),

      vmCPUUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Host CPU utilization',
          targets=[t.vmCPUUtilization],
          description='The CPU utilization percentage of VMs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      vmMemoryUsage:
        g.panel.timeSeries.new(
          'Memory usage',
          targets=[t.vmMemoryUsage],
          description='The amount of memory used by the VMs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      vmMemoryUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory utilization',
          targets=[t.vmMemoryUtilization],
          description='The memory utilization percentage of the VMs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      vmModifiedMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Modified memory',
          targets=[t.vmModifiedMemory],
          description='The amount of memory that has been modified or ballooned on the VMs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('mbytes'),

      vmNetworkThroughputRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Network throughput rate',
          targets=[t.vmNetworkReceivedThroughputRate, t.vmNetworkTransmittedThroughputRate],
          description='The rate of data transmitted or received over the network of the VMs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KiBs'),

      vmPacketRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Packet rate',
          targets=[t.vmPacketReceivedRate, t.vmPacketTransmittedRate],
          description='The rate of packets received or transmitted over the VMs network.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('packet/s'),

      vmDisksTable:
        commonlib.panels.generic.table.base.new(
          'Disks table',
          targets=[
            t.vmDiskUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmDiskLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmNetDiskThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmDiskUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='A table displaying information about the disks associated with the virtual machines.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Latency')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('ms')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Throughput')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Usage')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('decbytes')
          ),
        ])
        +
        table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percentunit')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vcenter_host_name',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'vcenter_host_name',
                  'vcenter_vm_name 1',
                  'Value #C',
                  'disk_type',
                  'Value #A',
                  'Value #B',
                  'Value #D',
                ],
              },
            },
          },
          {
            id: 'organize',
            options: {
              excludeByName: {},
              includeByName: {},
              indexByName: {
                'Value #A': 3,
                'Value #B': 6,
                'Value #C': 4,
                'Value #D': 5,
                disk_type: 2,
                vcenter_host_name: 0,
                'vcenter_vm_name 1': 1,
              },
              renameByName: {
                'Value #A': 'Latency',
                'Value #B': 'Throughput',
                'Value #C': 'Utilization',
                'Value #D': 'Usage',
                disk_type: 'Type',
                vcenter_host_name: 'Host',
                'vcenter_vm_name 1': 'VM name',
              },
            },
          },
        ]),

      VMTableHost:
        commonlib.panels.generic.table.base.new(
          'VMs table',
          targets=[
            t.vmCPUUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmMemoryUtilization,
            t.vmModifiedMemoryBallooned + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmModifiedMemorySwapped + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.vmNetDiskThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='A table displaying information about the virtual machines in the vCenter environment.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withProperty('custom.minWidth', 250)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percentunit')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withProperty('custom.minWidth', 250)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percentunit')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory ballooned')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory swapped')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk throughput')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vcenter_host_name',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'Value #A',
                  'Value #B',
                  'Value #D',
                  'Value #E',
                  'vcenter_host_name',
                ],
              },
            },
          },
          {
            id: 'organize',
            options: {
              excludeByName: {},
              includeByName: {},
              indexByName: {
                'Value #A': 1,
                'Value #B': 2,
                'Value #D': 3,
                'Value #E': 4,
                vcenter_host_name: 0,
              },
              renameByName: {
                'Value #A': 'CPU utilization',
                'Value #B': 'Memory utilization',
                'Value #C': 'Memory ballooned',
                'Value #D': 'Memory swapped',
                'Value #E': 'Network throughput',
                'Value #F': 'Packet error',
                'Value #G': 'CPU usage',
                'Value #H': 'Memory usage',
                vcenter_cluster_name: 'Cluster',
                'vcenter_cluster_name 1': 'Cluster',
                vcenter_host_name: 'Host',
                'vcenter_host_name 1': 'Host',
              },
            },
          },
        ]),

      clusterCPUEffective:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster CPU effective',
          targets=[t.clusterCPUEffective],
          description='The effective CPU capacity of the cluster, excluding hosts in maintenance mode or unresponsive hosts.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('rotmhz')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      clusterCPULimit:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster CPU limit',
          targets=[t.clusterCPULimit],
          description='The available CPU capacity of the cluster, aggregated from all hosts.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('rotmhz')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      clusterCPUUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster CPU utilization',
          targets=[t.clusterCPUUtilization],
          description='The CPU utilization percentage of the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      clusterMemoryEffective:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster memory effective',
          targets=[t.clusterMemoryEffective],
          description='The effective memory capacity of the cluster, excluding hosts in maintenance mode or unresponsive hosts.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      clusterMemoryLimit:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster memory limit',
          targets=[t.clusterMemoryLimit],
          description='The available memory capacity of the cluster, aggregated from all hosts.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      clusterMemoryUtilization:
        commonlib.panels.generic.timeSeries.base.new(
          'Cluster memory utilization',
          targets=[t.clusterMemoryUtilization],
          description='The memory utilization percentage of the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('decbytes')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      esxiHostsTable:
        commonlib.panels.generic.table.base.new(
          'ESXi hosts table',
          targets=[t.hostCPUUtilization + g.query.prometheus.withFormat('table')
                   + g.query.prometheus.withRange(true)
                   , t.hostMemoryUtilization + g.query.prometheus.withFormat('table')
                     + g.query.prometheus.withRange(true)
                   , t.networkThroughputRate + g.query.prometheus.withFormat('table')
                     + g.query.prometheus.withRange(true)
                   , t.modifiedMemoryBallooned + g.query.prometheus.withFormat('table')
                     + g.query.prometheus.withRange(true)
                   , t.modifiedMemorySwapped + g.query.prometheus.withFormat('table')
                     + g.query.prometheus.withRange(true)]
          ,
          description='A table displaying information about the ESXi hosts in the vCenter environment.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withProperty('custom.minWidth', 250)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Network throughput')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory swapped')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory ballooned')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU usage')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('rotmhz')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory usage')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        +
        table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withProperty('custom.minWidth', 250)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withDecimals(1)
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vcenter_host_name',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'Value #A',
                  'Value #B',
                  'Value #C',
                  'Value #D',
                  'Value #E',
                  'vcenter_host_name 1',
                ],
              },
            },
          },
          {
            id: 'organize',
            options: {
              excludeByName: {},
              includeByName: {},
              indexByName: {
                'Value #A': 1,
                'Value #B': 2,
                'Value #C': 3,
                'Value #D': 4,
                'Value #E': 5,
                'vcenter_host_name 1': 0,
              },
              renameByName: {
                'Value #A': 'CPU utilization',
                'Value #B': 'Memory utilization',
                'Value #C': 'Memory ballooned',
                'Value #D': 'Memory swapped',
                'Value #E': 'Network throughput',
                'Value #F': 'Packet error',
                'Value #G': 'CPU usage',
                'Value #H': 'Memory usage',
                vcenter_cluster_name: 'Cluster',
                'vcenter_cluster_name 1': 'Cluster',
                vcenter_host_name: 'Host',
                'vcenter_host_name 1': 'Host',
              },
            },
          },
        ]),
    },
}
