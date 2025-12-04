// Tier 4: Maintenance Signals
// DBA Question: "What maintenance tasks need attention?"
// Actionable metrics for vacuum, bloat, and index health

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      postgres_exporter: 'pg_stat_user_tables_n_dead_tup',
    },
    signals: {
      // Which tables need vacuum? (ratio of tables needing vacuum)
      tablesNeedingVacuum: {
        name: 'Tables needing vacuum ratio',
        description: 'Ratio of tables with dead tuple ratio > 10% to total tables.',
        type: 'gauge',
        unit: 'percentunit',
        aggFunction: 'avg',  // Use avg for ratio, not sum
        sources: {
          postgres_exporter: {
            expr: |||
              count(
                (
                  pg_stat_user_tables_n_dead_tup{%(queriesSelector)s}
                  /
                  (pg_stat_user_tables_n_live_tup{%(queriesSelector)s} + pg_stat_user_tables_n_dead_tup{%(queriesSelector)s} + 1)
                ) > 0.1
              )
              /
              count(pg_stat_user_tables_n_live_tup{%(queriesSelector)s})
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Tables needing vacuum',
          },
        },
      },

      // Is autovacuum working? (oldest last vacuum)
      oldestVacuum: {
        name: 'Oldest vacuum age',
        description: 'Time since oldest table was last vacuumed. Alerts if > 7 days.',
        type: 'gauge',
        unit: 's',
        aggFunction: 'max',
        sources: {
          postgres_exporter: {
            // aggFunction: 'max' handles the outer aggregation
            expr: |||
              (time() - pg_stat_user_tables_last_autovacuum{%(queriesSelector)s})
              and
              pg_stat_user_tables_last_autovacuum{%(queriesSelector)s} > 0
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Oldest vacuum',
          },
        },
      },

      // Dead tuple ratio by table (for drill-down)
      deadTupleRatio: {
        name: 'Dead tuple ratio',
        description: 'Ratio of dead to total tuples per table. > 10% needs vacuum.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              (
                pg_stat_user_tables_n_dead_tup{%(queriesSelector)s}
                /
                (pg_stat_user_tables_n_live_tup{%(queriesSelector)s} + pg_stat_user_tables_n_dead_tup{%(queriesSelector)s} + 1)
              )
            |||,
            aggKeepLabels: ['schemaname', 'relname'],
            legendCustomTemplate: '{{cluster}} - {{instance}}: {{ schemaname }}.{{ relname }}',
          },
        },
      },

      // Last vacuum time per table
      lastVacuumAge: {
        name: 'Last vacuum age',
        description: 'Time since each table was last vacuumed.',
        type: 'gauge',
        unit: 's',
        sources: {
          postgres_exporter: {
            expr: |||
              (
                time() - pg_stat_user_tables_last_autovacuum{%(queriesSelector)s}
              )
              and
              pg_stat_user_tables_last_autovacuum{%(queriesSelector)s} > 0
            |||,
            aggKeepLabels: ['schemaname', 'relname'],
            legendCustomTemplate: '{{cluster}} - {{instance}}: {{ schemaname }}.{{ relname }}',
          },
        },
      },

      // Are indexes being used?
      sequentialScanRatio: {
        name: 'Sequential scan ratio',
        description: 'Ratio of sequential scans to total scans. High values indicate missing indexes.',
        type: 'gauge',
        unit: 'percentunit',
        aggFunction: 'avg',  // Use avg to not double-sum the ratio
        sources: {
          postgres_exporter: {
            expr: |||
              sum(pg_stat_user_tables_seq_scan{%(queriesSelector)s})
              /
              (
                sum(pg_stat_user_tables_seq_scan{%(queriesSelector)s})
                +
                sum(pg_stat_user_tables_idx_scan{%(queriesSelector)s})
                + 1
              )
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Seq scan ratio',
          },
        },
      },

      // Unused indexes (wasted disk space)
      unusedIndexes: {
        name: 'Unused indexes',
        description: 'Count of indexes with zero reads. Candidates for removal.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'count',  // Use count aggregation
        sources: {
          postgres_exporter: {
            // Count indexes with zero buffer hits AND zero disk reads
            // aggFunction: 'count' handles the aggregation
            expr: |||
              (pg_statio_user_indexes_idx_blks_hit_total{%(queriesSelector)s} == 0)
              and
              (pg_statio_user_indexes_idx_blks_read_total{%(queriesSelector)s} == 0)
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: Unused indexes',
          },
        },
      },

      // Unused indexes list (for table display)
      unusedIndexesList: {
        name: 'Unused indexes list',
        description: 'List of indexes with zero buffer hits and disk reads.',
        type: 'gauge',
        unit: 'short',
        sources: {
          postgres_exporter: {
            // Show indexes with zero buffer hits AND zero disk reads, keeping index details
            expr: |||
              (
                (pg_statio_user_indexes_idx_blks_hit_total{%(queriesSelector)s} == 0)
                and
                (pg_statio_user_indexes_idx_blks_read_total{%(queriesSelector)s} == 0)
              ) * 0
            |||,
            aggKeepLabels: ['indexrelname', 'relname', 'schemaname'],
            legendCustomTemplate: '{{ schemaname }}.{{ relname }}.{{ indexrelname }}',
          },
        },
      },

      // Index table size (per table, for context)
      indexTableSize: {
        name: 'Table index size',
        description: 'Total index size per table in bytes.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          postgres_exporter: {
            expr: 'pg_stat_user_tables_index_size_bytes{%(queriesSelector)s}',
            aggKeepLabels: ['relname', 'schemaname'],
            legendCustomTemplate: '{{ schemaname }}.{{ relname }}',
          },
        },
      },

      // Database size
      databaseSize: {
        name: 'Database size',
        description: 'Total size of all databases.',
        type: 'gauge',
        unit: 'bytes',
        // aggFunction: 'sum' is default, expression should not have sum
        sources: {
          postgres_exporter: {
            expr: 'pg_database_size_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{cluster}} - {{instance}}: Database size',
          },
        },
      },

      // WAL position (total WAL bytes written)
      walSize: {
        name: 'WAL position',
        description: 'Current WAL LSN position in bytes (total WAL written).',
        type: 'gauge',
        unit: 'bytes',
        aggFunction: 'max',
        sources: {
          postgres_exporter: {
            // Use current WAL LSN position from replication stats (primary only)
            // Falls back to 0 if no replication is configured
            // aggFunction: 'max' handles the outer aggregation
            expr: |||
              pg_stat_replication_pg_current_wal_lsn_bytes{%(queriesSelector)s}
              or vector(0)
            |||,
            legendCustomTemplate: '{{cluster}} - {{instance}}: WAL position',
          },
        },
      },
    },
  }

