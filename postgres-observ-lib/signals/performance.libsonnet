// Tier 3: Performance Trends Signals
// DBA Question: "Is performance acceptable? What's the trend?"
// Time series for monitoring throughput and resource usage

local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      postgres_exporter: 'pg_stat_database_xact_commit',
    },
    signals: {
      // What's my throughput?
      transactionsPerSecond: {
        name: 'Transactions per second',
        description: 'Combined commits and rollbacks per second.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (
                rate(pg_stat_database_xact_commit{%(queriesSelector)s}[$__rate_interval])
                +
                rate(pg_stat_database_xact_rollback{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: TPS',
          },
        },
      },

      // Connection trend
      activeConnections: {
        name: 'Active connections',
        description: 'Current number of connections to PostgreSQL.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'sum by (%(agg)s) (pg_stat_activity_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Active connections',
          },
        },
      },

      // Are queries spilling to disk?
      tempBytesWritten: {
        name: 'Temp bytes written',
        description: 'Bytes written to temporary files. High values indicate work_mem needs tuning.',
        type: 'counter',
        unit: 'bytes',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_database_temp_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Temp bytes',
          },
        },
      },

      // I/O balance
      diskReadWriteRatio: {
        name: 'Disk reads',
        description: 'Blocks read from disk (not cache). High values indicate cache misses.',
        type: 'counter',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_database_blks_read{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Disk reads',
          },
        },
      },

      // Checkpoint duration
      checkpointDuration: {
        name: 'Checkpoint duration',
        description: 'Time spent in checkpoints (write + sync). High values indicate I/O bottleneck.',
        type: 'gauge',
        unit: 'ms',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (
                rate(pg_stat_bgwriter_checkpoint_write_time{%(queriesSelector)s}[$__rate_interval])
                +
                rate(pg_stat_bgwriter_checkpoint_sync_time{%(queriesSelector)s}[$__rate_interval])
              )
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Checkpoint duration',
          },
        },
      },

      // Commit vs rollback ratio
      rollbackRatio: {
        name: 'Rollback ratio',
        description: 'Percentage of transactions that are rolled back. High values indicate application issues.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (rate(pg_stat_database_xact_rollback{%(queriesSelector)s}[$__rate_interval]))
              /
              (
                sum by (%(agg)s) (rate(pg_stat_database_xact_commit{%(queriesSelector)s}[$__rate_interval]))
                +
                sum by (%(agg)s) (rate(pg_stat_database_xact_rollback{%(queriesSelector)s}[$__rate_interval]))
              )
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Rollback ratio',
          },
        },
      },

      // ============================================
      // Rows Activity (from upstream postgres_mixin)
      // ============================================

      // Rows fetched per second
      rowsFetched: {
        name: 'Rows fetched',
        description: 'Number of rows fetched by queries per second.',
        type: 'gauge',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_database_tup_fetched{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Fetched',
          },
        },
      },

      // Rows returned per second
      rowsReturned: {
        name: 'Rows returned',
        description: 'Number of rows returned by queries per second.',
        type: 'gauge',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_database_tup_returned{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Returned',
          },
        },
      },

      // Rows inserted per second
      rowsInserted: {
        name: 'Rows inserted',
        description: 'Number of rows inserted per second.',
        type: 'gauge',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_database_tup_inserted{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Inserted',
          },
        },
      },

      // Rows updated per second
      rowsUpdated: {
        name: 'Rows updated',
        description: 'Number of rows updated per second.',
        type: 'gauge',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_database_tup_updated{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Updated',
          },
        },
      },

      // Rows deleted per second
      rowsDeleted: {
        name: 'Rows deleted',
        description: 'Number of rows deleted per second.',
        type: 'gauge',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_database_tup_deleted{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Deleted',
          },
        },
      },

      // ============================================
      // Buffer Activity (from upstream postgres_mixin)
      // ============================================

      // Buffers allocated
      buffersAlloc: {
        name: 'Buffers allocated',
        description: 'Number of buffers allocated per second.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_bgwriter_buffers_alloc_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Allocated',
          },
        },
      },

      // Buffers written by bgwriter during checkpoints
      buffersCheckpoint: {
        name: 'Buffers checkpoint',
        description: 'Number of buffers written during checkpoints per second.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_bgwriter_buffers_checkpoint_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Checkpoint',
          },
        },
      },

      // Buffers written by bgwriter (cleaning)
      buffersClean: {
        name: 'Buffers clean',
        description: 'Number of buffers written by background writer per second.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_bgwriter_buffers_clean_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Clean',
          },
        },
      },

      // Buffers written by backends (not bgwriter)
      buffersBackend: {
        name: 'Buffers backend',
        description: 'Number of buffers written directly by backends per second. Should be low.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_bgwriter_buffers_backend_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Backend',
          },
        },
      },

      // Backend fsync calls
      buffersBackendFsync: {
        name: 'Buffers backend fsync',
        description: 'Number of fsync calls by backends per second. Should be zero.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_bgwriter_buffers_backend_fsync_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Backend fsync',
          },
        },
      },
    },
  }
