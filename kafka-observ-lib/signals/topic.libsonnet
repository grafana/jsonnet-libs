local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: std.join(',', [this.topicsFilteringSelector, this.filteringSelector]),
    groupLabels: this.groupLabels,
    instanceLabels: ['topic'],  // this.instanceLabels is ommitted, as it would point to kafka_exporter instance.
    aggLevel: 'group',
    aggFunction: 'sum',
    legendCustomTemplate: '{{ topic }}',
    discoveryMetric: {
      prometheus: 'kafka_log_log_logstartoffset',  //https://github.com/danielqsj/kafka_exporter?tab=readme-ov-file#metrics
      grafanacloud: self.prometheus,
      bitnami: 'kafka_log_log_logstartoffset',
    },
    signals: {
      topicMessagesPerSec: {
        name: 'Messages in per second',
        description: 'Messages in per second.',
        type: 'counter',
        unit: 'mps',
        sources: {
          prometheus: {
            aggKeepLabels: ['topic'],
            expr: 'kafka_topic_partition_current_offset{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
          bitnami: self.prometheus,
        },
      },
      // used in table:
      topicMessagesPerSecByPartition: {
        name: 'Messages in per second',
        description: 'Messages in per second.',
        type: 'counter',
        unit: 'mps',
        legendCustomTemplate: '{{ topic }}/{{ partition }}',
        sources: {
          prometheus: {
            aggKeepLabels: ['topic', 'partition'],
            expr: 'kafka_topic_partition_current_offset{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
          bitnami: self.prometheus,
        },
      },
      // JMX exporter extras
      topicBytesInPerSec: {
        name: 'Topic bytes in',
        description: 'Topic bytes in rate.',
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            aggKeepLabels: ['topic'],
            expr: 'kafka_server_brokertopicmetrics_bytesin_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            aggKeepLabels: ['topic'],
            expr: 'kafka_server_brokertopicmetrics_bytesinpersec{%(queriesSelector)s}',
          },
          bitnami: {
            aggKeepLabels: ['topic'],
            expr: 'kafka_server_brokertopicmetrics_bytesinpersec_count{%(queriesSelector)s}',
          },
        },
      },
      topicBytesOutPerSec: {
        name: 'Topic bytes out',
        description: 'Topic bytes out rate.',
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            aggKeepLabels: ['topic'],
            expr: 'kafka_server_brokertopicmetrics_bytesout_total{%(queriesSelector)s}',
          },
          grafanacloud: {
            aggKeepLabels: ['topic'],
            expr: 'kafka_server_brokertopicmetrics_bytesoutpersec{%(queriesSelector)s}',
          },
          bitnami: {
            aggKeepLabels: ['topic'],
            expr: 'kafka_server_brokertopicmetrics_bytesoutpersec_count{%(queriesSelector)s}',
          },
        },
      },
      topicLogStartOffset: {
        name: 'Topic start offset',
        description: 'Topic start offset.',
        type: 'gauge',
        unit: 'none',
        aggFunction: 'max',
        legendCustomTemplate: '{{ topic }}/{{ partition }}',
        sources: {
          prometheus: {
            aggKeepLabels: ['topic', 'partition'],
            expr: 'kafka_log_log_logstartoffset{%(queriesSelector)s}',
          },
          grafanacloud: {
            aggKeepLabels: ['topic', 'partition'],
            expr: 'kafka_log_log_logstartoffset{%(queriesSelector)s}',
          },
          bitnami: {
            aggKeepLabels: ['topic', 'partition'],
            expr: 'kafka_log_log_logstartoffset{%(queriesSelector)s}',
          },
        },
      },
      topicLogEndOffset: {
        name: 'Topic end offset',
        description: 'Topic end offset.',
        type: 'gauge',
        unit: 'none',
        aggFunction: 'max',
        legendCustomTemplate: '{{ topic }}/{{ partition }}',
        sources: {
          prometheus: {

            aggKeepLabels: ['topic', 'partition'],
            expr: 'kafka_log_log_logendoffset{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
          bitnami: self.prometheus,
        },
      },
      topicLogSize: {
        name: 'Topic log size',
        description: 'Size in bytes of the current topic-partition.',
        type: 'gauge',
        unit: 'decbytes',
        aggFunction: 'max',
        legendCustomTemplate: '{{ topic }}/{{ partition }}',
        sources: {
          prometheus: {
            aggKeepLabels: ['topic', 'partition'],
            expr: 'kafka_log_log_size{%(queriesSelector)s}',
          },
          grafanacloud: self.prometheus,
          bitnami: self.prometheus,
        },
      },

    },
  }
