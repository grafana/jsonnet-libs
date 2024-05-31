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

      topCPUUtilizationClusters:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Top CPU utilization by cluster',
          targets=[t.topCPUUtilizationClusters],
          description='The clusters with the highest CPU utilization percentage.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topMemoryUtilizationClusters:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Top memory utilization by cluster',
          targets=[t.topMemoryUtilizationClusters],
          description='The clusters with the highest memory utilization percentage.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

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
          description='Information about the clusters in the vCenter environment.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Number of VMs')
          + fieldOverride.byName.withProperty('custom.align', 'left'),
        ])
        +
        table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
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
                  'vcenter_datacenter_name 1',
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
                'Value #B': 3,
                'Value #C': 4,
                vcenter_cluster_name: 1,
                'vcenter_datacenter_name 1': 0,
              },
              renameByName: {
                'Value #A': 'CPU utilization',
                'Value #B': 'Memory utilization',
                'Value #C': 'Number of VMs',
                vcenter_cluster_name: 'Cluster',
                'vcenter_cluster_name 1': 'Cluster',
                'vcenter_datacenter_name 1': 'Datacenter',
              },
            },
          },
        ]),

      datastoreTable:
        commonlib.panels.generic.table.base.new(
          'Datastores summary',
          targets=[
            t.datastoreDiskUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.datastoreDiskUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the clusters in the vCenter environment.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('decbytes')
          ),
        ])
        +
        table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vcenter_datastore_name',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'vcenter_datastore_name',
                  'Value #A',
                  'Value #B',
                  'disk_state',
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
                'Value #B': 3,
                disk_state: 1,
                vcenter_datastore_name: 0,
              },
              renameByName: {
                'Value #A': 'Memory usage',
                'Value #B': 'Memory utilization',
                disk_state: 'State',
                'disk_state 1': 'State',
                'disk_state 2': '',
                'vcenter_cluster_name 1': 'Cluster',
                vcenter_datastore_name: 'Datastore',
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
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('rotmhz'),

      topMemoryUsageResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory usage resource pools',
          targets=[t.topMemoryUsageResourcePools],
          description='The resource pools with the highest memory usage.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('mbytes'),

      topCPUShareResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU share resource pools',
          targets=[t.topCPUShareResourcePools],
          description='The resource pools with the highest amount of CPU shares allocated.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('shares'),

      topMemoryShareResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory share resource pools',
          targets=[t.topMemoryShareResourcePools],
          description='The resource pools with the highest amount of memory shares allocated.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('shares'),

      topCPUUtilizationEsxiHosts:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Top CPU utilization ESXi hosts',
          targets=[t.topCPUUtilizationEsxiHosts],
          description='The ESXi hosts with the highest CPU utilization percentage.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topMemoryUtilizationEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory usage ESXi hosts',
          targets=[t.topMemoryUtilizationEsxiHosts],
          description='The ESXi hosts with the highest memory utilization.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topNetworksActiveEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top networks active ESXi hosts',
          targets=[t.topNetworksActiveEsxiHosts],
          description='The ESXi hosts with the highest network throughput.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
      ,

      topPacketErrorEsxiHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top packet error ESXi hosts / $__interval',
          targets=[t.topPacketErrorEsxiHosts],
          description='The ESXi hosts with the highest number of packet errors.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('err'),

      hostCPUUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'CPU usage',
          targets=[t.hostCPUUsage],
          description='The amount of CPU used by the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('rotmhz')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      hostCPUUtilization:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'CPU utilization',
          targets=[t.hostCPUUtilization],
          description='The CPU utilization percentage of the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      hostMemoryUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory usage',
          targets=[t.hostMemoryUsage],
          description='The amount of memory used by the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('mbytes')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      hostMemoryUtilization:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Memory utilization',
          targets=[t.hostMemoryUtilization],
          description='The memory utilization percentage of the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      hostModifiedMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Modified memory',
          targets=[t.hostModifiedMemoryBallooned, t.hostModifiedMemorySwapped],
          description='The amount of memory that has been swapped or ballooned on the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('mbytes')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      hostNetworkThroughputRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Avg network throughput rate',
          targets=[t.hostNetworkTransmittedThroughputRate, t.hostNetworkReceivedThroughputRate],
          description='The 20s average rate of data transmitted or received over the network of the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KiBs')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      hostPacketErrorRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Avg packet errors',
          targets=[t.hostPacketReceivedErrorRate, t.hostPacketTransmittedErrorRate],
          description='The 20s average of received or transmitted packets dropped over the ESXi hosts network compared to the overall packets received or transmitted.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      hostVMsTable:
        commonlib.panels.generic.table.base.new(
          'VMs table',
          targets=[
            t.hostVMCPUUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMCPUUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMMemoryUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMMemoryUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMDiskUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMDiskUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMNetworkThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMPacketDropRate + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the VMs associated with the ESXi hosts.'
        )
        + table.standardOptions.withNoValue('NA')
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('VM')
          + table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/vsphere-virtual-machines?var-datasource=${datasource}&${__all_variables}&var-vcenter_vm_name=${__value.raw}&${__url_time_range}',
            },
          ]),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('rotmhz')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Net throughput')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Packet drops')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vm_path',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'vm_path',
                  'Value #A',
                  'Value #B',
                  'Value #C',
                  'Value #D',
                  'Value #E',
                  'Value #F',
                  'Value #G',
                  'Value #H',
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
                'Value #F': 6,
                'Value #G': 7,
                'Value #H': 8,
                vm_path: 0,
              },
              renameByName: {
                'Value #A': 'CPU usage',
                'Value #B': 'CPU utilization',
                'Value #C': 'Memory usage',
                'Value #D': 'Memory utilization',
                'Value #E': 'Disk usage',
                'Value #F': 'Disk utilization',
                'Value #G': 'Net throughput',
                'Value #H': 'Packet drops',
                vm_path: 'VM',
              },
            },
          },
        ]),

      hostDisksTable:
        commonlib.panels.generic.table.base.new(
          'Disks table',
          targets=[
            t.hostDiskReadThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
            t.hostDiskReadLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
            t.hostDiskWriteThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
            t.hostDiskWriteLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the disks associated with the ESXi hosts.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Throughput (R)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Delay (R)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('ms')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Throughput (W)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Delay (W)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('ms')
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'disk_path',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'disk_path',
                  'Value #A',
                  'Value #B',
                  'Value #C',
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
                'Value #A': 1,
                'Value #B': 2,
                'Value #C': 3,
                'Value #D': 4,
                disk_path: 0,
              },
              renameByName: {
                'Value #A': 'Throughput (R)',
                'Value #B': 'Delay (R)',
                'Value #C': 'Throughput (W)',
                'Value #D': 'Delay (W)',
                disk_path: 'Disk',
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
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('rotmhz'),

      vmCPUUtilization:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'CPU utilization',
          targets=[t.vmCPUUtilization],
          description='The CPU utilization percentage of VMs.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      vmMemoryUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Memory usage',
          targets=[t.vmMemoryUsage],
          description='The amount of memory used by the VMs.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('mbytes'),

      vmMemoryUtilization:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Memory utilization',
          targets=[t.vmMemoryUtilization],
          description='The memory utilization percentage of the VMs.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      vmDiskUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk usage',
          targets=[t.vmDiskUsage],
          description='The amount of disk space used by the VMs.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),

      vmDiskUtilization:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Disk utilization',
          targets=[t.vmDiskUtilization],
          description='The disk utilization percentage of VMs.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      vmModifiedMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Modified memory',
          targets=[t.vmModifiedMemoryBallooned, t.vmModifiedMemorySwapped],
          description='The amount of memory that has been swapped or ballooned on the VMs.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('mbytes'),

      vmNetworkThroughputRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Avg network throughput rate',
          targets=[t.vmNetworkReceivedThroughputRate, t.vmNetworkTransmittedThroughputRate],
          description='The 20s average rate of data transmitted or received over the network of the VMs.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('bottom')
        + g.panel.timeSeries.standardOptions.withUnit('KiBs'),

      vmPacketDropRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Avg packet drops',
          targets=[t.vmPacketReceivedDropRate, t.vmPacketTransmittedDropRate],
          description='The 20s average of received or transmitted packets dropped over the VMs network compared to the overall packets received or transmitted.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withPlacement('bottom')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      vmDisksTable:
        commonlib.panels.generic.table.base.new(
          'Disks table',
          targets=[
            t.vmDiskReadThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
            t.vmDiskReadLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
            t.vmDiskWriteThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
            t.vmDiskWriteLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the disks associated with the virtual machines.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Throughput (R)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Delay (R)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('ms')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Throughput (W)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Delay (W)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('ms')
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'disk_path',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'disk_path',
                  'Value #A',
                  'Value #B',
                  'Value #C',
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
                'Value #A': 1,
                'Value #B': 2,
                'Value #C': 3,
                'Value #D': 4,
                disk_path: 0,
              },
              renameByName: {
                'Value #A': 'Throughput (R)',
                'Value #B': 'Delay (R)',
                'Value #C': 'Throughput (W)',
                'Value #D': 'Delay (W)',
                disk_path: 'Disk',
              },
            },
          },
        ]),

      clusterVMsOnStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs on',
          targets=[t.clusterVMsOnCount],
          description='The number of virtual machines currently powered on within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      clusterVMsOffStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs off',
          targets=[t.clusterVMsOffCount],
          description='The number of virtual machines currently powered off within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      clusterVMsSuspendedStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs suspended',
          targets=[t.clusterVMsSuspendedCount],
          description='The number of virtual machines currently in a suspended state within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      clusterHostsActiveStatus:
        commonlib.panels.generic.stat.info.new(
          'Active ESXi hosts',
          targets=[t.clusterHostsActiveCount],
          description='The number of ESXi hosts that are currently running (responding and not in maintenance mode) within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      clusterHostsInactiveStatus:
        commonlib.panels.generic.stat.info.new(
          'Inactive ESXi hosts',
          targets=[t.clusterHostsInactiveCount],
          description='The number of ESXi hosts that are currently not running (not responding or in maintenance mode) within the cluster.'
        )
        + stat.options.withGraphMode('none'),

      clusterResourcePoolsStatus:
        commonlib.panels.generic.stat.info.new(
          'Resource pools',
          targets=[t.clusterResourcePoolsCount],
          description='The number of resource pools within the cluster (including nested).'
        )
        + stat.options.withGraphMode('none'),

      clusterCPULimit:
        barGauge.new(title='Cluster CPU limit')
        + barGauge.queryOptions.withTargets([
          t.clusterCPULimit,
        ])
        + barGauge.panelOptions.withDescription('The available CPU capacity of the cluster.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + barGauge.standardOptions.withUnit('rotmhz'),

      clusterCPUEffective:
        barGauge.new(title='Cluster CPU effective')
        + barGauge.queryOptions.withTargets([
          t.clusterCPUEffective,
        ])
        + barGauge.panelOptions.withDescription('The effective CPU capacity of the cluster.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + barGauge.standardOptions.withUnit('rotmhz'),

      clusterCPUUtilization:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Cluster CPU utilization',
          targets=[t.clusterCPUUtilization],
          description='The CPU utilization percentage of the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      clusterMemoryLimit:
        barGauge.new(title='Cluster memory limit')
        + barGauge.queryOptions.withTargets([
          t.clusterMemoryLimit,
        ])
        + barGauge.panelOptions.withDescription('The available memory capacity of the cluster.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + barGauge.standardOptions.withUnit('bytes'),

      clusterMemoryEffective:
        barGauge.new(title='Cluster memory effective')
        + barGauge.queryOptions.withTargets([
          t.clusterMemoryEffective,
        ])
        + barGauge.panelOptions.withDescription('The effective memory capacity of the cluster.')
        + barGauge.options.withOrientation('horizontal')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + barGauge.standardOptions.withUnit('bytes'),

      clusterMemoryUtilization:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Cluster memory utilization',
          targets=[t.clusterMemoryUtilization],
          description='The memory utilization percentage of the cluster.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      clusterHostsTable:
        commonlib.panels.generic.table.base.new(
          'ESXi hosts table',
          targets=[
            t.clusterHostCPUUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostCPUUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostMemoryUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostMemoryUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostDiskThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostDiskLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostNetworkThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostPacketErrorRate + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the ESXi hosts associated with the clusters.'
        )
        + table.standardOptions.withNoValue('NA')
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('ESXi host')
          + table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/vsphere-hosts?var-datasource=${datasource}&${__all_variables}&var-vcenter_host_name=${__value.raw}&${__url_time_range}',
            },
          ]),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('rotmhz')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk throughput')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk delay')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('ms')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Net throughput')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Packet drops')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
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
                  'vcenter_cluster_name 3',
                  'vcenter_host_name',
                  'Value #A',
                  'Value #B',
                  'Value #C',
                  'Value #D',
                  'Value #E',
                  'Value #F',
                  'Value #G',
                  'Value #H',
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
                'Value #B': 3,
                'Value #C': 4,
                'Value #D': 5,
                'Value #E': 6,
                'Value #F': 7,
                'Value #G': 8,
                'Value #H': 9,
                'vcenter_cluster_name 3': 0,
                vcenter_host_name: 1,
              },
              renameByName: {
                'Value #A': 'CPU usage',
                'Value #B': 'CPU utilization',
                'Value #C': 'Memory usage',
                'Value #D': 'Memory utilization',
                'Value #E': 'Disk throughput',
                'Value #F': 'Disk delay',
                'Value #G': 'Net throughput',
                'Value #H': 'Packet drops',
                'vcenter_cluster_name 3': 'Cluster',
                vcenter_host_name: 'ESXi host',
              },
            },
          },
        ]),

      clusterVMsTable:
        commonlib.panels.generic.table.base.new(
          'VMs table',
          targets=[
            t.clusterVMCPUUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMCPUUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMMemoryUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMMemoryUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMDiskUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMDiskUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMNetworkThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMPacketDropRate + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the VMs associated with the clusters.'
        )
        + table.standardOptions.withNoValue('NA')
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('VM')
          + table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/vsphere-virtual-machines?var-datasource=${datasource}&${__all_variables}&var-vcenter_vm_name=${__value.raw}&${__url_time_range}',
            },
          ]),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('rotmhz')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('mbytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Memory utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk usage')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Net throughput')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('KiBs')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Packet drops')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
          ),
        ])
        +
        table.queryOptions.withTransformationsMixin([
          {
            id: 'joinByField',
            options: {
              byField: 'vm_path',
              mode: 'outer',
            },
          },
          {
            id: 'filterFieldsByName',
            options: {
              include: {
                names: [
                  'vm_path',
                  'Value #A',
                  'Value #B',
                  'Value #C',
                  'Value #D',
                  'Value #E',
                  'Value #F',
                  'Value #G',
                  'Value #H',
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
                'Value #F': 6,
                'Value #G': 7,
                'Value #H': 8,
                vm_path: 0,
              },
              renameByName: {
                'Value #A': 'CPU usage',
                'Value #B': 'CPU utilization',
                'Value #C': 'Memory usage',
                'Value #D': 'Memory utilization',
                'Value #E': 'Disk usage',
                'Value #F': 'Disk utilization',
                'Value #G': 'Net throughput',
                'Value #H': 'Packet drops',
                vm_path: 'VM',
              },
            },
          },
        ]),
      },
}
