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
        description: |||
          Rate of messages produced to this topic across all partitions.  
          Indicates topic write activity and producer throughput.  
          Use to identify hot topics and understand data flow patterns.
        |||,
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
        description: |||
          Rate of messages produced to each partition within this topic.  
        |||,
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
        description: |||
          Rate of incoming data in bytes written to this topic from producers.  
        |||,
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
        description: |||
          Rate of outgoing data in bytes read from this topic by consumers.  
        |||,
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
        description: |||
          Earliest available offset for each partition due to retention or deletion.  
        |||,
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
        description: |||
          Latest offset (high water mark) for each partition representing newest available message.  
          Continuously increases as new messages arrive.  
          Difference between end and start offsets indicates total messages available.
        |||,
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
        description: |||
          Total size in bytes of data stored on disk for each topic partition.  
          Grows with incoming messages and shrinks with retention cleanup.  
        |||,
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
