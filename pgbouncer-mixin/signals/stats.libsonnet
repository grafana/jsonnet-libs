// Query, transaction, and network statistics signals for PgBouncer (per-database group).
// Selector: job, pgbouncer_cluster, instance, database. aggLevel 'none'; counters default
// to rate() in asTarget(); the average-duration signals are raw (ratio-of-increases).
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'pgbouncer_stats_queries_pooled_total',
    },
    signals: {
      // Query statistics
      stats_queries_pooled_total: {
        name: 'Queries processed',
        description: 'Rate of SQL queries pooled by PgBouncer.',
        type: 'counter',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'pgbouncer_stats_queries_pooled_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}}',
          },
        },
      },
      stats_query_avg_duration: {
        name: 'Average query duration',
        description: 'Average duration of queries processed by PgBouncer per interval.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: '1000 * increase(pgbouncer_stats_queries_duration_seconds_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(pgbouncer_stats_queries_pooled_total{%(queriesSelector)s}[$__interval:]), 1)',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      // Transaction statistics
      stats_sql_transactions_pooled_total: {
        name: 'SQL transaction rate',
        description: 'Rate of SQL transactions pooled by PgBouncer.',
        type: 'counter',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'pgbouncer_stats_sql_transactions_pooled_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}}',
          },
        },
      },
      stats_transaction_avg_duration: {
        name: 'Average transaction duration',
        description: 'Average duration of SQL transactions pooled by PgBouncer per interval.',
        type: 'raw',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: '1000 * increase(pgbouncer_stats_server_in_transaction_seconds_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(pgbouncer_stats_sql_transactions_pooled_total{%(queriesSelector)s}[$__interval:]), 1)',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      // Network statistics
      stats_received_bytes_total: {
        name: 'Network received',
        description: 'Rate of bytes received by PgBouncer from clients.',
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'pgbouncer_stats_received_bytes_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}} - received',
          },
        },
      },
      stats_sent_bytes_total: {
        name: 'Network sent',
        description: 'Rate of bytes sent by PgBouncer to clients.',
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'pgbouncer_stats_sent_bytes_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}} - sent',
          },
        },
      },
    },
  }
