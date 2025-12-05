function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    discoveryMetric: {
      postgres_exporter: 'pg_stat_statements_calls_total',
    },
    signals: {
      // What consumes most resources? (optimization target)
      topQueriesByTotalTime: {
        name: 'Top queries by total time',
        description: 'Queries consuming the most cumulative execution time. Primary optimization targets.',
        type: 'raw',
        unit: 's',
        sources: {
          postgres_exporter: {
            expr: 'topk($topk, rate(pg_stat_statements_seconds_total{%(queriesSelector)s}[$__rate_interval]))',
            aggKeepLabels: ['queryid', 'datname', 'user'],
            legendCustomTemplate: '{{ queryid }} ({{ datname }})',
          },
        },
      },

      // What's the slowest query? (performance fix)
      slowestQueriesByMeanTime: {
        name: 'Slowest queries by mean time',
        description: 'Queries with highest average execution time (total time / calls).',
        type: 'raw',
        unit: 's',
        sources: {
          postgres_exporter: {
            expr: |||
              topk($topk,
                (
                  pg_stat_statements_seconds_total{%(queriesSelector)s}
                  /
                  (pg_stat_statements_calls_total{%(queriesSelector)s} + 1)
                )
              )
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
        type: 'raw',
        unit: 'ops',
        sources: {
          postgres_exporter: {
            expr: 'topk($topk, rate(pg_stat_statements_calls_total{%(queriesSelector)s}[$__rate_interval]))',
            aggKeepLabels: ['queryid', 'datname', 'user'],
            legendCustomTemplate: '{{ queryid }} ({{ datname }})',
          },
        },
      },

      // Rows returned per query (useful for identifying expensive queries)
      topQueriesByRows: {
        name: 'Top queries by rows',
        description: 'Queries returning the most rows. May indicate full table scans.',
        type: 'raw',
        unit: 'rows/s',
        sources: {
          postgres_exporter: {
            expr: 'topk($topk, rate(pg_stat_statements_rows_total{%(queriesSelector)s}[$__rate_interval]))',
            aggKeepLabels: ['queryid', 'datname', 'user'],
            legendCustomTemplate: '{{ queryid }} ({{ datname }})',
          },
        },
      },

    },
  }
