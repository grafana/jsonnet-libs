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
      prometheus: 'activemq_memory_usage_ratio',
    },
    signals: {
      memoryUsage: {
        name: 'Broker memory usage',
        nameShort: 'Memory usage',
        type: 'gauge',
        description: 'The percentage of memory used by both topics and queues across brokers.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'activemq_memory_usage_ratio{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}}',
          },
        },
      },
      storeUsage: {
        name: 'Broker store usage',
        nameShort: 'Store usage',
        type: 'gauge',
        description: 'The percentage of store used by both topics and queues across brokers.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'activemq_store_usage_ratio{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}}',
          },
        },
      },
      tempUsage: {
        name: 'Broker temporary usage',
        nameShort: 'Temp usage',
        type: 'gauge',
        description: 'The percentage of temporary storage used by both topics and queues across brokers.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'activemq_temp_usage_ratio{%(queriesSelector)s}',
            legendCustomTemplate: '{{activemq_cluster}} - {{instance}}',
          },
        },
      },
      brokersOnline: {
        name: 'Brokers online',
        nameShort: 'Brokers online',
        type: 'gauge',
        description: 'Number of Apache ActiveMQ brokers that are online.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'count by (%(agg)s) (activemq_memory_usage_ratio{%(queriesSelector)s})',
            legendCustomTemplate: '__auto',
          },
        },
      },
    },
  }
