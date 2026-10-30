local common = import './common.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: common.discoveryMetric,
    signals: {
      // Raw: one minus the idle and wait shares summed per core, then averaged across cores.
      cpuUsage: {
        name: 'CPU usage',
        nameShort: 'CPU',
        type: 'raw',
        description: 'Share of CPU time spent working: not idle, and not waiting for I/O.',
        unit: 'percent',
        sources: common.sources(
          '100 * (1 - avg by (%(agg)s) (sum by (%(agg)s, cpu) (system_cpu_utilization{%(queriesSelector)s, state=~"idle|wait"})))',
          { legendCustomTemplate: '%(aggLegend)s' },
        ),
      },
      cpuUsageByMode: {
        name: 'CPU usage by mode',
        nameShort: 'CPU by mode',
        type: 'gauge',
        aggFunction: 'avg',
        description: 'CPU time share per state, excluding idle.',
        unit: 'percent',
        sources: common.sources(
          'system_cpu_utilization{%(queriesSelector)s, state!="idle"}',
          { aggKeepLabels: ['state'], legendCustomTemplate: '%(aggLegend)s {{state}}', exprWrappers: [['100 * (', ')']] },
        ),
      },
      // Raw: one minus the idle and wait shares summed per core.
      cpuUsagePerCore: {
        name: 'CPU usage per core',
        nameShort: 'Core',
        type: 'raw',
        description: 'Share of time each core spends working: not idle, and not waiting for I/O.',
        unit: 'percent',
        sources: common.sources(
          '100 * (1 - sum by (%(agg)s, cpu) (system_cpu_utilization{%(queriesSelector)s, state=~"idle|wait"}))',
          { legendCustomTemplate: '%(aggLegend)s {{cpu}}' },
        ),
      },
      cpuTimeByMode: {
        name: 'CPU time by mode',
        nameShort: 'CPU time',
        type: 'counter',
        aggFunction: 'sum',
        description: 'CPU seconds spent per second in each state, in cores.',
        unit: 'short',
        sources: common.sources('system_cpu_time{%(queriesSelector)s}', { aggKeepLabels: ['state'] }),
      },
      cpuFrequency: {
        name: 'CPU frequency',
        nameShort: 'Frequency',
        type: 'gauge',
        description: 'Current clock frequency per core.',
        unit: 'hertz',
        sources: common.sources('system_cpu_frequency{%(queriesSelector)s}', { aggKeepLabels: ['cpu'] }),
      },
      loadAverage1m: {
        name: 'Load average 1m',
        nameShort: '1m',
        type: 'gauge',
        aggFunction: 'max',
        description: 'System load over 1 minute.',
        unit: 'short',
        sources: common.sources('system_cpu_load_average_1m{%(queriesSelector)s}'),
      },
      loadAverage5m: {
        name: 'Load average 5m',
        nameShort: '5m',
        type: 'gauge',
        aggFunction: 'max',
        description: 'System load over 5 minutes.',
        unit: 'short',
        sources: common.sources('system_cpu_load_average_5m{%(queriesSelector)s}'),
      },
      loadAverage15m: {
        name: 'Load average 15m',
        nameShort: '15m',
        type: 'gauge',
        aggFunction: 'max',
        description: 'System load over 15 minutes.',
        unit: 'short',
        sources: common.sources('system_cpu_load_average_15m{%(queriesSelector)s}'),
      },
    },
  }
