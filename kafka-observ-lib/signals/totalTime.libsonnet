local commonlib = import 'common-lib/common/main.libsonnet';

// TotalTimeMs metric
function(this)
  {
    filteringSelector: this.filteringSelector + ', quantile="%s"' % this.totalTimeMsQuantile,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'kafka_network_requestmetrics_requestqueuetimems',
      grafanacloud: self.prometheus,
    },
    signals: {

      local commonRequestQueueDescription = |||
        A high value can imply there aren't enough IO threads or the CPU is a bottleneck, 
        or the request queue isnt large enough. The request queue size should match the number of connections.
      |||,

      local commonLocalDescription = |||
        In most cases, a high value can imply slow local storage or the storage is a bottleneck. One should also investigate LogFlushRateAndTimeMs to know how long page flushes are taking, which will also indicate a slow disk. In the case of FetchFollower requests, time spent in LocalTimeMs can be the result of a ZooKeeper write to change the ISR.
      |||,

      local commonRemoteDesription = |||
        A high value can imply a slow network connection. For fetch request, if the remote time is high, it could be that there is not enough data to give in a fetch response. This can happen when the consumer or replica is caught up and there is no new incoming data. If this is the case, remote time will be close to the max wait time, which is normal. Max wait time is configured via replica.fetch.wait.max.ms and fetch.max.wait.ms. 
      |||,

      local commonResponseQueueDescription = |||
        A high value can imply there aren't enough network threads or the network cant dequeue responses quickly enough, causing back pressure in the response queue. 
      |||,

      local commonResponseDescription = |||
        A high value can imply the zero-copy from disk to the network is slow, or the network is the bottleneck because the network cant dequeue responses of the TCP socket as quickly as theyre being created. If the network buffer gets full, Kafka will block. 
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
        },
      },
      fetchRemoteTime: {
        name: 'Fetch-consumer remote time',
        description: "Time spent waiting for follower response (only when 'require acks' is set)."
                     + '\n' + commonRemoteDesription,
        type: 'gauge',
        unit: 'ms',

        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_remotetimems{%(queriesSelector)s, request="Fetch"}',
            legendCustomTemplate: 'remote time',
          },
          grafanacloud: self.prometheus,
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
        },
      },
      fetchFollowerRemoteTime: {
        name: 'Fetch-follower remote time',
        description: "Time spent waiting for follower response (only when 'require acks' is set)."
                     + '\n' + commonRemoteDesription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_remotetimems{%(queriesSelector)s, request="FetchFollower"}',
            legendCustomTemplate: 'remote time',
          },
          grafanacloud: self.prometheus,
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
        },
      },
      producerRemoteTime: {
        name: 'Produce follower remote time',
        description: "Time spent waiting for follower response (only when 'require acks' is set)."
                     + '\n' + commonRemoteDesription,
        type: 'gauge',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'kafka_network_requestmetrics_remotetimems{%(queriesSelector)s, request="Produce"}',
            legendCustomTemplate: 'remote time',
          },
          grafanacloud: self.prometheus,
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
        },
      },
    },
  }
