function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,

    aggLevel: 'instance',
    aggFunction: 'avg',
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
          },
        },
      },
      replicaSetState: {
        name: 'Replica set state',
        description: 'An integer between 0 and 10 that represents the replica state of the current member.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_replset_my_state{%(queriesSelector)s}',
            legendCustomTemplate: '{{set}}',
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
            expr: 'sum(irate(mongodb_mongod_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval]) or irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval]))',
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
            legendCustomTemplate: 'Connections',
          },
        },
      },
      // Performance signals
      opCountersTotal: {
        name: 'Command operations',
        description: 'Operations per second by type.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, type) (irate(mongodb_mongod_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval]) or irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval]))',
            legendCustomTemplate: '{{type}}',
          },
        },
      },
      opCountersReplTotal: {
        name: 'Replication operations',
        description: 'Replication operations per second by type.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, type) (irate(mongodb_mongod_op_counters_repl_total{%(queriesSelector)s, type!~"(command|query|getmore)"}[$__rate_interval]) or irate(mongodb_mongos_op_counters_repl_total{%(queriesSelector)s, type!~"(command|query|getmore)"}[$__rate_interval]))',
            legendCustomTemplate: '{{type}}',
          },
        },
      },
      ttlDeletedDocuments: {
        name: 'TTL deleted documents',
        description: 'Rate of documents deleted by TTL indexes.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_ttl_deleted_documents_total{%(queriesSelector)s}[$__rate_interval]) or irate(mongodb_mongos_metrics_ttl_deleted_documents_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'ttl_delete',
          },
        },
      },
      documentOps: {
        name: 'Document operations',
        description: 'Document operations per second by state.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, state) (irate(mongodb_mongod_metrics_document_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{state}}',
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
            legendCustomTemplate: '{{type}}',
          },
        },
      },
      queuedOps: {
        name: 'Queued operations',
        description: 'Number of operations queued due to a lock.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_global_lock_current_queue{%(queriesSelector)s}',
            legendCustomTemplate: '{{type}}',
            aggKeepLabels: ['type'],
          },
        },
      },
      cursorsOpen: {
        name: 'Cursors',
        description: 'Number of open cursors by state.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_metrics_cursor_open{%(queriesSelector)s} or mongodb_mongod_cursors{%(queriesSelector)s} or mongodb_mongos_metrics_cursor_open{%(queriesSelector)s} or mongodb_mongos_cursors{%(queriesSelector)s}',
            legendCustomTemplate: '{{state}}',
            aggKeepLabels: ['state'],
          },
        },
      },
      queryExecutor: {
        name: 'Scanned and moved objects',
        description: 'Rate of scanned and scanned objects by the query executor.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, state) (irate(mongodb_mongod_metrics_query_executor_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{state}}',
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
            legendCustomTemplate: 'moved',
          },
        },
      },
      asserts: {
        name: 'Assert events',
        description: 'Rate of assert events by type.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s, type) (irate(mongodb_mongod_asserts_total{%(queriesSelector)s}[$__rate_interval]) or irate(mongodb_mongos_asserts_total{%(queriesSelector)s}[$__rate_interval]) or irate(mongodb_asserts_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{type}}',
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
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_get_last_error_wtime_num_total{%(queriesSelector)s}[$__rate_interval]) or irate(mongodb_mongos_metrics_get_last_error_wtime_num_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Total',
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
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_get_last_error_wtimeouts_total{%(queriesSelector)s}[$__rate_interval]) or irate(mongodb_mongos_metrics_get_last_error_wtimeouts_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Timeouts',
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
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_metrics_get_last_error_wtime_total_milliseconds{%(queriesSelector)s}[$__rate_interval]) or irate(mongodb_mongos_metrics_get_last_error_wtime_total_milliseconds{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Write wait time',
          },
        },
      },
      pageFaults: {
        name: 'Page faults',
        description: 'Rate of page faults.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'avg by (%(agg)s) (irate(mongodb_mongod_extra_info_page_faults_total{%(queriesSelector)s}[$__rate_interval]) or irate(mongodb_mongos_extra_info_page_faults_total{%(queriesSelector)s}[$__rate_interval]) or irate(mongodb_extra_info_page_faults_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: 'Faults',
          },
        },
      },
    },
  }
