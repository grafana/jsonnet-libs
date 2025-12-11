function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      postgres_exporter: 'pg_stat_activity_count',
    },
    signals: {
      // Is something stuck?
      longRunningQueries: {
        name: 'Long-running queries',
        description: 'Number of queries running longer than 5 minutes.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_long_running_transactions{%(queriesSelector)s}',
            legendCustomTemplate: ' Long-running queries',
          },
        },
      },

      // Are locks causing waits?
      blockedQueries: {
        name: 'Blocked queries',
        description: 'Number of queries waiting for locks. Should be 0.',
        type: 'gauge',
        unit: 'short',
        // aggFunction: 'sum' is default, let it handle aggregation
        sources: {
          postgres_exporter: {
            expr: |||
              pg_locks_count{%(queriesSelector)s, mode="exclusivelock"}              
            |||,
            legendCustomTemplate: ' Blocked queries',
          },
        },
      },

      // Are connections holding locks without doing work?
      idleInTransaction: {
        name: 'Idle in transaction',
        description: 'Connections idle in transaction state. Can hold locks and block others.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_activity_count{%(queriesSelector)s, state="idle in transaction"}',
            legendCustomTemplate: ' Idle in transaction',
          },
        },
      },

      // Are backups at risk?
      walArchiveFailures: {
        name: 'WAL archive failures',
        description: 'Failed WAL archive attempts. Non-zero means backups may be incomplete.',
        type: 'counter',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_archiver_failed_count{%(queriesSelector)s}',
            legendCustomTemplate: ' WAL archive failures',
          },
        },
      },

      // Is checkpoint I/O overloaded?
      checkpointWarnings: {
        name: 'Bgwriter max written clean',
        description: 'Times bgwriter stopped cleaning because it wrote too many buffers. Indicates I/O pressure.',
        type: 'counter',
        unit: 'short',
        sources: {
          postgres_exporter: {
            // Use maxwritten_clean as proxy for checkpoint pressure
            // This counts times bgwriter had to stop due to writing too many buffers
            // Note: type='counter' automatically applies rate()
            expr: 'pg_stat_bgwriter_maxwritten_clean_total{%(queriesSelector)s}',
            legendCustomTemplate: ' Max written clean',
          },
        },
      },

      conflicts: {
        name: 'Conflicts',
        description: 'Number of queries cancelled due to conflicts with recovery on standby servers.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_database_conflicts{%(queriesSelector)s}',
            legendCustomTemplate: ' Conflicts',
          },
        },
      },

      // Lock utilization
      lockUtilization: {
        name: 'Lock utilization',
        description: 'Percentage of max locks in use. Above 20% is warning.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (pg_locks_count{%(queriesSelector)s})
              /
              (
                max by (%(agg)s) (pg_settings_max_locks_per_transaction{%(queriesSelector)s})
                *
                max by (%(agg)s) (pg_settings_max_connections{%(queriesSelector)s})
              )
            |||,
            legendCustomTemplate: ' Lock utilization',
          },
        },
      },

      // Inactive replication slots
      inactiveReplicationSlots: {
        name: 'Inactive replication slots',
        description: 'Number of inactive replication slots. Can cause WAL to accumulate.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            // Count replicas not in streaming state as a proxy for inactive slots
            // Returns 0 if no non-streaming slots exist
            expr: |||
              count by (%(agg)s) (pg_stat_replication_pg_wal_lsn_diff{%(queriesSelector)s, state!="streaming"})
              or
              (0 * group by (%(agg)s) (pg_stat_replication_pg_wal_lsn_diff{%(queriesSelector)s}))
            |||,
            legendCustomTemplate: ' Inactive replication slots',
          },
        },
      },

      // Exporter errors
      exporterErrors: {
        name: 'Exporter errors',
        description: 'Whether the PostgreSQL exporter had errors during last scrape.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            expr: 'pg_exporter_last_scrape_error{%(queriesSelector)s}',
            legendCustomTemplate: ' Exporter errors',
          },
        },
      },
    },
  }
