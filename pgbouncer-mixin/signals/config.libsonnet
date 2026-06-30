// Per-instance configuration limit signals for PgBouncer.
// These are instance-scoped settings (not per-database), so instanceLabels is
// pureInstanceLabels (['instance']) -> selector job, pgbouncer_cluster, instance,
// reproducing the legacy instanceQueriesSelector. aggLevel 'none'; panels supply sum().
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.pureInstanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'pgbouncer_databases_current_connections',
    },
    signals: {
      config_max_user_connections: {
        name: 'Max user connections',
        description: 'Maximum number of server connections per user allowed.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'pgbouncer_config_max_user_connections{%(queriesSelector)s}',
          },
        },
      },
      config_max_client_connections: {
        name: 'Max client connections',
        description: 'Maximum number of client connections allowed.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'pgbouncer_config_max_client_connections{%(queriesSelector)s}',
          },
        },
      },
    },
  }
