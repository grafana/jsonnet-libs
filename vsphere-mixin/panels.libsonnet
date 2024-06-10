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

      clustersCountStatus:
        commonlib.panels.generic.stat.info.new(
          'Clusters',
          targets=[t.clustersCount],
          description='The number of clusters in the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      hostsCountStatus:
        commonlib.panels.generic.stat.info.new(
          'ESXi hosts',
          targets=[t.hostsCount],
          description='The number of ESXi hosts in the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      resourcePoolsCountStatus:
        commonlib.panels.generic.stat.info.new(
          'Resource pools',
          targets=[t.resourcePoolsCount],
          description='The number of resource pools in the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      vmsCountStatus:
        commonlib.panels.generic.stat.info.new(
          'VMs',
          targets=[t.vmsCount],
          description='The number of virtual machines in the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      clusteredVMsOnStatus:
        commonlib.panels.generic.stat.info.new(
          'Clustered VMs on',
          targets=[t.clusteredVMsOnCount],
          description='The number of virtual machines currently powered on that belong to a cluster in the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      clusteredVMsOffStatus:
        commonlib.panels.generic.stat.info.new(
          'Clustered VMs off',
          targets=[t.clusteredVMsOffCount],
          description='The number of virtual machines currently powered off that belong to a cluster in the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      clusteredVMsSuspendedStatus:
        commonlib.panels.generic.stat.info.new(
          'Clustered VMs suspended',
          targets=[t.clusteredVMsSuspendedCount],
          description='The number of virtual machines currently in a suspended state that belong to a cluster in the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      clusteredVMTemplatesCountStatus:
        commonlib.panels.generic.stat.info.new(
          'Clustered VM templates',
          targets=[t.clusteredVMTemplatesCount],
          description='The number of virtual machine templates that belong to a cluster in the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      clusteredHostsActiveStatus:
        commonlib.panels.generic.stat.info.new(
          'Clustered active ESXi hosts',
          targets=[t.clusteredHostsActiveCount],
          description='The number of ESXi hosts that are currently running (responding and not in maintenance mode) that belong to a cluster within the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      clusteredHostsInactiveStatus:
        commonlib.panels.generic.stat.info.new(
          'Clustered inactive ESXi hosts',
          targets=[t.clusteredHostsInactiveCount],
          description='The number of ESXi hosts that are currently not running (not responding or in maintenance mode) that belong to a cluster within the datacenter.'
        )
        + stat.options.withGraphMode('none'),

      topCPUUtilizationClusters:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Top CPU utilization by cluster',
          targets=[t.topCPUUtilizationClusters],
          description='The clusters with the highest CPU utilization percentage in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topMemoryUtilizationClusters:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Top memory utilization by cluster',
          targets=[t.topMemoryUtilizationClusters],
          description='The clusters with the highest memory utilization percentage in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      clustersTable:
        commonlib.panels.generic.table.base.new(
          'Clusters table',
          targets=[
            t.effectiveCPUClusters + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('effective_cpu')
            ,
            t.topCPUUtilizationClusters + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('cpu_utilization')
            ,
            t.effectiveMemoryClusters + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('effective_memory')
            ,
            t.topMemoryUtilizationClusters + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('memory_utilization')
            ,
            t.hostsActiveClustersCount + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('hosts_active')
            ,
            t.hostsInactiveClustersCount + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('hosts_inactive')
            ,
            t.vmsOnClustersCount + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('vms_on')
            ,
            t.vmsOffClustersCount + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('vms_off')
            ,
            t.vmsSuspendedClustersCount + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('vms_suspended'),
          ],
          description='Information about the clusters in the vCenter environment.'
        )
        + table.standardOptions.withNoValue('NA')
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Cluster')
          + table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/vsphere-clusters?var-datasource=${datasource}&${__all_variables}&var-vcenter_cluster_name=${__value.raw}&${__url_time_range}',
            },
          ]),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('CPU (limit)')
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
          fieldOverride.byName.new('Memory (limit)')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
          ),
        ])
        +
        table.standardOptions.withOverridesMixin([
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
          fieldOverride.byName.new('Active ESXi')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Inactive ESXi')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('VMs on')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('VMs off')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('VMs suspended')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('custom.width', 140),
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
                  'Value #effective_cpu',
                  'Value #cpu_utilization',
                  'Value #effective_memory',
                  'Value #memory_utilization',
                  'Value #hosts_active',
                  'Value #hosts_inactive',
                  'Value #vms_on',
                  'Value #vms_off',
                  'Value #vms_suspended',
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
                'Value #effective_cpu': 2,
                'Value #cpu_utilization': 3,
                'Value #effective_memory': 4,
                'Value #memory_utilization': 5,
                'Value #hosts_active': 6,
                'Value #hosts_inactive': 7,
                'Value #vms_on': 8,
                'Value #vms_off': 9,
                'Value #vms_suspended': 10,
                vcenter_cluster_name: 1,
                'vcenter_datacenter_name 1': 0,
              },
              renameByName: {
                'Value #effective_cpu': 'CPU (limit)',
                'Value #cpu_utilization': 'CPU utilization',
                'Value #effective_memory': 'Memory (limit)',
                'Value #memory_utilization': 'Memory utilization',
                'Value #hosts_active': 'Active ESXi',
                'Value #hosts_inactive': 'Inactive ESXi',
                'Value #vms_on': 'VMs on',
                'Value #vms_off': 'VMs off',
                'Value #vms_suspended': 'VMs suspended',
                vcenter_cluster_name: 'Cluster',
                'vcenter_datacenter_name 1': 'Datacenter',
              },
            },
          },
        ]),

      datastoreTable:
        commonlib.panels.generic.table.base.new(
          'Datastores table',
          targets=[
            t.datastoreDiskTotal + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_total')
            + g.query.prometheus.withRange(true)
            ,
            t.datastoreDiskUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.datastoreDiskAvailable + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_available')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the datastores in the vCenter environment.'
        )
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk total')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('min.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk utilization')
          + fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('min.width', 157)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('percent')
            + table.standardOptions.color.withMode('continuous-BlPu')
            + table.standardOptions.withMin(0)
            + table.standardOptions.withMax(100)
            + table.standardOptions.withDecimals(1)
          ),
        ])
        + table.standardOptions.withOverridesMixin([
          fieldOverride.byName.new('Disk free')
          + fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('min.width', 140)
          + fieldOverride.byName.withPropertiesFromOptions(
            table.standardOptions.withUnit('bytes')
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
                  'vcenter_datacenter_name 1',
                  'vcenter_datastore_name',
                  'Value #disk_total',
                  'Value #disk_utilization',
                  'Value #disk_available',
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
                'Value #disk_total': 2,
                'Value #disk_utilization': 3,
                'Value #disk_available': 4,
                'vcenter_datacenter_name 1': 0,
                vcenter_datastore_name: 1,
              },
              renameByName: {
                'Value #disk_total': 'Disk total',
                'Value #disk_utilization': 'Disk utilization',
                'Value #disk_available': 'Disk free',
                'vcenter_datacenter_name 1': 'Datacenter',
                vcenter_datastore_name: 'Datastore',
              },
            },
          },
        ]),

      topCPUUsageResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU usage by resource pools',
          targets=[t.topCPUUsageResourcePools],
          description='The resource pools with the highest CPU usage in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('rotmhz'),

      topMemoryUsageResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory usage by resource pools',
          targets=[t.topMemoryUsageResourcePools],
          description='The resource pools with the highest memory usage in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('mbytes'),

      topCPUShareResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top CPU shares by resource pools',
          targets=[t.topCPUShareResourcePools],
          description='The resource pools with the highest amount of CPU shares allocated in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('shares'),

      topMemoryShareResourcePools:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory shares by resource pools',
          targets=[t.topMemoryShareResourcePools],
          description='The resource pools with the highest amount of memory shares allocated in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('shares'),

      topCPUUtilizationHosts:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Top CPU utilization by ESXi hosts',
          targets=[t.topCPUUtilizationHosts],
          description='The ESXi hosts with the highest CPU utilization in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topMemoryUtilizationHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top memory usage by ESXi hosts',
          targets=[t.topMemoryUtilizationHosts],
          description='The ESXi hosts with the highest memory utilization in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      topDiskAvgLatencyHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top avg disk latency by ESXi hosts',
          targets=[t.topDiskAvgLatencyHosts],
          description='The ESXi hosts with the highest average disk latency in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      topPacketErrorRateHosts:
        commonlib.panels.generic.timeSeries.base.new(
          'Top packet errors by ESXi hosts',
          targets=[t.topPacketErrorRateHosts],
          description='The ESXi hosts with the highest percentage of packet errors in the datacenter.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

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
            + g.query.prometheus.withRefId('cpu_usage')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMCPUUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMMemoryUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_usage')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMMemoryUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMDiskUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_usage')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMDiskUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMNetworkThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('netowrk_throughput')
            + g.query.prometheus.withRange(true)
            ,
            t.hostVMPacketDropRate + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('packet_drop_rate')
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
                  'Value #cpu_usage',
                  'Value #cpu_utilization',
                  'Value #memory_usage',
                  'Value #memory_utilization',
                  'Value #disk_usage',
                  'Value #disk_utilization',
                  'Value #netowrk_throughput',
                  'Value #packet_drop_rate',
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
                'Value #cpu_usage': 1,
                'Value #cpu_utilization': 2,
                'Value #memory_usage': 3,
                'Value #memory_utilization': 4,
                'Value #disk_usage': 5,
                'Value #disk_utilization': 6,
                'Value #netowrk_throughput': 7,
                'Value #packet_drop_rate': 8,
                vm_path: 0,
              },
              renameByName: {
                'Value #cpu_usage': 'CPU usage',
                'Value #cpu_utilization': 'CPU utilization',
                'Value #memory_usage': 'Memory usage',
                'Value #memory_utilization': 'Memory utilization',
                'Value #disk_usage': 'Disk usage',
                'Value #disk_utilization': 'Disk utilization',
                'Value #netowrk_throughput': 'Net throughput',
                'Value #packet_drop_rate': 'Packet drops',
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
            + g.query.prometheus.withRefId('disk_reads')
            + g.query.prometheus.withRange(true),
            t.hostDiskReadLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_read_latency')
            + g.query.prometheus.withRange(true),
            t.hostDiskWriteThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_writes')
            + g.query.prometheus.withRange(true),
            t.hostDiskWriteLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_write_latency')
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
                  'Value #disk_reads',
                  'Value #disk_read_latency',
                  'Value #disk_writes',
                  'Value #disk_write_latency',
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
                'Value #disk_reads': 1,
                'Value #disk_read_latency': 2,
                'Value #disk_writes': 3,
                'Value #disk_write_latency': 4,
                disk_path: 0,
              },
              renameByName: {
                'Value #disk_reads': 'Throughput (R)',
                'Value #disk_read_latency': 'Delay (R)',
                'Value #disk_writes': 'Throughput (W)',
                'Value #disk_write_latency': 'Delay (W)',
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
            + g.query.prometheus.withRefId('disk_reads')
            + g.query.prometheus.withRange(true),
            t.vmDiskReadLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_read_latency')
            + g.query.prometheus.withRange(true),
            t.vmDiskWriteThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_writes')
            + g.query.prometheus.withRange(true),
            t.vmDiskWriteLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_write_latency')
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
                  'Value #disk_reads',
                  'Value #disk_read_latency',
                  'Value #disk_writes',
                  'Value #disk_write_latency',
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
                'Value #disk_reads': 1,
                'Value #disk_read_latency': 2,
                'Value #disk_writes': 3,
                'Value #disk_write_latency': 4,
                disk_path: 0,
              },
              renameByName: {
                'Value #disk_reads': 'Throughput (R)',
                'Value #disk_read_latency': 'Delay (R)',
                'Value #disk_writes': 'Throughput (W)',
                'Value #disk_write_latency': 'Delay (W)',
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
            + g.query.prometheus.withRefId('cpu_usage')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostCPUUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostMemoryUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_usage')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostMemoryUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostDiskThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_throughput')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostDiskLatency + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_latency')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostNetworkThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('network_throughput')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterHostPacketErrorRate + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('packet_error_rate')
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
          fieldOverride.byName.new('Packet errors')
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
                  'Value #cpu_usage',
                  'Value #cpu_utilization',
                  'Value #memory_usage',
                  'Value #memory_utilization',
                  'Value #disk_throughput',
                  'Value #disk_latency',
                  'Value #network_throughput',
                  'Value #packet_error_rate',
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
                'Value #cpu_usage': 2,
                'Value #cpu_utilization': 3,
                'Value #memory_usage': 4,
                'Value #memory_utilization': 5,
                'Value #disk_throughput': 6,
                'Value #disk_latency': 7,
                'Value #network_throughput': 8,
                'Value #packet_error_rate': 9,
                'vcenter_cluster_name 3': 0,
                vcenter_host_name: 1,
              },
              renameByName: {
                'Value #cpu_usage': 'CPU usage',
                'Value #cpu_utilization': 'CPU utilization',
                'Value #memory_usage': 'Memory usage',
                'Value #memory_utilization': 'Memory utilization',
                'Value #disk_throughput': 'Disk throughput',
                'Value #disk_latency': 'Disk delay',
                'Value #network_throughput': 'Net throughput',
                'Value #packet_error_rate': 'Packet errors',
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
            + g.query.prometheus.withRefId('cpu_usage')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMCPUUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMMemoryUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_usage')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMMemoryUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMDiskUsage + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_usage')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMDiskUtilization + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_utilization')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMNetworkThroughput + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('network_throughput')
            + g.query.prometheus.withRange(true)
            ,
            t.clusterVMPacketDropRate + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('packet_drop_rate')
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
                  'Value #cpu_usage',
                  'Value #cpu_utilization',
                  'Value #memory_usage',
                  'Value #memory_utilization',
                  'Value #disk_usage',
                  'Value #disk_utilization',
                  'Value #network_throughput',
                  'Value #packet_drop_rate',
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
                'Value #cpu_usage': 1,
                'Value #cpu_utilization': 2,
                'Value #memory_usage': 3,
                'Value #memory_utilization': 4,
                'Value #disk_usage': 5,
                'Value #disk_utilization': 6,
                'Value #network_throughput': 7,
                'Value #packet_drop_rate': 8,
                vm_path: 0,
              },
              renameByName: {
                'Value #cpu_usage': 'CPU usage',
                'Value #cpu_utilization': 'CPU utilization',
                'Value #memory_usage': 'Memory usage',
                'Value #memory_utilization': 'Memory utilization',
                'Value #disk_usage': 'Disk usage',
                'Value #disk_utilization': 'Disk utilization',
                'Value #network_throughput': 'Net throughput',
                'Value #packet_drop_rate': 'Packet drops',
                vm_path: 'VM',
              },
            },
          },
        ]),
    },
}
