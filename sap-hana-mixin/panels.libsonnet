local g = (import './g.libsonnet');
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // Replication panels
      replicaStatus:
        g.panel.stat.new('Replica status')
        + g.panel.stat.panelOptions.withDescription('State of the replicas in the SAP HANA system')
        + g.panel.stat.queryOptions.withTargets([
          signals.replication.sr_replication.asTarget(),
        ])
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.withMappings([
          g.panel.stat.standardOptions.mapping.ValueMap.withType()
          + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
            '0': { color: 'green', index: 0, text: 'ACTIVE' },
            '1': { color: 'yellow', index: 1, text: 'INITIALIZING' },
            '2': { color: 'yellow', index: 2, text: 'SYNCING' },
            '3': { color: 'red', index: 3, text: 'UNKNOWN' },
            '4': { color: 'red', index: 4, text: 'ERROR' },
            '99': { color: 'red', index: 5, text: 'UNMAPPED' },
          }),
        ])
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('green') + g.panel.stat.thresholdStep.withValue(null),
          g.panel.stat.thresholdStep.withColor('green') + g.panel.stat.thresholdStep.withValue(0),
          g.panel.stat.thresholdStep.withColor('yellow') + g.panel.stat.thresholdStep.withValue(1),
          g.panel.stat.thresholdStep.withColor('red') + g.panel.stat.thresholdStep.withValue(3),
        ])
        + g.panel.stat.options.withColorMode('value')
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

      averageReplicationShipDelay:
        g.panel.timeSeries.new('Average replication ship delay')
        + g.panel.timeSeries.panelOptions.withDescription('Average system replication log shipping delay in the SAP HANA system')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.replication.sr_ship_delay.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('s')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green') + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red') + g.panel.timeSeries.thresholdStep.withValue(1),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // CPU panels
      cpuUsage:
        g.panel.timeSeries.new('CPU usage')
        + g.panel.timeSeries.panelOptions.withDescription('CPU usage percentage of the SAP HANA system')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.cpu.cpu_busy_percent_by_host.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green') + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red') + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Disk panels
      diskUsage:
        g.panel.timeSeries.new('Disk usage')
        + g.panel.timeSeries.panelOptions.withDescription('Disk utilization percentage of the SAP HANA system')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.disk.disk_usage_percent.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green') + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red') + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      diskIOThroughput:
        g.panel.timeSeries.new('Disk I/O throughput')
        + g.panel.timeSeries.panelOptions.withDescription('Disk I/O throughput in KB/s')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.disk.disk_io_throughput_kb_second.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      diskIOThroughputByDisk:
        g.panel.timeSeries.new('Disk I/O throughput by disk')
        + g.panel.timeSeries.panelOptions.withDescription('Disk I/O throughput by disk device in KB/s')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.disk.disk_io_throughput_kb_second_by_disk.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Memory panels
      physicalMemoryUsage:
        g.panel.timeSeries.new('Physical memory usage')
        + g.panel.timeSeries.panelOptions.withDescription('Physical memory utilization percentage of the SAP HANA system')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.memory.physical_memory_usage_percent.asTarget(),
          signals.memory.swap_memory_usage_percent.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green') + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red') + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      sapHanaMemoryUsage:
        g.panel.timeSeries.new('SAP HANA memory usage')
        + g.panel.timeSeries.panelOptions.withDescription('Total amount of used memory by processes in the SAP HANA system')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.memory.hana_memory_usage_percent.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green') + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red') + g.panel.timeSeries.thresholdStep.withValue(80),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      memoryAllocationLimit:
        g.panel.timeSeries.new('Memory allocation limit')
        + g.panel.timeSeries.panelOptions.withDescription('Memory allocation limit as a percentage of total physical memory')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.memory.memory_alloc_limit_percent.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('percent')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('red') + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('green') + g.panel.timeSeries.thresholdStep.withValue(90),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      schemaMemoryUsage:
        g.panel.timeSeries.new('Schema memory usage')
        + g.panel.timeSeries.panelOptions.withDescription('Memory used by SAP HANA schemas')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.memory.schema_used_memory_mb.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Network panels
      networkIOThroughput:
        g.panel.timeSeries.new('Network I/O throughput')
        + g.panel.timeSeries.panelOptions.withDescription('Network receive and transmit rate in KB/s')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.network.network_receive_rate_kb_per_seconds.asTarget(),
          signals.network.network_transmission_rate_kb_per_seconds.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      networkIOThroughputByInterface:
        g.panel.timeSeries.new('Network I/O throughput by interface')
        + g.panel.timeSeries.panelOptions.withDescription('Network receive and transmit rate by interface in KB/s')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.network.network_receive_rate_kb_per_seconds_by_interface.asTarget(),
          signals.network.network_transmission_rate_kb_per_seconds_by_interface.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('KBs')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // SQL panels
      avgSqlExecutionTime:
        g.panel.timeSeries.new('Average SQL execution time')
        + g.panel.timeSeries.panelOptions.withDescription('Average SQL service elapsed time per execution')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.sql.sql_service_elap_per_exec_avg_ms.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.standardOptions.thresholds.withSteps([
          g.panel.timeSeries.thresholdStep.withColor('green') + g.panel.timeSeries.thresholdStep.withValue(null),
          g.panel.timeSeries.thresholdStep.withColor('red') + g.panel.timeSeries.thresholdStep.withValue(1000),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      sqlLockTime:
        g.panel.timeSeries.new('SQL lock time')
        + g.panel.timeSeries.panelOptions.withDescription('SQL service lock time per execution')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.sql.sql_service_lock_per_exec_ms.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      sqlTopTimeConsumers:
        g.panel.timeSeries.new('SQL top time consumers')
        + g.panel.timeSeries.panelOptions.withDescription('Top SQL time consumers')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.sql.sql_top_time_consumers_mu.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('µs')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Connection panels
      totalConnections:
        g.panel.stat.new('Total connections')
        + g.panel.stat.panelOptions.withDescription('Total count of database connections')
        + g.panel.stat.queryOptions.withTargets([
          signals.connections.connections_total_count.asTarget(),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.stat.options.withGraphMode('area'),

      connectionsByType:
        g.panel.timeSeries.new('Connections by type')
        + g.panel.timeSeries.panelOptions.withDescription('Database connections by type and status')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.connections.connections_total_count_by_type.asTarget(),
        ])
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Storage panels
      topTableMemory:
        g.panel.timeSeries.new('Top table memory')
        + g.panel.timeSeries.panelOptions.withDescription('Top table column store memory consumption')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.storage.table_cs_top_mem_total_mb.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('decmbytes')
        + g.panel.timeSeries.options.tooltip.withMode('multi')
        + g.panel.timeSeries.options.tooltip.withSort('desc'),

      // Alert panels
      currentAlerts:
        g.panel.stat.new('Current alerts')
        + g.panel.stat.panelOptions.withDescription('Count of current system alerts')
        + g.panel.stat.queryOptions.withTargets([
          signals.alerts.alerts_current_rating.asTarget(),
        ])
        + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
        + g.panel.stat.options.withGraphMode('area'),

      alertsDetail:
        g.panel.table.new('Alerts detail')
        + g.panel.table.panelOptions.withDescription('Detailed current system alerts')
        + g.panel.table.queryOptions.withTargets([
          signals.alerts.alerts_current_rating_detail.asTarget()
          + g.query.prometheus.withFormat('table')
          + g.query.prometheus.withInstant(true),
        ]),
    },
}
