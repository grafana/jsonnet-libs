// Cluster-overview "top database" signals for PgBouncer.
// These reproduce the legacy topk panels: the inner selector is group-only
// (job, pgbouncer_cluster via %(queriesSelectorGroupOnly)s) and the topk by-clause /
// $top_database_count parameter are baked into raw expressions.
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
        type: 'raw',
        unit: 'conn',
        sources: {
          prometheus: {
            expr: 'topk by(database, instance, pgbouncer_cluster)($top_database_count, pgbouncer_pools_client_active_connections{%(queriesSelectorGroupOnly)s})',
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}}',
          },
        },
      },
      top_database_query_processed: {
        name: 'Top databases by queries processed',
        description: 'Top databases by rate of SQL queries pooled by PgBouncer.',
        type: 'raw',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'topk by(database, instance, pgbouncer_cluster)($top_database_count, rate(pgbouncer_stats_queries_pooled_total{%(queriesSelectorGroupOnly)s}[$__rate_interval]))',
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}}',
          },
        },
      },
      top_database_query_duration: {
        name: 'Top databases by average query duration',
        description: 'Top databases by average duration of queries being processed by PgBouncer.',
        type: 'raw',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'topk by(database, instance, pgbouncer_cluster)($top_database_count, 1000 * increase(pgbouncer_stats_queries_duration_seconds_total{%(queriesSelectorGroupOnly)s}[$__interval:]) / clamp_min(increase(pgbouncer_stats_queries_pooled_total{%(queriesSelectorGroupOnly)s}[$__interval:]), 1))',
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}}',
          },
        },
      },
      top_database_network_received: {
        name: 'Top databases by network traffic received',
        description: 'Top databases by volume of network traffic received.',
        type: 'raw',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'topk by(database, instance, pgbouncer_cluster)($top_database_count, rate(pgbouncer_stats_received_bytes_total{%(queriesSelectorGroupOnly)s}[$__rate_interval]))',
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}} - received',
          },
        },
      },
      top_database_network_sent: {
        name: 'Top databases by network traffic sent',
        description: 'Top databases by volume of network traffic sent.',
        type: 'raw',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'topk by(database, instance, pgbouncer_cluster)($top_database_count, rate(pgbouncer_stats_sent_bytes_total{%(queriesSelectorGroupOnly)s}[$__rate_interval]))',
            legendCustomTemplate: '{{pgbouncer_cluster}} - {{instance}} - {{database}} - sent',
          },
        },
      },
    },
  }
