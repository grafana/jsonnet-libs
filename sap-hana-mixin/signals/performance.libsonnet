function(this) {
  local aggregationLabels = std.join(', ', this.groupLabels + this.instanceLabels),
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  signals: {
    avgQueryExecutionTime: {
      name: 'Average query execution time',
      nameShort: 'Query time',
      type: 'raw',
      description: 'Average elapsed time per execution by service and SQL type in the SAP HANA instance',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'avg by (' + aggregationLabels + ', service, sql_type) (hanadb_sql_service_elap_per_exec_avg_ms{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - {{service}} - {{sql_type}}',
        },
      },
    },

    avgLockWaitTime: {
      name: 'Average lock wait execution time',
      nameShort: 'Lock wait',
      type: 'raw',
      description: 'Average lock wait time per execution by service and SQL type in the SAP HANA instance',
      unit: 'ms',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', service, sql_type) (hanadb_sql_service_lock_per_exec_ms{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - {{service}} - {{sql_type}}',
        },
      },
    },

    topTablesByMemory: {
      name: 'Top tables by memory',
      nameShort: 'Top tables',
      type: 'raw',
      description: 'Top tables by the sum of memory size in the main, delta, and history parts for the SAP HANA instance',
      unit: 'decmbytes',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', database_name, table_name, schema_name) (topk(5, hanadb_table_cs_top_mem_total_mb{%(queriesSelector)s}))',
          legendCustomTemplate: '{{host}} - {{database_name}} - {{schema_name}} - {{table_name}}',
        },
      },
    },

    topSQLByTime: {
      name: 'Top SQL queries by average time',
      nameShort: 'Top SQL',
      type: 'raw',
      description: 'Top statements by time consumed over all executions for the SAP HANA instance',
      unit: 'µs',
      sources: {
        prometheus: {
          expr: 'sum by (' + aggregationLabels + ', sql_hash) (hanadb_sql_top_time_consumers_mu{%(queriesSelector)s})',
          legendCustomTemplate: '{{host}} - hash: {{sql_hash}}',
        },
      },
    },
  },
}
