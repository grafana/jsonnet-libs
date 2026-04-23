function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,

    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      percona_mongodb: 'mongodb_mongod_replset_my_state',
    },
    signals: {
      // Overview signals
      replsetMembers: {
        name: 'Replica set members',
        description: 'Number of replica set members.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'count by (set) (mongodb_mongod_replset_number_of_members{%(queriesSelector)s} or mongodb_mongod_replset_my_state{%(queriesSelector)s})',
          },
        },
      },
      lastElection: {
        name: 'Last election',
        description: 'Time since last replica set election.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'time() - max(mongodb_mongod_replset_member_election_date{%(queriesSelector)s})',
          },
        },
      },
      avgReplicationLag: {
        name: 'Average replica set lag',
        description: 'Average replication lag across secondary members.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'avg by (set) (max_over_time(mongodb_mongod_replset_member_replication_lag{%(queriesSelector)s}[${__range}]))',
          },
        },
      },
      versionInfo: {
        name: 'MongoDB versions',
        description: 'MongoDB server version information.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, mongodb) (mongodb_version_info{%(queriesSelector)s})',
          },
        },
      },
      replsetStates: {
        name: 'Replica set states',
        description: 'Current state of each replica set member.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'max by (set, %(agg)s) (mongodb_mongod_replset_my_state{%(queriesSelector)s})',
          },
        },
      },
      // Performance signals
      replicationLag: {
        name: 'Replication lag',
        description: 'Replication lag per secondary member.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'avg by (name) (max(max_over_time(mongodb_mongod_replset_member_replication_lag{%(queriesSelector)s}[$__rate_interval])) by (name, %(agg)s, set))',
            legendCustomTemplate: '{{name}}',
          },
        },
      },
      replOpCountersRepl: {
        name: 'Replication operations',
        description: 'Replication operations per second.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, type) (irate(mongodb_op_counters_repl_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'repl - {{type}}',
          },
        },
      },
      replOpCountersMongod: {
        name: 'Replication operations (mongod)',
        description: 'Replication operations per second from mongod counters.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, type) (irate(mongodb_mongod_op_counters_repl_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'repl - {{type}}',
          },
        },
      },
      replOpCountersTotal: {
        name: 'Operations',
        description: 'Total operations per second.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, type) (irate(mongodb_op_counters_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{type}}',
          },
        },
      },
      elections: {
        name: 'Elections',
        description: 'Number of replica set elections.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'max by (%(agg)s) (changes(mongodb_mongod_replset_member_election_date{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      heartbeatTime: {
        name: 'Max heartbeat time',
        description: 'Time since last heartbeat from each member.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'time() - avg by (%(agg)s) (max(mongodb_mongod_replset_member_last_heartbeat{%(queriesSelector)s}) by (name)) * on (name) group_right avg by (%(agg)s) (mongodb_mongod_replset_my_name{%(queriesSelector)s})',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      memberPing: {
        name: 'Max member ping time',
        description: 'Round-trip packet time in milliseconds to each member.',
        type: 'raw',
        unit: 'ms',
        sources: {
          percona_mongodb: {
            expr: 'max by (%(agg)s, name, state) (mongodb_mongod_replset_member_ping_ms{%(queriesSelector)s} or label_replace(label_replace(mongodb_rs_members_pingMs{%(queriesSelector)s, member_state!=""}, "state", "$1", "member_state", "(.*)"), "name", "$1", "member_idx", "(.*)"))',
            legendCustomTemplate: '{{service_name}} - {{name}} - {{state}}',
          },
        },
      },
      // Oplog signals
      oplogBufferCount: {
        name: 'Oplog buffered operations',
        description: 'Number of operations in the oplog buffer.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_metrics_repl_buffer_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      oplogGetmoreTime: {
        name: 'Oplog getmore time',
        description: 'Rate of time spent on oplog getmore operations.',
        type: 'raw',
        unit: 'ms',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_repl_network_getmores_total_milliseconds{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      oplogRecoveryNowToEnd: {
        name: 'Oplog now to end',
        description: 'Time from now to the tail of the oplog.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'time() - avg by (%(agg)s) (mongodb_mongod_replset_oplog_tail_timestamp{%(queriesSelector)s})',
            legendCustomTemplate: 'Now to end',
          },
        },
      },
      oplogRecoveryRange: {
        name: 'Oplog range',
        description: 'Time range covered by the oplog.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (mongodb_mongod_replset_oplog_head_timestamp{%(queriesSelector)s} - mongodb_mongod_replset_oplog_tail_timestamp{%(queriesSelector)s})',
            legendCustomTemplate: 'Oplog range',
          },
        },
      },
      oplogProcessingDocPreload: {
        name: 'Document preload time',
        description: 'Rate of time spent preloading documents for oplog application.',
        type: 'raw',
        unit: 'ms',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_repl_preload_docs_total_milliseconds{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Document preload',
          },
        },
      },
      oplogProcessingIndexPreload: {
        name: 'Index preload time',
        description: 'Rate of time spent preloading indexes for oplog application.',
        type: 'raw',
        unit: 'ms',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_repl_preload_indexes_total_milliseconds{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Index preload',
          },
        },
      },
      oplogProcessingBatchApply: {
        name: 'Batch apply time',
        description: 'Rate of time spent applying oplog batches.',
        type: 'raw',
        unit: 'ms',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_repl_apply_batches_total_milliseconds{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Batch apply',
          },
        },
      },
      oplogOpsDocPreload: {
        name: 'Document preload ops',
        description: 'Rate of document preload operations.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_repl_preload_docs_num_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Document preload',
          },
        },
      },
      oplogOpsIndexPreload: {
        name: 'Index preload ops',
        description: 'Rate of index preload operations.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_repl_preload_indexes_num_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Index preload',
          },
        },
      },
      oplogOpsBatchApply: {
        name: 'Batch apply ops',
        description: 'Rate of batch apply operations.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_repl_apply_ops_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Batch apply',
          },
        },
      },
    },
  }
