local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {
      sql_service_elap_per_exec_avg_ms: {
        name: 'SQL service elapsed time per execution',
        type: 'gauge',
        aggLevel: 'none',
        aggFunction: 'avg',
        description: 'Average SQL service elapsed time per execution in milliseconds.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by (job, sid, host, service, sql_type) (hanadb_sql_service_elap_per_exec_avg_ms{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - service: {{service}} - type: {{sql_type}}',
          },
        },
      },

      sql_service_elap_per_exec_avg_ms_by_service: {
        name: 'SQL service elapsed time per execution by service',
        type: 'gauge',
        aggLevel: 'none',
        aggFunction: 'avg',
        description: 'Average SQL service elapsed time per execution by service and type.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by (job, sid, host, service, sql_type) (hanadb_sql_service_elap_per_exec_avg_ms{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - {{service}} - {{sql_type}}',
          },
        },
      },

      sql_service_lock_per_exec_ms: {
        name: 'SQL service lock time per execution',
        type: 'gauge',
        aggLevel: 'none',
        description: 'SQL service lock time per execution in milliseconds.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, service, sql_type) (hanadb_sql_service_lock_per_exec_ms{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - {{service}} - {{sql_type}}',
          },
        },
      },

      sql_top_time_consumers_mu: {
        name: 'SQL top time consumers',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Top SQL time consumers in microseconds.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, sql_hash) (hanadb_sql_top_time_consumers_mu{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - hash: {{sql_hash}}',
          },
        },
      },
    },
  }
