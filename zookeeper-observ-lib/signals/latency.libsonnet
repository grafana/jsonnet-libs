local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'min_latency',
      grafanacloud: 'zookeeper_minrequestlatency',
    },
    signals: {
      minLatency: {
        name: 'Latency(min)',
        description: 'Amount of time it takes for the server to respond to a client request.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'min_latency{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: |||
              zookeeper_minrequestlatency{%(queriesSelector)s}
                * ignoring (minrequestlatency,ticktime)
              zookeeper_ticktime{%(queriesSelector)s}
            |||,
          },
        },
      },
      maxLatency: {
        name: 'Latency(max)',
        description: 'Amount of time it takes for the server to respond to a client request.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'max_latency{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: |||
              zookeeper_maxrequestlatency{%(queriesSelector)s}
                * ignoring (maxrequestlatency,ticktime)
              zookeeper_ticktime{%(queriesSelector)s}
            |||,
          },
        },
      },
      avgLatency: {
        name: 'Latency(avg)',
        description: 'Amount of time it takes for the server to respond to a client request.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg_latency{%(queriesSelector)s}',
          },
          grafanacloud: {
            expr: |||
              zookeeper_avgrequestlatency{%(queriesSelector)s}
                * ignoring (avgrequestlatency,ticktime)
              zookeeper_ticktime{%(queriesSelector)s}
            |||,
          },
        },
      },
    },
  }
