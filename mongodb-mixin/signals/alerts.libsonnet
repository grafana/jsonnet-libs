function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,

    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      percona_mongodb: 'mongodb_up',
    },
    signals: {
      mongodbUp: {
        name: 'MongoDB up',
        description: 'Whether the MongoDB instance is up.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_up{%(queriesSelector)s}',
          },
        },
      },
      replicaMemberHealth: {
        name: 'Replica member health',
        description: 'Health of the replica set member.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_replset_member_health{%(queriesSelector)s}',
          },
        },
      },
      secondaryReplicationLag: {
        name: 'Secondary replication lag',
        description: 'Replication lag in seconds for SECONDARY members.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_replset_member_replication_lag{state="SECONDARY", %(queriesSelector)s}',
          },
        },
      },
      oplogWindow: {
        name: 'Oplog window',
        description: 'Time window covered by the oplog (tail - head).',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_replset_oplog_tail_timestamp{%(queriesSelector)s} - mongodb_mongod_replset_oplog_head_timestamp{%(queriesSelector)s}',
          },
        },
      },
      primaryOptime: {
        name: 'Primary optime',
        description: 'Optime of the PRIMARY replica set member.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_replset_member_optime_date{state="PRIMARY"}',
          },
        },
      },
      secondaryOptime: {
        name: 'Secondary optime',
        description: 'Optime of SECONDARY replica set members.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_replset_member_optime_date{state="SECONDARY", %(queriesSelector)s}',
          },
        },
      },
      cursorsOpenTotal: {
        name: 'Open cursors (total)',
        description: 'Number of open cursors with state=total on mongod.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongod_metrics_cursor_open{state="total", %(queriesSelector)s}',
          },
        },
      },
      cursorTimeouts: {
        name: 'Cursor timeouts',
        description: 'Cursor timeouts over the last 1 minute.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'increase(mongodb_mongod_metrics_cursor_timed_out_total{%(queriesSelector)s}[1m])',
          },
        },
      },
      currentConnections: {
        name: 'Current connections',
        description: 'Number of current connections.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_connections{state="current", %(queriesSelector)s}',
          },
        },
      },
      totalConnections: {
        name: 'Total connection capacity',
        description: 'Current connections plus available capacity (total slot count).',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_connections{state=~"current|available", %(queriesSelector)s}',
          },
        },
      },
      virtualMemory: {
        name: 'Virtual memory',
        description: 'Virtual memory used by MongoDB.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_memory{type="virtual", %(queriesSelector)s}',
          },
        },
      },
      mappedMemory: {
        name: 'Mapped memory',
        description: 'Mapped memory used by MongoDB.',
        type: 'raw',
        unit: 'bytes',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_memory{type="mapped", %(queriesSelector)s}',
          },
        },
      },
      readQueueDelta: {
        name: 'Read queue delta',
        description: 'Change in reader queue depth over the last 1 minute.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'delta(mongodb_mongod_global_lock_current_queue{type="reader", %(queriesSelector)s}[1m])',
          },
        },
      },
      writeQueueDelta: {
        name: 'Write queue delta',
        description: 'Change in writer queue depth over the last 1 minute.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'delta(mongodb_mongod_global_lock_current_queue{type="writer", %(queriesSelector)s}[1m])',
          },
        },
      },
    },
  }
