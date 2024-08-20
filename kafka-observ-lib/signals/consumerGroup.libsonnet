local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector + ', topic!~"%s"' % this.topicsIgnoreSelector,
    groupLabels: this.groupLabels,
    instanceLabels: ['topic', 'consumergroup'],  // this.instanceLabels is ommitted, as it would point to kafka_exporter instance.
    aggLevel: 'group',
    aggFunction: 'avg',
    legendCustomTemplate: '{{ consumergroup }} ({{ topic }})',
    discoveryMetric: {
      prometheus: 'kafka_consumergroup_lag',  // https://github.com/danielqsj/kafka_exporter?tab=readme-ov-file#metrics
      grafanacloud: 'kafka_consumergroup_uncomitted_offsets',  // https://github.com/grafana/kafka_exporter/blob/master/exporter/exporter.go#L887
    },
    signals: {
      consumerGroupLag: {
        name: 'Consumer group lag',
        description: 'Current approximate lag of a ConsumerGroup at Topic/Partition.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          prometheus: {
            aggKeepLabels: ['consumergroup', 'topic'],
            expr: 'kafka_consumergroup_lag{%(queriesSelector)s}',
          },
          grafanacloud: {
            aggKeepLabels: ['consumergroup', 'topic'],
            expr: 'kafka_consumergroup_uncomitted_offsets{%(queriesSelector)s}',
          },
        },
      },

      consumerGroupLagTime: {
        name: 'Consumer group lag in ms',
        description: 'Current approximate lag of a ConsumerGroup at Topic/Partition.',
        type: 'gauge',
        unit: 'ms',
        optional: true,
        sources: {
          // prometheus: {}, n/a in danielqsj/kafka_exporter
          grafanacloud: {
            aggKeepLabels: ['consumergroup', 'topic'],
            expr: 'kafka_consumer_lag_millis{%(queriesSelector)s}',
          },
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
