// Tier 5: Query Analysis Signals
// DBA Question: "Which query is causing the problem?"
// Root cause analysis using pg_stat_statements
// Requires: pg_stat_statements extension

local commonlib = import 'common-lib/common/main.libsonnet';

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
        type: 'counter',
        unit: 'ms',
        sources: {
          postgres_exporter: {
            expr: 'topk(10, rate(pg_stat_statements_seconds_total{%(queriesSelector)s}[$__rate_interval]) * 1000)',
            aggKeepLabels: ['queryid', 'query'],
            legendCustomTemplate: '{{ query }}',
          },
        },
      },

      // What's the slowest query? (performance fix)
      slowestQueriesByMeanTime: {
        name: 'Slowest queries by mean time',
        description: 'Queries with highest average execution time.',
        type: 'gauge',
        unit: 'ms',
        aggFunction: 'max',
        sources: {
          postgres_exporter: {
            expr: |||
              topk(10, 
                pg_stat_statements_mean_time_seconds{%(queriesSelector)s} * 1000
              )
            |||,
            aggKeepLabels: ['queryid', 'query'],
            legendCustomTemplate: '{{ query }}',
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
          postgres_exporter: {
            expr: 'topk(10, rate(pg_stat_statements_calls_total{%(queriesSelector)s}[$__rate_interval]))',
            aggKeepLabels: ['queryid', 'query'],
            legendCustomTemplate: '{{ query }}',
          },
        },
      },

      // What needs more memory? (work_mem tuning)
      queriesUsingTempFiles: {
        name: 'Queries using temp files',
        description: 'Queries writing to temp files. Indicates work_mem is too small for these queries.',
        type: 'counter',
        unit: 'bytes',
        sources: {
          postgres_exporter: {
            expr: |||
              topk(10, 
                rate(pg_stat_statements_temp_blks_written_total{%(queriesSelector)s}[$__rate_interval]) * 8192
              )
            |||,
            aggKeepLabels: ['queryid', 'query'],
            legendCustomTemplate: '{{ query }}',
          },
        },
      },

      // Query I/O efficiency
      queryCacheHitRatio: {
        name: 'Query cache efficiency',
        description: 'Cache hit ratio per query. Low values indicate queries not benefiting from cache.',
        type: 'gauge',
        unit: 'percentunit',
        sources: {
          postgres_exporter: {
            expr: |||
              pg_stat_statements_shared_blks_hit_total{%(queriesSelector)s}
              /
              (
                pg_stat_statements_shared_blks_hit_total{%(queriesSelector)s}
                +
                pg_stat_statements_shared_blks_read_total{%(queriesSelector)s}
                + 1
              )
            |||,
            aggKeepLabels: ['queryid', 'query'],
            legendCustomTemplate: '{{ query }}',
          },
        },
      },
    },
  }

