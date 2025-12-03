// Tier 4: Maintenance Signals
// DBA Question: "What maintenance tasks need attention?"
// Actionable metrics for vacuum, bloat, and index health

local commonlib = import 'common-lib/common/main.libsonnet';

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
        sources: {
          postgres_exporter: {
            expr: |||
              count by (%(agg)s) (
                (
                  pg_stat_user_tables_n_dead_tup{%(queriesSelector)s}
                  /
                  (pg_stat_user_tables_n_live_tup{%(queriesSelector)s} + pg_stat_user_tables_n_dead_tup{%(queriesSelector)s} + 1)
                ) > 0.1
              )
              /
              count by (%(agg)s) (pg_stat_user_tables_n_live_tup{%(queriesSelector)s})
            |||,
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
            expr: |||
              max by (%(agg)s) (
                max by (%(agg)s) (
                  (time() - pg_stat_user_tables_last_autovacuum{%(queriesSelector)s})
                  and
                  pg_stat_user_tables_last_autovacuum{%(queriesSelector)s} > 0
                )
              )
            |||,
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
            legendCustomTemplate: '{{ schemaname }}.{{ relname }}',
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
            legendCustomTemplate: '{{ schemaname }}.{{ relname }}',
          },
        },
      },

      // Are indexes being used?
      sequentialScanRatio: {
        name: 'Sequential scan ratio',
        description: 'Ratio of sequential scans to total scans. High values indicate missing indexes.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              sum by (%(agg)s) (pg_stat_user_tables_seq_scan{%(queriesSelector)s})
              /
              (
                sum by (%(agg)s) (pg_stat_user_tables_seq_scan{%(queriesSelector)s})
                +
                sum by (%(agg)s) (pg_stat_user_tables_idx_scan{%(queriesSelector)s})
                + 1
              )
            |||,
          },
        },
      },

      // Unused indexes (wasted disk space)
      unusedIndexes: {
        name: 'Unused indexes',
        description: 'Count of indexes with zero scans. Candidates for removal.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'count',
        sources: {
          postgres_exporter: {
            expr: |||
              count by (%(agg)s) (
                pg_stat_user_indexes_idx_scan{%(queriesSelector)s} == 0
              )
            |||,
          },
        },
      },

      // Database size
      databaseSize: {
        name: 'Database size',
        description: 'Total size of all databases.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          postgres_exporter: {
            expr: 'sum by (%(agg)s) (pg_database_size_bytes{%(queriesSelector)s})',
          },
        },
      },

      // WAL size
      walSize: {
        name: 'WAL size',
        description: 'Current size of Write-Ahead Log.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          postgres_exporter: {
            expr: 'pg_wal_size_bytes{%(queriesSelector)s}',
          },
        },
      },
    },
  }

