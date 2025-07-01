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
      prometheus: 'ClickHouseMetrics_MemoryTracking',
    },
    signals: {
      memoryUsage: {
        name: 'Memory usage',
        nameShort: 'Memory',
        type: 'gauge',
        description: 'Memory usage over time',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_MemoryTracking{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Memory tracking',
          },
        },
      },
      memoryUsagePercent: {
        name: 'Memory usage percentage',
        nameShort: 'Memory %',
        type: 'gauge',
        description: 'Percentage of memory allocated by ClickHouse compared to OS total',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '(ClickHouseMetrics_MemoryTracking{%(queriesSelector)s} / ClickHouseAsyncMetrics_OSMemoryTotal{%(queriesSelector)s}) * 100',
            legendCustomTemplate: '{{ instance }} - Memory tracking percent',
          },
        },
      },
    },
  }
