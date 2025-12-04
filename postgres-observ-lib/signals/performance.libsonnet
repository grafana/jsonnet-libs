// Tier 3: Performance Trends Signals
// DBA Question: "Is performance acceptable? What's the trend?"
// Time series for monitoring throughput and resource usage

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
        // aggFunction: 'sum' is default, let it handle aggregation
        sources: {
          postgres_exporter: {
            expr: |||
              rate(pg_stat_database_xact_commit{%(queriesSelector)s}[$__rate_interval])
              +
              rate(pg_stat_database_xact_rollback{%(queriesSelector)s}[$__rate_interval])
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
        // aggFunction: 'sum' is default, let it handle aggregation
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_activity_count{%(queriesSelector)s}',
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

      // Buffers allocated
      checkpointDuration: {
        name: 'Buffers allocated',
        description: 'Rate of new buffer allocations per second.',
        type: 'counter',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            // Note: type='counter' automatically applies rate()
            expr: 'pg_stat_bgwriter_buffers_alloc_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Buffers allocated',
          },
        },
      },

      // Commit vs rollback ratio
      rollbackRatio: {
        name: 'Rollback ratio',
        description: 'Percentage of transactions that are rolled back. High values indicate application issues.',
        type: 'gauge',
        unit: 'percentunit',
        aggFunction: 'avg',  // Use avg for ratio, not sum
        sources: {
          postgres_exporter: {
            expr: |||
              sum(rate(pg_stat_database_xact_rollback{%(queriesSelector)s}[$__rate_interval]))
              /
              (
                sum(rate(pg_stat_database_xact_commit{%(queriesSelector)s}[$__rate_interval]))
                +
                sum(rate(pg_stat_database_xact_rollback{%(queriesSelector)s}[$__rate_interval]))
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

      // Buffers allocated (for buffersActivity panel)
      buffersAlloc: {
        name: 'Buffers alloc',
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

      // Buffers written by bgwriter (cleaning)
      buffersCheckpoint: {
        name: 'Buffers cleaned',
        description: 'Number of buffers written by background writer per second.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_bgwriter_buffers_clean_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Cleaned',
          },
        },
      },

      // Buffers clean total (duplicate metric for compatibility)
      buffersClean: {
        name: 'Buffers clean total',
        description: 'Number of buffers cleaned by bgwriter per second.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_bgwriter_buffers_clean_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Clean total',
          },
        },
      },

      // Max written clean stops
      buffersBackend: {
        name: 'Max written stops',
        description: 'Times bgwriter stopped due to writing too many buffers. Indicates I/O pressure.',
        type: 'gauge',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'rate(pg_stat_bgwriter_maxwritten_clean_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Max written stops',
          },
        },
      },

      // Stats reset time (placeholder - no backend fsync available)
      buffersBackendFsync: {
        name: 'Stats age',
        description: 'Time since bgwriter stats were last reset.',
        type: 'gauge',
        unit: 's',
        sources: {
          postgres_exporter: {
            expr: 'time() - pg_stat_bgwriter_stats_reset_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Stats age',
          },
        },
      },
    },
  }
