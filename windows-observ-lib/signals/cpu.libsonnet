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
      prometheus: 'windows_cpu_time_total',
    },
    signals: {
      cpuUsage: {
        name: 'CPU usage',
        nameShort: 'CPU',
        type: 'raw',
        description: 'CPU usage percentage',
        unit: 'percent',
        
        sources: {
          prometheus: {
            expr: '100 - (avg without (mode,core) (rate(windows_cpu_time_total{mode="idle", %(queriesSelector)s}[%(interval)s])*100))',
            legendCustomTemplate: 'CPU usage',
          },
        },
      },
      cpuUsageByMode: {
        name: 'CPU usage by mode',
        nameShort: 'CPU by mode',
        type: 'raw',
        description: 'CPU usage by mode (user, system, idle, etc.)',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(instance, mode, %(agg)s) (irate(windows_cpu_time_total{%(queriesSelector)s}[$__rate_interval])) \n/ on(instance) \ngroup_left sum by (instance) ((irate(windows_cpu_time_total{%(queriesSelector)s}[$__rate_interval]))) * 100\n',
            legendCustomTemplate: '{{ mode }}',
          },
        },
      },
      cpuQueueLength: {
        name: 'CPU queue length',
        nameShort: 'Queue',
        type: 'gauge',
        description: 'Average processor queue length',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_system_processor_queue_length{%(queriesSelector)s}',
            legendCustomTemplate: 'CPU average queue',
          },
        },
      },
    },
  } 