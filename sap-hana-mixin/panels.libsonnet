local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // System overview panels
      systemReplicaStatusPanel:
        g.panel.stat.new('Replica status')
        + g.panel.stat.queryOptions.withTargets([
          signals.system.replicaStatus.asTarget(),
        ])
        + signals.system.replicaStatus.asOverride()
        + g.panel.stat.panelOptions.withDescription('State of the replicas in the SAP HANA system')
        + g.panel.stat.options.withColorMode('value')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.withTextMode('auto')
        + g.panel.stat.standardOptions.thresholds.withMode('absolute')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          { color: 'green', value: null },
          { color: 'green', value: 0 },
          { color: 'yellow', value: 1 },
          { color: 'red', value: 3 },
        ]),

      systemReplicationShipDelayPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average replication ship delay',
          targets=[signals.system.replicationShipDelay.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average system replication log shipping delay in the SAP HANA system')
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withThresholdsStyle({ mode: 'line' }),

      systemCpuUsagePanel:
        commonlib.panels.cpu.timeSeries.utilization.new(
          'CPU usage',
          targets=[signals.system.cpuUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('CPU usage percentage of the SAP HANA system')
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withThresholdsStyle({ mode: 'line' }),

      systemDiskUsagePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Disk usage',
          targets=[signals.system.diskUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Disk utilization percentage of the SAP HANA system')
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withThresholdsStyle({ mode: 'line' }),

      systemPhysicalMemoryUsagePanel:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Physical memory usage',
          targets=[
            signals.system.physicalMemoryUsageResident.asTarget(),
            signals.system.physicalMemoryUsageSwap.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Physical memory utilization percentage of the SAP HANA system')
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withThresholdsStyle({ mode: 'line' }),

      systemHanaMemoryUsagePanel:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'SAP HANA memory usage',
          targets=[signals.system.hanaMemoryUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Total amount of used memory by processes in the SAP HANA system')
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withThresholdsStyle({ mode: 'line' }),

      systemNetworkIOThroughputPanel:
        commonlib.panels.network.timeSeries.traffic.new(
          'Network I/O throughput',
          targets=[
            signals.system.networkReceiveRate.asTarget(),
            signals.system.networkTransmitRate.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Network I/O throughput in the SAP HANA system')
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      systemDiskIOThroughputPanel:
        commonlib.panels.disk.timeSeries.ioBytesPerSec.new(
          'Disk I/O throughput',
          targets=[signals.system.diskIOThroughput.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Disk throughput for the SAP HANA system')
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      systemAvgQueryExecutionTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average query execution time',
          targets=[signals.system.avgQueryExecutionTime.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average elapsed time per execution across the SAP HANA system')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      systemActiveConnectionsPanel:
        g.panel.stat.new('Active connections')
        + g.panel.stat.queryOptions.withTargets([
          signals.system.activeConnections.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('Number of connections in active states across the SAP HANA system')
        + g.panel.stat.standardOptions.withUnit('short')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('blue')
        + g.panel.stat.options.withColorMode('value')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.withTextMode('auto'),

      systemIdleConnectionsPanel:
        g.panel.stat.new('Idle connections')
        + g.panel.stat.queryOptions.withTargets([
          signals.system.idleConnections.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('Number of connections in the idle state across the SAP HANA system')
        + g.panel.stat.standardOptions.withUnit('short')
        + g.panel.stat.standardOptions.color.withMode('fixed')
        + g.panel.stat.standardOptions.color.withFixedColor('blue')
        + g.panel.stat.options.withColorMode('value')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.withTextMode('auto'),

      systemAlertsPanel:
        g.panel.stat.new('Alerts')
        + g.panel.stat.queryOptions.withTargets([
          signals.system.alertsCount.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription('Count of the SAP HANA current alerts in the SAP HANA system')
        + g.panel.stat.standardOptions.withUnit('short')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.options.withColorMode('value')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.withTextMode('auto'),

      systemRecentAlertsPanel:
        g.panel.table.new('Recent alerts')
        + g.panel.table.queryOptions.withDatasource(type='prometheus', uid='${' + this.grafana.variables.datasources.prometheus.name + '}')
        + g.panel.table.queryOptions.withTargets([
          signals.system.recentAlerts.asTableTarget(),
        ])
        + g.panel.table.panelOptions.withDescription('Table of the recent SAP HANA current alerts in the SAP HANA system')
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {
              Time: false,
              Value: true,
              __name__: true,
              alert_timestamp: true,
              database_name: true,
              host: true,
              insnr: true,
              instance: true,
              job: true,
              port: true,
              sid: true,
            },
            indexByName: {
              Time: 2,
              Value: 12,
              __name__: 4,
              alert_details: 0,
              alert_timestamp: 3,
              alert_useraction: 1,
              database_name: 5,
              host: 6,
              insnr: 7,
              instance: 8,
              job: 9,
              port: 10,
              sid: 11,
            },
            renameByName: {
              alert_details: 'Details',
              alert_timestamp: '',
              alert_useraction: 'Action',
              database_name: '',
            },
          }),
          g.panel.table.transformation.withId('groupBy')
          + g.panel.table.transformation.withOptions({
            fields: {
              Action: {
                aggregations: [],
                operation: 'groupby',
              },
              Details: {
                aggregations: [],
                operation: 'groupby',
              },
              Time: {
                aggregations: ['lastNotNull'],
                operation: 'aggregate',
              },
            },
          }),
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {},
            indexByName: {},
            renameByName: {
              Action: '',
              'Time (lastNotNull)': 'Time (last fired)',
            },
          }),
        ]),

      // Instance overview panels
      instanceCpuUsagePanel:
        commonlib.panels.cpu.timeSeries.utilization.new(
          'CPU usage',
          targets=[signals.instance.cpuUsageByCore.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('CPU usage percentage of the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      instanceDiskUsagePanel:
        commonlib.panels.disk.timeSeries.usagePercent.new(
          'Disk usage',
          targets=[signals.instance.diskUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Disk utilization percentage of the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      instancePhysicalMemoryUsagePanel:
        commonlib.panels.memory.timeSeries.usagePercent.new(
          'Physical memory usage',
          targets=[
            signals.instance.physicalMemoryUsageResident.asTarget(),
            signals.instance.physicalMemoryUsageSwap.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Physical memory utilization percentage of the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('percent'),

      instanceSchemaMemoryUsagePanel:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Schema memory usage',
          targets=[signals.instance.schemaMemoryUsage.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Total used memory by schema in the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes'),

      instanceNetworkIOThroughputPanel:
        commonlib.panels.network.timeSeries.traffic.new(
          'Network I/O throughput',
          targets=[
            signals.instance.networkReceiveByInterface.asTarget(),
            signals.instance.networkTransmitByInterface.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Network I/O throughput for the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      instanceDiskIOThroughputPanel:
        commonlib.panels.disk.timeSeries.ioBytesPerSec.new(
          'Disk I/O throughput',
          targets=[signals.instance.diskIOByDisk.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Disk throughput for the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('KBs'),

      instanceConnectionsPanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Connections',
          targets=[signals.instance.connectionsByStatus.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Number of connections grouped by type and status in the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      instanceAvgQueryExecutionTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average query execution time',
          targets=[signals.performance.avgQueryExecutionTime.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average elapsed time per execution by service and SQL type in the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      instanceAvgLockWaitTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Average lock wait execution time',
          targets=[signals.performance.avgLockWaitTime.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Average lock wait time per execution by service and SQL type in the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      instanceAlertsPanel:
        g.panel.stat.new('Alerts')
        + g.panel.stat.queryOptions.withTargets([
          signals.instance.alertsCount.asTarget(),
        ])
        + g.panel.stat.panelOptions.withDescription("Count of the SAP HANA instance's current alerts")
        + g.panel.stat.standardOptions.withUnit('short')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.options.withColorMode('value')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.withTextMode('auto'),

      instanceRecentAlertsPanel:
        g.panel.table.new('Recent alerts')
        + g.panel.table.queryOptions.withDatasource(type='prometheus', uid='${' + this.grafana.variables.datasources.prometheus.name + '}')
        + g.panel.table.queryOptions.withTargets([
          signals.instance.recentAlerts.asTableTarget(),
        ])
        + g.panel.table.panelOptions.withDescription('Table of the recent SAP HANA current alerts in the SAP HANA instance')
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {
              Value: true,
              __name__: true,
              alert_timestamp: true,
              database_name: true,
              host: true,
              insnr: true,
              instance: true,
              job: true,
              port: true,
              sid: true,
            },
            indexByName: {
              Time: 2,
              Value: 12,
              __name__: 3,
              alert_details: 0,
              alert_timestamp: 4,
              alert_useraction: 1,
              database_name: 5,
              host: 6,
              insnr: 7,
              instance: 8,
              job: 9,
              port: 10,
              sid: 11,
            },
            renameByName: {
              Time: '',
              alert_details: 'Details',
              alert_useraction: 'Action',
              port: '',
            },
          }),
          g.panel.table.transformation.withId('groupBy')
          + g.panel.table.transformation.withOptions({
            fields: {
              Action: {
                aggregations: [],
                operation: 'groupby',
              },
              Details: {
                aggregations: [],
                operation: 'groupby',
              },
              Time: {
                aggregations: ['lastNotNull'],
                operation: 'aggregate',
              },
            },
          }),
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {},
            indexByName: {},
            renameByName: {
              'Time (lastNotNull)': 'Time (last fired)',
            },
          }),
        ]),

      instanceTopTablesByMemoryPanel:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Top tables by memory',
          targets=[signals.performance.topTablesByMemory.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Top tables by the sum of memory size in the main, delta, and history parts for the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes'),

      instanceTopSQLByTimePanel:
        commonlib.panels.generic.timeSeries.base.new(
          'Top SQL queries by average time',
          targets=[signals.performance.topSQLByTime.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('Top statements by time consumed over all executions for the SAP HANA instance')
        + g.panel.timeSeries.standardOptions.withUnit('µs'),

    },
}
