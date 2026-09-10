local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this):
    {
      local signals = this.signals,
      // Drill-down targets are dashboard uids, which are '<config.uid>-<name>'.
      local uid = g.util.string.slugify(this.config.uid),

      clustersCountStatus:
        signals.overview.clustersCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      hostsCountStatus:
        signals.overview.hostsCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      resourcePoolsCountStatus:
        signals.overview.resourcePoolsCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      vmsCountStatus:
        signals.overview.vmsCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusteredVMsOnStatus:
        signals.overview.clusteredVMsOnCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusteredVMsOffStatus:
        signals.overview.clusteredVMsOffCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusteredVMsSuspendedStatus:
        signals.overview.clusteredVMsSuspendedCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusteredVMTemplatesCountStatus:
        signals.overview.clusteredVMTemplatesCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusteredHostsActiveStatus:
        signals.overview.clusteredHostsActiveCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusteredHostsInactiveStatus:
        signals.overview.clusteredHostsInactiveCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      topCPUUtilizationClusters:
        signals.overview.topCPUUtilizationClusters.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      topMemoryUtilizationClusters:
        signals.overview.topMemoryUtilizationClusters.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      clustersTable:
        commonlib.panels.generic.table.base.new(
          'Clusters table',
          targets=[
            signals.overview.totalCPUClusters.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('total_cpu')
            ,
            signals.overview.topCPUUtilizationClusters.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('cpu_utilization')
            ,
            signals.overview.totalMemoryClusters.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('total_memory')
            ,
            signals.overview.topMemoryUtilizationClusters.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('memory_utilization')
            ,
            signals.overview.hostsActiveClustersCount.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('hosts_active')
            ,
            signals.overview.hostsInactiveClustersCount.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('hosts_inactive')
            ,
            signals.overview.vmsOnClustersCount.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('vms_on')
            ,
            signals.overview.vmsOffClustersCount.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('vms_off')
            ,
            signals.overview.vmsSuspendedClustersCount.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRange(true)
            + g.query.prometheus.withRefId('vms_suspended'),
          ],
          description='Information about the clusters in the vCenter environment.'
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Cluster')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/' + uid + '-clusters?var-datasource=${datasource}&${__all_variables}&var-vcenter_cluster_name=${__value.raw}&${__url_time_range}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('CPU')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('rotmhz')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('CPU utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Memory')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('bytes')
          ),
        ])
        +
        g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Memory utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Active ESXi')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Inactive ESXi')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('VMs on')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('VMs off')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('VMs suspended')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140),
        ])
        +
        g.panel.table.queryOptions.withTransformationsMixin([
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
                  'Value #total_cpu',
                  'Value #cpu_utilization',
                  'Value #total_memory',
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
                'Value #total_cpu': 2,
                'Value #cpu_utilization': 3,
                'Value #total_memory': 4,
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
                'Value #total_cpu': 'CPU',
                'Value #cpu_utilization': 'CPU utilization',
                'Value #total_memory': 'Memory',
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
            signals.datastore.datastoreDiskTotal.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_total')
            + g.query.prometheus.withRange(true)
            ,
            signals.datastore.datastoreDiskUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.datastore.datastoreDiskAvailable.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_available')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the datastores in the vCenter environment.'
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk total')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('min.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('bytes')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('min.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk free')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('min.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('bytes')
          ),
        ])
        +
        g.panel.table.queryOptions.withTransformationsMixin([
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
        signals.overview.topCPUUsageResourcePools.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      topMemoryUsageResourcePools:
        signals.overview.topMemoryUsageResourcePools.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      topCPUShareResourcePools:
        signals.overview.topCPUShareResourcePools.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      topMemoryShareResourcePools:
        signals.overview.topMemoryShareResourcePools.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      topCPUUtilizationHosts:
        signals.overview.topCPUUtilizationHosts.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      topMemoryUtilizationHosts:
        signals.overview.topMemoryUtilizationHosts.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      topDiskAvgLatencyHosts:
        signals.overview.topDiskAvgLatencyHosts.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      topPacketErrorRateHosts:
        signals.overview.topPacketErrorRateHosts.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      hostCPUUsage:
        signals.host.hostCPUUsage.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      hostCPUUtilization:
        signals.host.hostCPUUtilization.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      hostMemoryUsage:
        signals.host.hostMemoryUsage.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      hostMemoryUtilization:
        signals.host.hostMemoryUtilization.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      hostModifiedMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Modified memory',
          targets=[signals.host.hostModifiedMemoryBallooned.asTarget(), signals.host.hostModifiedMemorySwapped.asTarget()],
          description='The amount of memory that has been swapped or ballooned on the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('mbytes')
        + g.panel.timeSeries.options.legend.withPlacement('right'),

      hostNetworkThroughputRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Avg network throughput rate',
          targets=[signals.host.hostNetworkTransmittedThroughputRate.asTarget(), signals.host.hostNetworkReceivedThroughputRate.asTarget()],
          description='The 20s average rate of data transmitted or received over the network of the ESXi host.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KiBs'),

      hostPacketErrorRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Avg packet errors',
          targets=[signals.host.hostPacketReceivedErrorRate.asTarget(), signals.host.hostPacketTransmittedErrorRate.asTarget()],
          description='The 20s average of received or transmitted packets dropped over the ESXi hosts network compared to the overall packets received or transmitted.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      hostVMsTable:
        commonlib.panels.generic.table.base.new(
          'VMs table',
          targets=[
            signals.host.hostVMCPUUsage.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_usage')
            + g.query.prometheus.withRange(true)
            ,
            signals.host.hostVMCPUUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.host.hostVMMemoryUsage.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_usage')
            + g.query.prometheus.withRange(true)
            ,
            signals.host.hostVMMemoryUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.host.hostVMDiskUsage.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_usage')
            + g.query.prometheus.withRange(true)
            ,
            signals.host.hostVMDiskUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.host.hostVMNetworkThroughput.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('netowrk_throughput')
            + g.query.prometheus.withRange(true)
            ,
            signals.host.hostVMPacketDropRate.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('packet_drop_rate')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the VMs associated with the ESXi hosts.'
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('VM')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/' + uid + '-virtual-machines?var-datasource=${datasource}&${__all_variables}&var-vcenter_vm_name=${__value.raw}&${__url_time_range}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('CPU usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('rotmhz')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('CPU utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Memory usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('mbytes')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Memory utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('bytes')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Net throughput')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('KiBs')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Packet drops')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
          ),
        ])
        +
        g.panel.table.queryOptions.withTransformationsMixin([
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
            signals.host.hostDiskReadThroughput.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_reads')
            + g.query.prometheus.withRange(true),
            signals.host.hostDiskReadLatency.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_read_latency')
            + g.query.prometheus.withRange(true),
            signals.host.hostDiskWriteThroughput.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_writes')
            + g.query.prometheus.withRange(true),
            signals.host.hostDiskWriteLatency.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_write_latency')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the disks associated with the ESXi hosts.'
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Throughput (R)')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('KiBs')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Delay (R)')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('ms')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Throughput (W)')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('KiBs')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Delay (W)')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('ms')
          ),
        ])
        +
        g.panel.table.queryOptions.withTransformationsMixin([
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
        signals.vm.vmCPUUsage.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      vmCPUUtilization:
        signals.vm.vmCPUUtilization.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      vmMemoryUsage:
        signals.vm.vmMemoryUsage.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      vmMemoryUtilization:
        signals.vm.vmMemoryUtilization.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      vmDiskUsage:
        signals.vm.vmDiskUsage.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize(),

      vmDiskUtilization:
        signals.vm.vmDiskUtilization.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      vmModifiedMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Modified memory',
          targets=[signals.vm.vmModifiedMemoryBallooned.asTarget(), signals.vm.vmModifiedMemorySwapped.asTarget()],
          description='The amount of memory that has been swapped or ballooned on the VMs.'
        )
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('mbytes'),

      vmNetworkThroughputRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Avg network throughput rate',
          targets=[signals.vm.vmNetworkReceivedThroughputRate.asTarget(), signals.vm.vmNetworkTransmittedThroughputRate.asTarget()],
          description='The 20s average rate of data transmitted or received over the network of the VMs.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('KiBs'),

      vmPacketDropRate:
        commonlib.panels.generic.timeSeries.base.new(
          'Avg packet drops',
          targets=[signals.vm.vmPacketReceivedDropRate.asTarget(), signals.vm.vmPacketTransmittedDropRate.asTarget()],
          description='The 20s average of received or transmitted packets dropped over the VMs network compared to the overall packets received or transmitted.'
        )
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      vmDisksTable:
        commonlib.panels.generic.table.base.new(
          'Disks table',
          targets=[
            signals.vm.vmDiskReadThroughput.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_reads')
            + g.query.prometheus.withRange(true),
            signals.vm.vmDiskReadLatency.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_read_latency')
            + g.query.prometheus.withRange(true),
            signals.vm.vmDiskWriteThroughput.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_writes')
            + g.query.prometheus.withRange(true),
            signals.vm.vmDiskWriteLatency.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_write_latency')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the disks associated with the virtual machines.'
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Throughput (R)')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('KiBs')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Delay (R)')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('ms')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Throughput (W)')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('KiBs')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Delay (W)')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('ms')
          ),
        ])
        +
        g.panel.table.queryOptions.withTransformationsMixin([
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
        signals.cluster.clusterVMsOnCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusterVMsOffStatus:
        signals.cluster.clusterVMsOffCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusterVMsSuspendedStatus:
        signals.cluster.clusterVMsSuspendedCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusterHostsActiveStatus:
        signals.cluster.clusterHostsActiveCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusterHostsInactiveStatus:
        signals.cluster.clusterHostsInactiveCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      clusterResourcePoolsStatus:
        signals.cluster.clusterResourcePoolsCount.asStat()
        + commonlib.panels.generic.stat.info.stylize(),

      // The four capacity panels below are the only ones still built from raw grafonnet.
      // common-lib's panels.generic exposes timeSeries, stat, table and statusHistory
      // bases only -- there is no barGauge base to inherit from, and these are horizontal
      // bar gauges by design (a single capacity figure per cluster reads better as a bar
      // than as a stat or a line). Spelled out in full rather than aliased.
      clusterCPULimit:
        g.panel.barGauge.new(title='Cluster CPU limit')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.clusterCPULimit.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('The available CPU capacity of the cluster.')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.barGauge.standardOptions.withUnit('rotmhz'),

      clusterCPUEffective:
        g.panel.barGauge.new(title='Cluster CPU effective')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.clusterCPUEffective.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('The effective CPU capacity of the cluster.')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.barGauge.standardOptions.withUnit('rotmhz'),

      clusterCPUUtilization:
        signals.cluster.clusterCPUUtilization.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      clusterMemoryLimit:
        g.panel.barGauge.new(title='Cluster memory limit')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.clusterMemoryLimit.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('The available memory capacity of the cluster.')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.barGauge.standardOptions.withUnit('bytes'),

      clusterMemoryEffective:
        g.panel.barGauge.new(title='Cluster memory effective')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.clusterMemoryEffective.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('The effective memory capacity of the cluster.')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.barGauge.standardOptions.withUnit('bytes'),

      clusterMemoryUtilization:
        signals.cluster.clusterMemoryUtilization.asTimeSeries()
        + commonlib.panels.memory.timeSeries.usagePercent.stylize(),

      clusterHostsTable:
        commonlib.panels.generic.table.base.new(
          'ESXi hosts table',
          targets=[
            signals.cluster.clusterHostCPUUsage.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_usage')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterHostCPUUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterHostMemoryUsage.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_usage')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterHostMemoryUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterHostDiskThroughput.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_throughput')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterHostDiskLatency.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_latency')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterHostNetworkThroughput.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('network_throughput')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterHostPacketErrorRate.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('packet_error_rate')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the ESXi hosts associated with the clusters.'
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('ESXi host')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/' + uid + '-hosts?var-datasource=${datasource}&${__all_variables}&var-vcenter_host_name=${__value.raw}&${__url_time_range}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('CPU usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('rotmhz')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('CPU utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Memory usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('mbytes')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Memory utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk throughput')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('KiBs')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk delay')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('ms')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Net throughput')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('KiBs')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Packet errors')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
          ),
        ])
        +
        g.panel.table.queryOptions.withTransformationsMixin([
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
            signals.cluster.clusterVMCPUUsage.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_usage')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterVMCPUUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('cpu_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterVMMemoryUsage.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_usage')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterVMMemoryUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('memory_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterVMDiskUsage.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_usage')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterVMDiskUtilization.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('disk_utilization')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterVMNetworkThroughput.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('network_throughput')
            + g.query.prometheus.withRange(true)
            ,
            signals.cluster.clusterVMPacketDropRate.asTarget() + g.query.prometheus.withFormat('table')
            + g.query.prometheus.withRefId('packet_drop_rate')
            + g.query.prometheus.withRange(true),
          ],
          description='Information about the VMs associated with the clusters.'
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('VM')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/' + uid + '-virtual-machines?var-datasource=${datasource}&${__all_variables}&var-vcenter_vm_name=${__value.raw}&${__url_time_range}',
            },
          ]),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('CPU usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('rotmhz')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('CPU utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Memory usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('mbytes')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Memory utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk usage')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('bytes')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Disk utilization')
          + g.panel.table.fieldOverride.byName.withProperty('custom.displayMode', 'gradient-gauge')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
            + g.panel.table.standardOptions.color.withMode('continuous-BlPu')
            + g.panel.table.standardOptions.withMin(0)
            + g.panel.table.standardOptions.withMax(100)
            + g.panel.table.standardOptions.withDecimals(1)
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Net throughput')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('KiBs')
          ),
        ])
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('Packet drops')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 140)
          + g.panel.table.fieldOverride.byName.withPropertiesFromOptions(
            g.panel.table.standardOptions.withUnit('percent')
          ),
        ])
        +
        g.panel.table.queryOptions.withTransformationsMixin([
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
