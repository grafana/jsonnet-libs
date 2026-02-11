local commonlib = import 'common-lib/common/main.libsonnet';

// TotalTimeMs metric
function(this)
  {
    filteringSelector: ('quantile="%s"' % this.totalTimeMsQuantile) + ',' + this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: if this.totalTimeMetricsRepeat then 'instance' else 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'kafka_network_requestmetrics_requestqueuetimems',
      grafanacloud: self.prometheus,
      bitnami: 'kafka_network_requestmetrics_requestqueuetimems_count',
    },
    signals: {

      local commonRequestQueueDescription = |||
        High values indicate insufficient IO threads, CPU bottlenecks, or undersized request queue.  
        Queue size should match connection count.
      |||,

      local commonLocalDescription = |||
        High values often indicate slow storage or disk bottlenecks.  
        Check LogFlushRateAndTimeMs for disk performance issues.
      |||,

      local commonRemoteDescription = |||
        For fetch requests, high values may indicate caught-up consumers with no new data (normal if near max wait time).  
        Configure via replica.fetch.wait.max.ms and fetch.max.wait.ms.
      |||,

      local commonResponseQueueDescription = |||
        High values indicate insufficient network threads or slow network dequeue causing backpressure.
      |||,

      local commonResponseDescription = |||
        High values indicate slow zero-copy operations or network saturation.  
        Network buffer fullness can cause Kafka to block.
      |||,

      fetchQueueTime: {
        name: 'Fetch-consumer queue time',
        description: 'Time spent waiting in the request queue.' + '\n' + commonRequestQueueDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_requestqueuetimems{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'request queue time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_requestqueuetimems_count{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'request queue time',
          },
        },
      },
      fetchLocalTime: {
        name: 'Fetch-consumer local time',
        description: 'Time spent being processed by leader.' + '\n' + commonLocalDescription,
        type: 'gauge',
        unit: 'ms',

        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_localtimems{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'local time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_localtimems_count{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'local time',
          },
        },
      },
      fetchRemoteTime: {
        name: 'Fetch-consumer remote time',
        description: "Time spent waiting for follower response (only when 'require acks' is set)."
                     + '\n' + commonRemoteDescription,
        type: 'gauge',
        unit: 'ms',

        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_remotetimems{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'remote time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_remotetimems_count{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'remote time',
          },
        },
      },
      fetchResponseQueue: {
        name: 'Fetch-consumer response queue time',
        description: 'Time spent waiting in the response queue.' + '\n' + commonResponseQueueDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_responsequeuetimems{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'response queue time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_responsequeuetimems_count{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'response queue time',
          },
        },
      },
      fetchResponseTime: {
        name: 'Fetch-consumer response time',
        description: 'Time to send the response.' + '\n' + commonResponseDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_responsesendtimems{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'response time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_responsesendtimems_count{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'response time',
          },
        },
      },

      //fetch follower
      fetchFollowerQueueTime: {
        name: 'Fetch-follower queue time',
        description: 'Time spent waiting in the request queue.' + '\n' + commonRequestQueueDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_requestqueuetimems{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'request queue time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_requestqueuetimems_count{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'request queue time',
          },
        },
      },
      fetchFollowerLocalTime: {
        name: 'Fetch-follower local time',
        description: 'Time spent being processed by leader.' + '\n' + commonLocalDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_localtimems{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'local time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_localtimems_count{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'local time',
          },
        },
      },
      fetchFollowerRemoteTime: {
        name: 'Fetch-follower remote time',
        description: "Time spent waiting for follower response (only when 'require acks' is set)."
                     + '\n' + commonRemoteDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_remotetimems{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'remote time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_remotetimems_count{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'remote time',
          },
        },
      },
      fetchFollowerResponseQueue: {
        name: 'Fetch-follower response queue time',
        description: 'Time spent waiting in the response queue.' + '\n' + commonResponseQueueDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_responsequeuetimems{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'response queue time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_responsequeuetimems_count{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'response queue time',
          },
        },
      },
      fetchFollowerResponseTime: {
        name: 'Fetch-follower response time',
        description: 'Time to send the response.' + '\n' + commonResponseDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_responsesendtimems{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'response time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_responsesendtimems_count{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'response time',
          },
        },
      },

      //produce
      producerQueueTime: {
        name: 'Produce follower queue time',
        description: 'Time spent waiting in the request queue.' + '\n' + commonRequestQueueDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_requestqueuetimems{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'request queue time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_requestqueuetimems_count{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'request queue time',
          },
        },
      },
      producerLocalTime: {
        name: 'Produce follower local time',
        description: 'Time spent being processed by leader.' + '\n' + commonLocalDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_localtimems{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'local time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_localtimems_count{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'local time',
          },
        },
      },
      producerRemoteTime: {
        name: 'Produce follower remote time',
        description: "Time spent waiting for follower response (only when 'require acks' is set)."
                     + '\n' + commonRemoteDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_remotetimems{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'remote time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_remotetimems_count{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'remote time',
          },
        },
      },
      producerResponseQueue: {
        name: 'Produce follower response queue time',
        description: 'Time spent waiting in the response queue.' + '\n' + commonResponseQueueDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_responsequeuetimems{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'response queue time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_responsequeuetimems_count{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'response queue time',
          },
        },
      },
      producerResponseTime: {
        name: 'Produce follower response time',
        description: 'Time to send the response.' + '\n' + commonResponseDescription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_responsesendtimems{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'response time',
          },
          grafanacloud: self.prometheus,
          bitnami: {
            expr: 'kafka_network_requestmetrics_responsesendtimems_count{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'response time',
          },
        },
      },
    },
  }
