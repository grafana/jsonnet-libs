// Connection pool signals for PgBouncer (per-database group)
// Selector: job, pgbouncer_cluster, instance, database.
// aggLevel is 'none' because these panels plot one series per database rather than an
// aggregate. The stat panels want a single total across the selection, which is a bare
// sum() with no by-clause and so cannot come from the agg template; those signals carry
// it via exprWrappers instead.
// Where the same metric is shown both as a total (stat) and per-database (timeSeries),
// each view is its own signal (the '_total' suffix marks the summed one) so that query
// shape, title, unit and legend all live in the spec rather than at the call site.
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
      // Client connection states
      // Per-database series, plotted over time.
      pools_client_waiting_connections: {
        name: 'Waiting clients',
        description: 'Current number of client connections waiting on a server connection.',
        type: 'gauge',
        unit: 'clients',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_client_waiting_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}}',
          },
        },
      },
      // Single total across the selection, shown as a stat.
      pools_client_waiting_connections_total: {
        name: 'Client waiting connections',
        description: 'Current number of client connections waiting on a server connection.',
        type: 'gauge',
        unit: '',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_client_waiting_connections{%(queriesSelector)s}',
            exprWrappers: [['sum(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      pools_client_active_connections: {
        name: 'Active client connections',
        description: 'Current number of active client connections.',
        type: 'gauge',
        unit: 'conn',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_client_active_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}}',
          },
        },
      },
      pools_client_active_connections_total: {
        name: 'Active client connections',
        description: 'Current number of active client connections.',
        type: 'gauge',
        unit: '',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_client_active_connections{%(queriesSelector)s}',
            exprWrappers: [['sum(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      pools_client_maxwait_seconds: {
        name: 'Max client wait time',
        description: 'Age of the oldest unserved client connection in seconds.',
        type: 'gauge',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_client_maxwait_seconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      // Server connection states
      pools_server_active_connections: {
        name: 'Active server connections',
        description: 'Current number of client connections that are linked to a server connection and able to process queries.',
        type: 'gauge',
        unit: '',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_server_active_connections{%(queriesSelector)s}',
            exprWrappers: [['sum(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
      pools_server_idle_connections: {
        name: 'Server idle connections',
        description: 'Current number of server connections idle and ready for a client query.',
        type: 'gauge',
        unit: 'conn',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_server_idle_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}} - idle',
          },
        },
      },
      pools_server_used_connections: {
        name: 'Server used connections',
        description: 'Current number of server connections idle more than server_check_delay.',
        type: 'gauge',
        unit: 'conn',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_server_used_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}} - used',
          },
        },
      },
      pools_server_login_connections: {
        name: 'Server login connections',
        description: 'Current number of server connections in login phase.',
        type: 'gauge',
        unit: 'conn',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_server_login_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}} - login',
          },
        },
      },
      pools_server_testing_connections: {
        name: 'Server testing connections',
        description: 'Current number of server connections being tested.',
        type: 'gauge',
        unit: 'conn',
        sources: {
          prometheus: {
            expr: 'pgbouncer_pools_server_testing_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{database}} - testing',
          },
        },
      },

      // Per-database connection limit
      databases_max_connections: {
        name: 'Max database connections',
        description: 'Maximum number of allowed connections for database.',
        type: 'gauge',
        unit: '',
        sources: {
          prometheus: {
            expr: 'pgbouncer_databases_max_connections{%(queriesSelector)s}',
            exprWrappers: [['sum(', ')']],
            legendCustomTemplate: '',
          },
        },
      },
    },
  }
