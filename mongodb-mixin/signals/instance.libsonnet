function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,

    aggLevel: 'instance',
    aggFunction: 'avg',
    aggKeepLabels: ['instance'],
    discoveryMetric: {
      percona_mongodb: 'mongodb_up',
    },
    signals: {
      uptime: {
        name: 'Uptime',
        description: 'The uptime of the MongoDB instance.',
        type: 'gauge',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_instance_uptime_seconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      replicaSetState: {
        name: 'Replica set state',
        description: 'An integer between 0 and 10 that represents the replica state of the current member. See https://www.mongodb.com/docs/manual/reference/replica-states/ for the meaning of each value.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_replset_my_state{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      qps: {
        name: 'QPS',
        description: 'Queries per second.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              sum by (instance) (
                irate(mongodb_mongod_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])
                or irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      commandLatency: {
        name: 'Command latency',
        description: 'Average command latency in microseconds.',
        type: 'raw',
        unit: 'µs',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_op_latencies_latency_total{%(queriesSelector)s, type="command"}[$__rate_interval]) / (irate(mongodb_mongod_op_latencies_ops_total{%(queriesSelector)s, type="command"}[$__rate_interval]) > 0))',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      connectionsCurrent: {
        name: 'Current connections',
        description: 'The number of current connections to the MongoDB instance.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_connections{%(queriesSelector)s, state="current"} or mongodb_mongos_connections{%(queriesSelector)s, state="current"} or mongodb_connections{%(queriesSelector)s, state="current"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
      // Performance signals
      opCountersTotal: {
        name: 'Operations by type',
        description: 'Operations per second by type. Series that stay at zero over the range are hidden.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s, type) (
                irate(mongodb_mongod_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])
                or irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])
              )
              and
              avg by (%(agg)s, type) (
                increase(mongodb_mongod_op_counters_total{%(queriesSelector)s, type!="command"}[$__range])
                or increase(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__range])
              ) > 0
            |||,
            legendCustomTemplate: '{{instance}} - {{type}}',
          },
        },
      },
      opCountersReplTotal: {
        name: 'Replication operations',
        description: 'Replication operations per second by type. Series that stay at zero over the range are hidden.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s, type) (
                irate(mongodb_mongod_op_counters_repl_total{%(queriesSelector)s, type!~"(command|query|getmore)"}[$__rate_interval])
                or irate(mongodb_mongos_op_counters_repl_total{%(queriesSelector)s, type!~"(command|query|getmore)"}[$__rate_interval])
              )
              and
              avg by (%(agg)s, type) (
                increase(mongodb_mongod_op_counters_repl_total{%(queriesSelector)s, type!~"(command|query|getmore)"}[$__range])
                or increase(mongodb_mongos_op_counters_repl_total{%(queriesSelector)s, type!~"(command|query|getmore)"}[$__range])
              ) > 0
            |||,
            legendCustomTemplate: '{{instance}} - {{type}}',
          },
        },
      },
      ttlDeletedDocuments: {
        name: 'Documents deleted by TTL',
        description: 'Rate of documents deleted by TTL indexes.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s) (
                irate(mongodb_mongod_metrics_ttl_deleted_documents_total{%(queriesSelector)s}[$__rate_interval])
                or irate(mongodb_mongos_metrics_ttl_deleted_documents_total{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{instance}} - TTL deleted',
          },
        },
      },
      documentOps: {
        name: 'Document operations',
        description: 'Document operations per second by state. Series that stay at zero over the range are hidden.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s, state) (irate(mongodb_mongod_metrics_document_total{%(queriesSelector)s}[$__rate_interval]))
              and
              avg by (%(agg)s, state) (increase(mongodb_mongod_metrics_document_total{%(queriesSelector)s}[$__range])) > 0
            |||,
            legendCustomTemplate: '{{instance}} - {{state}}',
          },
        },
      },
      latencyDetail: {
        name: 'Latency detail',
        description: 'Average operation latency by type in microseconds.',
        type: 'raw',
        unit: 'µs',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, type) (irate(mongodb_mongod_op_latencies_latency_total{%(queriesSelector)s}[$__rate_interval]) / (irate(mongodb_mongod_op_latencies_ops_total{%(queriesSelector)s}[$__rate_interval]) > 0))',
            legendCustomTemplate: '{{instance}} - {{type}}',
          },
        },
      },
      queuedOps: {
        name: 'Queued operations',
        description: 'Number of operations queued due to a lock. Series that stay at zero over the range are hidden.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s) (mongodb_mongod_global_lock_current_queue{%(queriesSelector)s})
              and
              avg by (%(agg)s) (max_over_time(mongodb_mongod_global_lock_current_queue{%(queriesSelector)s}[$__range])) > 0
            |||,
            legendCustomTemplate: '{{instance}} - {{type}}',
            aggKeepLabels: ['type', 'instance'],
          },
        },
      },
      cursorsOpen: {
        name: 'Cursors',
        description: 'Number of open cursors by state. Series that stay at zero over the range are hidden.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s) (
                mongodb_mongod_metrics_cursor_open{%(queriesSelector)s}
                or mongodb_mongod_cursors{%(queriesSelector)s}
                or mongodb_mongos_metrics_cursor_open{%(queriesSelector)s}
                or mongodb_mongos_cursors{%(queriesSelector)s}
              )
              and
              avg by (%(agg)s) (
                max_over_time(mongodb_mongod_metrics_cursor_open{%(queriesSelector)s}[$__range])
                or max_over_time(mongodb_mongod_cursors{%(queriesSelector)s}[$__range])
                or max_over_time(mongodb_mongos_metrics_cursor_open{%(queriesSelector)s}[$__range])
                or max_over_time(mongodb_mongos_cursors{%(queriesSelector)s}[$__range])
              ) > 0
            |||,
            legendCustomTemplate: '{{instance}} - {{state}}',
            aggKeepLabels: ['state', 'instance'],
          },
        },
      },
      queryExecutor: {
        name: 'Scanned and moved objects',
        description: 'Rate of index keys and documents scanned by the query executor. Series that stay at zero over the range are hidden.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s, state) (irate(mongodb_mongod_metrics_query_executor_total{%(queriesSelector)s}[$__rate_interval]))
              and
              avg by (%(agg)s, state) (increase(mongodb_mongod_metrics_query_executor_total{%(queriesSelector)s}[$__range])) > 0
            |||,
            legendCustomTemplate: '{{instance}} - {{state}}',
          },
        },
      },
      recordMoves: {
        name: 'Record moves',
        description: 'Rate of record moves.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (rate(mongodb_mongod_metrics_record_moves_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{instance}} - moved',
          },
        },
      },
      asserts: {
        name: 'Assert events',
        description: 'Rate of assert events by type. Series that stay at zero over the range are hidden.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s, type) (
                irate(mongodb_mongod_asserts_total{%(queriesSelector)s}[$__rate_interval])
                or irate(mongodb_mongos_asserts_total{%(queriesSelector)s}[$__rate_interval])
                or irate(mongodb_asserts_total{%(queriesSelector)s}[$__rate_interval])
              )
              and
              avg by (%(agg)s, type) (
                increase(mongodb_mongod_asserts_total{%(queriesSelector)s}[$__range])
                or increase(mongodb_mongos_asserts_total{%(queriesSelector)s}[$__range])
                or increase(mongodb_asserts_total{%(queriesSelector)s}[$__range])
              ) > 0
            |||,
            legendCustomTemplate: '{{instance}} - {{type}}',
          },
        },
      },
      getLastErrorNum: {
        name: 'getLastError write operations',
        description: 'Rate of getLastError write operations.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s) (
                irate(mongodb_mongod_metrics_get_last_error_wtime_num_total{%(queriesSelector)s}[$__rate_interval])
                or irate(mongodb_mongos_metrics_get_last_error_wtime_num_total{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{instance}} - Total',
          },
        },
      },
      getLastErrorTimeouts: {
        name: 'getLastError write timeouts',
        description: 'Rate of getLastError write timeouts.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s) (
                irate(mongodb_mongod_metrics_get_last_error_wtimeouts_total{%(queriesSelector)s}[$__rate_interval])
                or irate(mongodb_mongos_metrics_get_last_error_wtimeouts_total{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{instance}} - Timeouts',
          },
        },
      },
      queryEfficiencyDoc: {
        name: 'Query efficiency - documents',
        description: 'Ratio of documents returned to scanned objects.',
        type: 'raw',
        unit: 'percentunit',
        sources: {
          percona_mongodb: {
            expr: 'sum(irate(mongodb_mongod_metrics_document_total{%(queriesSelector)s, state="returned"}[$__rate_interval])) / sum(irate(mongodb_mongod_metrics_query_executor_total{%(queriesSelector)s, state="scanned_objects"}[$__rate_interval]))',
            legendCustomTemplate: 'Document',
          },
        },
      },
      queryEfficiencyIndex: {
        name: 'Query efficiency - index',
        description: 'Ratio of index keys scanned to scanned objects.',
        type: 'raw',
        unit: 'percentunit',
        sources: {
          percona_mongodb: {
            expr: 'sum(irate(mongodb_mongod_metrics_query_executor_total{%(queriesSelector)s, state="scanned"}[$__rate_interval])) / sum(irate(mongodb_mongod_metrics_query_executor_total{%(queriesSelector)s, state="scanned_objects"}[$__rate_interval]))',
            legendCustomTemplate: 'Index',
          },
        },
      },
      getLastErrorWriteTime: {
        name: 'getLastError write time',
        description: 'Rate of getLastError write time.',
        type: 'raw',
        unit: 'ms',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s) (
                irate(mongodb_mongod_metrics_get_last_error_wtime_total_milliseconds{%(queriesSelector)s}[$__rate_interval])
                or irate(mongodb_mongos_metrics_get_last_error_wtime_total_milliseconds{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{instance}} - Write wait time',
          },
        },
      },
      pageFaults: {
        name: 'Page faults',
        description: 'Rate of page faults. Series that stay at zero over the range are hidden.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: |||
              avg by (%(agg)s) (
                irate(mongodb_mongod_extra_info_page_faults_total{%(queriesSelector)s}[$__rate_interval])
                or irate(mongodb_mongos_extra_info_page_faults_total{%(queriesSelector)s}[$__rate_interval])
                or irate(mongodb_extra_info_page_faults_total{%(queriesSelector)s}[$__rate_interval])
              )
              and
              avg by (%(agg)s) (
                increase(mongodb_mongod_extra_info_page_faults_total{%(queriesSelector)s}[$__range])
                or increase(mongodb_mongos_extra_info_page_faults_total{%(queriesSelector)s}[$__range])
                or increase(mongodb_extra_info_page_faults_total{%(queriesSelector)s}[$__range])
              ) > 0
            |||,
            legendCustomTemplate: '{{instance}} - Faults',
          },
        },
      },
    },
  }
