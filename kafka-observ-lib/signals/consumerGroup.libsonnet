local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector + ', topic!~"%s"' % this.topicsIgnoreSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels + ['topic', 'consumergroup'],
    aggLevel: 'group',
    aggFunction: 'avg',
    legendCustomTemplate: '%(aggLegend)s',
    discoveryMetric: {
      prometheus: 'kafka_consumergroup_lag',  //https://github.com/danielqsj/kafka_exporter?tab=readme-ov-file#metrics
      grafanacloud: self.prometheus,
    },
    signals: {
      consumerGroupLag: {
        name: 'Consumer group lag',
        description: 'Current approximate lag of a ConsumerGroup at Topic/Partition.',
        type: 'gauge',
        unit: 's',
        sources: {
          prometheus: {
            aggKeepLabels: ['consumergroup', 'topic'],
            expr: 'kafka_consumergroup_lag{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
        },
      },
      consumerGroupConsumeRate: {
        name: 'Consumer group consume rate',
        description: 'Consumer group consume rate.',
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            aggKeepLabels: ['consumergroup', 'topic'],
            expr: 'kafka_consumergroup_current_offset{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
        },
      },
    },
  }
