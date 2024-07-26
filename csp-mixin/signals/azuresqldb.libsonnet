local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    discoveryMetric: {
      azuremonitor: 'azure_microsoft_storage_storageaccounts_blobservices_blobcount_average_count',
    },

    signals: {
      successfulConns: {
        name: 'Successful connections by database',
        description: 'Count of successful connections by database',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_connection_successful_total_count{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      deadlocks: {
        name: 'Deadlocks by database',
        description: 'Count of deadlocks by database',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_deadlock_total_count{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      sessions: {
        name: 'Average sessions by database',
        description: 'Average number of sessions by database',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_sessions_count_average_count{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      cpuPercent: {
        name: 'CPU utilization by database',
        description: 'Percent of CPU utilization by database. If database uses vCores, the vCore percent utilization is shown',
        type: 'gauge',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_cpu_percent_average_percent{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      vCoreCpuPercent: {
        name: 'vCore utilization by database',
        description: 'Percent of CPU utilization by database. If database uses vCores, the vCore percent utilization is shown',
        type: 'gauge',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_cpu_used_average_count{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)") / label_replace(azure_microsoft_sql_servers_databases_cpu_limit_average_count{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            exprWrappers: [['100 * (', ')']],
            legendCustomTemplate: '{{database}} vCore',
          },
        },
      },

      storageBytes: {
        name: 'Storage utilization by database',
        description: 'Bytes of storage by database',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_storage_maximum_bytes{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      storagePercent: {
        name: 'Storage % of limit by database',
        description: 'Percent used of storage limitby database',
        type: 'gauge',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_storage_percent_maximum_percent{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      dtuUsed: {
        name: 'Used',
        description: 'Average number of DTUs utilized by database',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_dtu_used_average_count{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      dtuPercent: {
        name: 'Percent of limit',
        description: 'Average percent of DTU limit utilized by database',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_dtu_consumption_percent_average_percent{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },

      dtuLimit: {
        name: 'Limit',
        description: 'DTU limit by database',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'label_replace(azure_microsoft_sql_servers_databases_dtu_limit_average_count{%(queriesSelector)s}, "database", "$1", "resourceID", ".+/(.*)")',
            legendCustomTemplate: '{{database}}',
          },
        },
      },
    },

  }
