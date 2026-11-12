function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'pg_stat_statements_calls_total',
    },
    signals: {
      // What consumes most resources? (optimization target)
      topQueriesByTotalTime: {
        name: 'Top queries by total time',
        description: 'Queries consuming the most cumulative execution time. Primary optimization targets.',
        type: 'counter',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'pg_stat_statements_seconds_total{%(queriesSelector)s}',
            aggKeepLabels: ['queryid', 'datname', 'user'],
            legendCustomTemplate: '{{ queryid }} ({{ datname }})',
          },
        },
      },

      // What's the slowest query? (performance fix)
      slowestQueriesByMeanTime: {
        name: 'Slowest queries by mean time',
        description: 'Queries with highest average execution time (total time / calls).',
        type: 'gauge',
        unit: 's',
        sources: {
          prometheus: {
            expr: |||
              sum by (%(agg)s) (pg_stat_statements_seconds_total{%(queriesSelector)s})
              /
              (sum by (%(agg)s) (pg_stat_statements_calls_total{%(queriesSelector)s}) + 1)
            |||,
            aggKeepLabels: ['queryid', 'datname', 'user'],
            legendCustomTemplate: '{{ queryid }} ({{ datname }})',
          },
        },
      },

      // What runs most often? (cache candidates)
      mostFrequentQueries: {
        name: 'Most frequent queries',
        description: 'Most frequently executed queries. Even fast queries can impact if called often.',
        type: 'counter',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'pg_stat_statements_calls_total{%(queriesSelector)s}',
            aggKeepLabels: ['queryid', 'datname', 'user'],
            legendCustomTemplate: '{{ queryid }} ({{ datname }})',
          },
        },
      },

      // Rows returned per query (useful for identifying expensive queries)
      topQueriesByRows: {
        name: 'Top queries by rows',
        description: 'Queries returning the most rows. May indicate full table scans.',
        type: 'counter',
        unit: 'rows/s',
        sources: {
          prometheus: {
            expr: 'pg_stat_statements_rows_total{%(queriesSelector)s}',
            aggKeepLabels: ['queryid', 'datname', 'user'],
            legendCustomTemplate: '{{ queryid }} ({{ datname }})',
          },
        },
      },

      queryTotalTime: {
        name: 'Query total time',
        description: 'Execution time of each query since its statistics were reset.',
        type: 'gauge',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'pg_stat_statements_seconds_total{%(queriesSelector)s}',
            aggKeepLabels: ['queryid', 'datname', 'user'],
            legendCustomTemplate: '{{ queryid }} ({{ datname }})',
          },
        },
      },

    },
  }
