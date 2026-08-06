// Cluster-overview "top database" signals for PgBouncer.
// The inner selector is group-only (job, pgbouncer_cluster via
// %(queriesSelectorGroupOnly)s). The topk by-clause and the $top_database_count
// dashboard variable are supplied through exprWrappers so the metric expression
// itself stays a plain typed signal.
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
      prometheus: 'pgbouncer_databases_current_connections',
    },
    signals: {
      top_database_active_connection: {
        name: 'Top databases by active connections',
        description: 'Top databases by current number of active client connections.',
        type: 'gauge',
        unit: 'conn',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_client_active_connections{%(queriesSelectorGroupOnly)s}',
            exprWrappers: [['topk by(database, instance, pgbouncer_cluster)($top_database_count, ', ')']],
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}}',
          },
        },
      },
      top_database_query_processed: {
        name: 'Top databases by queries processed',
        description: 'Top databases by rate of SQL queries pooled by PgBouncer.',
        type: 'counter',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'pgbouncer_stats_queries_pooled_total{%(queriesSelectorGroupOnly)s}',
            exprWrappers: [['topk by(database, instance, pgbouncer_cluster)($top_database_count, ', ')']],
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}}',
          },
        },
      },
      // Raw: ratio of two range vectors, which no typed signal can express.
      // Only the topk wrapper is factored out.
      top_database_query_duration: {
        name: 'Top databases by average query duration',
        description: 'Top databases by average duration of queries being processed by PgBouncer.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: '1000 * increase(pgbouncer_stats_queries_duration_seconds_total{%(queriesSelectorGroupOnly)s}[$__interval:] offset -$__interval) / clamp_min(increase(pgbouncer_stats_queries_pooled_total{%(queriesSelectorGroupOnly)s}[$__interval:] offset -$__interval), 1)',
            exprWrappers: [['topk by(database, instance, pgbouncer_cluster)($top_database_count, ', ')']],
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}}',
          },
        },
      },
      top_database_network_received: {
        name: 'Top databases by network traffic received',
        description: 'Top databases by volume of network traffic received.',
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'pgbouncer_stats_received_bytes_total{%(queriesSelectorGroupOnly)s}',
            exprWrappers: [['topk by(database, instance, pgbouncer_cluster)($top_database_count, ', ')']],
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}} - received',
          },
        },
      },
      top_database_network_sent: {
        name: 'Top databases by network traffic sent',
        description: 'Top databases by volume of network traffic sent.',
        type: 'counter',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'pgbouncer_stats_sent_bytes_total{%(queriesSelectorGroupOnly)s}',
            exprWrappers: [['topk by(database, instance, pgbouncer_cluster)($top_database_count, ', ')']],
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}} - sent',
          },
        },
      },
    },
  }
