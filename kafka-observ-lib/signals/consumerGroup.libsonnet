local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: std.join(',', [this.topicsFilteringSelector, this.consumerGroupFilteringSelector, this.filteringSelector]),
    groupLabels: this.groupLabels,
    instanceLabels: ['topic', 'consumergroup'],  // this.instanceLabels is ommitted, as it would point to kafka_exporter instance.
    aggLevel: 'group',
    aggFunction: 'avg',
    legendCustomTemplate: '{{ consumergroup }} ({{ topic }})',
    discoveryMetric: {
      prometheus: 'kafka_consumergroup_lag',  // https://github.com/danielqsj/kafka_exporter?tab=readme-ov-file#metrics
      grafanacloud: 'kafka_consumergroup_uncommitted_offsets',  // https://github.com/grafana/kafka_exporter/blob/master/exporter/exporter.go#L887
      bitnami: self.prometheus,
    },
    signals: {
      consumerGroupLag: {
        name: 'Consumer group lag',
        description: |||
          Number of messages a consumer group is behind the latest available offset for a topic partition.  
          High or growing lag indicates consumers can't keep up with producer throughput.  
          Critical metric for consumer health and real-time processing requirements.
        |||,
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
            expr: 'kafka_consumergroup_uncommitted_offsets{%(queriesSelector)s}',
          },
          bitnami: self.prometheus,
        },
      },

      consumerGroupLagTime: {
        name: 'Consumer group lag in ms',
        description: |||
          Time lag in milliseconds between message production and consumption for a consumer group.  
          Represents real-time delay in message processing.  
          More intuitive than message count lag for understanding business impact of delays.
        |||,
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
        description: |||
          Rate at which a consumer group is consuming and committing offsets for a topic.  
          Measures consumer throughput and processing speed.  
          Should match or exceed producer rate to prevent growing lag.
        |||,
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            aggKeepLabels: ['consumergroup', 'topic'],
            expr: 'kafka_consumergroup_current_offset{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
          bitnami: self.prometheus,
        },

      },
    },
  }
