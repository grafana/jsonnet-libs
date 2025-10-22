function(this) {
  local legendCustomTemplate = '{{ instance }}',
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  discoveryMetric: {
    prometheus: 'tomcat_session_sessioncounter_total',
  },

  signals: {
    numberOfClusters: {
      name: 'Number of clusters',
      nameShort: 'Clusters',
      type: 'raw',
      description: 'The number of Apache Tomcat clusters.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'count(count by (cassandra_cluster) (jvm_memory_usage_used_bytes{%(queriesSelector)s}))',
        },
      },
    },

    numberOfNodes: {
      name: 'Number of nodes',
      nameShort: 'Nodes',
      type: 'raw',
      description: 'The number of Apache Tomcat nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'count(count by (instance) (jvm_memory_usage_used_bytes{%(queriesSelector)s}))',
        },
      },
    },

    memoryUtilization: {
      name: 'Memory utilization',
      nameShort: 'Memory utilization',
      type: 'raw',
      description: 'The total memory utilization of the JVM of the instance.',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'sum(jvm_memory_usage_used_bytes{%(queriesSelector)s}) by (job, instance) / clamp_min(jvm_physical_memory_bytes{%(queriesSelector)s}, 1) * 100',
        },
      },
    },

    memoryUsage: {
      name: 'Memory usage',
      nameShort: 'Memory usage',
      type: 'gauge',
      description: 'The memory usage of the JVM of the instance.',
      unit: 'bytes',
      sources: {
        prometheus: {
          expr: 'jvm_memory_usage_used_bytes{%(queriesSelector)s}',
          legendCustomTemplate: legendCustomTemplate + ' - {{area}}',
        },
      },
    },

    cpuUsage: {
      name: 'CPU usage',
      nameShort: 'CPU usage',
      type: 'gauge',
      description: 'The CPU usage of the JVM of the instance.',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'jvm_process_cpu_load{%(queriesSelector)s} * 100',
          legendCustomTemplate: legendCustomTemplate,
        },
      },
    },

    trafficSentTotal: {
      name: 'Traffic sent total',
      nameShort: 'Traffic sent total',
      type: 'raw',
      description: 'The total traffic sent by the instance.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'sum(rate(tomcat_bytessent_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}[$__rate_interval])) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total',
        },
      },
    },

    trafficSentRate: {
      name: 'Traffic sent rate',
      nameShort: 'Traffic sent rate',
      type: 'counter',
      description: 'The rate of traffic sent by the instance.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'tomcat_bytessent_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}}',
        },
      },
    },

    trafficReceivedTotal: {
      name: 'Traffic received total',
      nameShort: 'Traffic received total',
      type: 'raw',
      description: 'The total traffic received by the instance.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'sum(rate(tomcat_bytesreceived_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}[$__rate_interval])) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total',
        },
      },
    },

    trafficReceivedRate: {
      name: 'Traffic received rate',
      nameShort: 'Traffic received rate',
      type: 'counter',
      description: 'The rate of traffic received by the instance.',
      unit: 'Bps',
      sources: {
        prometheus: {
          expr: 'tomcat_bytesreceived_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}}',
        },
      },
    },


    requestsTotal: {
      name: 'Requests total',
      nameShort: 'Requests total',
      type: 'raw',
      description: 'The total number of requests by the instance.',
      unit: 'r/s',
      sources: {
        prometheus: {
          expr: 'sum(rate(tomcat_requestcount_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}[$__rate_interval])) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total requests',
        },
      },
    },

    requestsErrors: {
      name: 'Requests errors',
      nameShort: 'Requests errors',
      type: 'raw',
      description: 'The total number of requests errors by the instance.',
      unit: 'r/s',
      sources: {
        prometheus: {
          expr: 'sum(rate(tomcat_errorcount_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}[$__rate_interval])) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total errors',
        },
      },
    },

    requestsRate: {
      name: 'Requests rate',
      nameShort: 'Requests rate',
      type: 'counter',
      description: 'The rate of requests by the instance.',
      unit: 'r/s',
      sources: {
        prometheus: {
          expr: 'tomcat_requestcount_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}} - requests',
        },
      },
    },

    requestsErrorsRate: {
      name: 'Requests errors rate',
      nameShort: 'Requests errors rate',
      type: 'counter',
      description: 'The rate of requests errors by the instance.',
      unit: 'r/s',
      sources: {
        prometheus: {
          expr: 'tomcat_errorcount_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}} - errors',
        },
      },
    },

    processingTimeTotal: {
      name: 'Processing time total',
      nameShort: 'Processing time total',
      type: 'raw',
      description: 'The total processing time by the tomcat connector.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'sum(increase(tomcat_processingtime_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}[$__interval:] offset -$__interval) / clamp_min(increase(tomcat_requestcount_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}[$__interval:] offset -$__interval), 1)) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total',
        },
      },
    },

    processingTimeRate: {
      name: 'Processing time rate',
      nameShort: 'Processing time rate',
      type: 'raw',
      description: 'The rate of processing time by the instance.',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'increase(tomcat_processingtime_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}[$__interval:] offset -$__interval) / clamp_min(increase(tomcat_requestcount_total{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}[$__interval:] offset -$__interval), 1)',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}}',
        },
      },
    },

    totalConnectionThreads: {
      name: 'Total connection threads',
      nameShort: 'Total connection threads',
      type: 'raw',
      description: 'The total number of connection threads by the tomcat connector.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum(tomcat_threadpool_connectioncount{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - total connections',
        },
      },
    },

    totalPollerThreads: {
      name: 'Total poller threads',
      nameShort: 'Total poller threads',
      type: 'raw',
      description: 'The total number of poller threads by the tomcat connector.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum(tomcat_threadpool_pollerthreadcount{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - poller total',
        },
      },
    },

    totalIdleThreads: {
      name: 'Total idle threads',
      nameShort: 'Total idle threads',
      type: 'raw',
      description: 'The total number of idle threads by the tomcat connector.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum(tomcat_threadpool_keepalivecount{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - idle total',
        },
      },
    },

    totalActiveThreads: {
      name: 'Total active threads',
      nameShort: 'Total active threads',
      type: 'raw',
      description: 'The total number of active threads by the tomcat connector.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'sum(tomcat_threadpool_currentthreadcount{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}) by (job, instance)',
          legendCustomTemplate: legendCustomTemplate + ' - active total',
        },
      },
    },

    connectionThreads: {
      name: 'Connection threads',
      nameShort: 'Connection threads',
      type: 'gauge',
      description: 'The number of connection threads by the tomcat connector.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'tomcat_threadpool_connectioncount{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}} - connections',
        },
      },
    },

    pollerThreads: {
      name: 'Poller threads',
      nameShort: 'Poller threads',
      type: 'gauge',
      description: 'The number of poller threads by the tomcat connector.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'tomcat_threadpool_pollerthreadcount{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}} - poller',
        },
      },
    },

    idleThreads: {
      name: 'Idle threads',
      nameShort: 'Idle threads',
      type: 'gauge',
      description: 'The number of idle threads by the tomcat connector.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'tomcat_threadpool_keepalivecount{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}} - idle',
        },
      },
    },

    activeThreads: {
      name: 'Active threads',
      nameShort: 'Active threads',
      type: 'gauge',
      description: 'The number of active threads by the tomcat connector.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'tomcat_threadpool_currentthreadcount{%(queriesSelector)s, protocol=~"$protocol", port=~"$port"}',
          legendCustomTemplate: legendCustomTemplate + ' - {{protocol}} - {{port}} - active',
        },
      },
    },
  },
}
