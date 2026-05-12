function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    enableLokiLogs: this.enableLokiLogs,

    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      percona_mongodb: 'mongodb_up',
    },
    signals: {
      totalInstances: {
        name: 'Total instances',
        description: 'Total number of MongoDB instances.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'count(mongodb_up{%(queriesSelector)s})',
          },
        },
      },
      instancesUp: {
        name: 'Instances up',
        description: 'Number of MongoDB instances that are up.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'count(mongodb_up{%(queriesSelector)s} == 1) or vector(0)',
          },
        },
      },
      instancesDown: {
        name: 'Instances down',
        description: 'Number of MongoDB instances that are down.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'count(mongodb_up{%(queriesSelector)s} == 0) or vector(0)',
          },
        },
      },
      totalConnections: {
        name: 'Total connections',
        description: 'Total current connections across all instances.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'sum(mongodb_connections{%(queriesSelector)s, state="current"})',
          },
        },
      },
      totalOps: {
        name: 'Total operations',
        description: 'Total operations per second across all instances.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              sum(
                irate(mongodb_mongod_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])
                or irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])
              )
            |||,
          },
        },
      },
      maxReplicationLag: {
        name: 'Max replication lag',
        description: 'Maximum replication lag across all secondaries.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'max(mongodb_mongod_replset_member_replication_lag{%(queriesSelector)s})',
          },
        },
      },
      // Per-instance signals for timeSeries
      connectionsByInstance: {
        name: 'Connections',
        description: 'Current connections per instance.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'sum by (%(agg)s, service_name) (mongodb_connections{%(queriesSelector)s, state="current"})',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      opsByInstance: {
        name: 'Operations',
        description: 'Operations per second per instance.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              sum by (%(agg)s, service_name) (
                irate(mongodb_mongod_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])
                or irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      replicationLagByInstance: {
        name: 'Replication lag',
        description: 'Replication lag per instance.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'max by (%(agg)s, service_name) (mongodb_mongod_replset_member_replication_lag{%(queriesSelector)s})',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      replicaSetStateByInstance: {
        name: 'Replica set state',
        description: 'Replica set state per instance.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_replset_my_state{%(queriesSelector)s}',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
    },
  }
