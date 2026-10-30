local common = import './common.libsonnet';

function(this)
  local deviceSources(expr, extra={}) =
    common.sources(std.strReplace(expr, '%(queriesSelector)s', '%(queriesSelector)s, ' + this.diskDeviceSelector), extra);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: common.discoveryMetric,
    signals: {
      diskIO: {
        name: 'Disk reads/writes',
        nameShort: 'I/O',
        type: 'counter',
        description: 'Bytes read and written per device.',
        unit: 'Bps',
        sources: deviceSources('system_disk_io{%(queriesSelector)s}', { aggKeepLabels: ['device', 'direction'] }),
      },
      diskIOTotal: {
        name: 'Disk I/O',
        nameShort: 'I/O',
        type: 'counter',
        description: 'Bytes read and written across all devices.',
        unit: 'Bps',
        sources: deviceSources('system_disk_io{%(queriesSelector)s}'),
      },
      diskOperations: {
        name: 'Disk operations',
        nameShort: 'Ops',
        type: 'counter',
        description: 'Read and write operations per second.',
        unit: 'iops',
        sources: deviceSources('system_disk_operations{%(queriesSelector)s}', { aggKeepLabels: ['device', 'direction'] }),
      },
      diskIOTime: {
        name: 'Disk I/O time',
        nameShort: 'I/O time',
        type: 'counter',
        description: 'Share of time each device spent performing I/O.',
        unit: 'percentunit',
        sources: deviceSources('system_disk_io_time{%(queriesSelector)s}', { aggKeepLabels: ['device'] }),
      },
      // Raw: a ratio of two counters' rates.
      diskWaitTime: {
        name: 'Disk average wait time',
        nameShort: 'Wait',
        type: 'raw',
        description: 'Mean time each operation spends being serviced.',
        unit: 's',
        sources: deviceSources(
          |||
            sum by (%(agg)s, device, direction) (rate(system_disk_operation_time{%(queriesSelector)s}[%(interval)s]))
            /
            (sum by (%(agg)s, device, direction) (rate(system_disk_operations{%(queriesSelector)s}[%(interval)s])) > 0)
          |||,
          { legendCustomTemplate: '%(aggLegend)s {{device}} {{direction}}' },
        ),
      },
      diskQueue: {
        name: 'Disk average queue',
        nameShort: 'Queue',
        type: 'counter',
        description: 'Weighted I/O time, an approximation of queue depth.',
        unit: 'short',
        sources: deviceSources('system_disk_weighted_io_time{%(queriesSelector)s}', { aggKeepLabels: ['device'] }),
      },
      diskPendingOperations: {
        name: 'Disk pending operations',
        nameShort: 'Pending',
        type: 'gauge',
        aggFunction: 'max',
        description: 'Operations queued but not yet complete.',
        unit: 'short',
        sources: deviceSources('system_disk_pending_operations{%(queriesSelector)s}', { aggKeepLabels: ['device'] }),
      },
      diskMerged: {
        name: 'Disk merged operations',
        nameShort: 'Merged',
        type: 'counter',
        description: 'Adjacent operations merged by the scheduler.',
        unit: 'ops',
        sources: deviceSources('system_disk_merged{%(queriesSelector)s}', { aggKeepLabels: ['device', 'direction'] }),
      },
    },
  }
