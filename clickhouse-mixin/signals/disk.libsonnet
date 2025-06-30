local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'ClickHouseProfileEvents_DiskReadElapsedMicroseconds',
    },
    signals: {
      diskReadLatency: {
        name: 'Disk read latency',
        nameShort: 'Read latency',
        type: 'counter',
        description: 'Time spent waiting for read syscall',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_DiskReadElapsedMicroseconds{%(queriesSelector)s}',
            legendCustomTemplate: 'Disk read elapsed',
            rangeFunction: 'increase',
            interval: '30s',
          },
        },
      },
      diskWriteLatency: {
        name: 'Disk write latency',
        nameShort: 'Write latency',
        type: 'counter',
        description: 'Time spent waiting for write syscall',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_DiskWriteElapsedMicroseconds{%(queriesSelector)s}',
            legendCustomTemplate: 'Disk write elapsed',
            rangeFunction: 'increase',
            interval: '30s',
          },
        },
      },
    },
  }
