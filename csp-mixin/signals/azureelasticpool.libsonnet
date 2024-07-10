local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    discoveryMetric: {
      azuremonitor: 'azure_microsoft_storage_storageaccounts_blobservices_blobcount_average_count',
    },
    signals: {
      storageAllocTbl: {
        name: 'Allocated',
        description: 'Storage allocated per elasticpool.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_sql_servers_elasticpools_allocated_data_storage_average_bytes{%(queriesSelector)s}',
          },
        },
      },

      storageUsedTbl: {
        name: 'Used',
        description: 'Storage allocated per elasticpool.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_sql_servers_elasticpools_storage_used_average_bytes{%(queriesSelector)s}',
          },
        },
      },

      storageLimitTbl: {
        name: 'Limit',
        description: 'Storage allocated per elasticpool.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_sql_servers_elasticpools_storage_limit_average_bytes{%(queriesSelector)s}',
          },
        },
      },

      cpu: {
        name: 'CPU utilization',
        description: 'CPU utilization per elasticpool.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_sql_servers_elasticpools_cpu_percent_average_percent{%(queriesSelector)s}',
          },
        },
      },

      memory: {
        name: 'Memory utilization',
        description: 'Memory utilization per elasticpool.',
        type: 'gauge',
        unit: 'percent',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_sql_servers_elasticpools_sql_instance_memory_percent_maximum_percent{%(queriesSelector)s}',
          },
        },
      },

      edtu: {
        name: 'eDTU utilization',
        description: 'eDTU utilization per elasticpool.',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_sql_servers_elasticpools_edtu_used_average_count{%(queriesSelector)s}',
          },
        },
      },

      session: {
        name: 'Concurrent sessions',
        description: 'Average sessions per elasticpool.',
        type: 'gauge',
        sources: {
          azuremonitor: {
            expr: 'azure_microsoft_sql_servers_elasticpools_sessions_count_average_count{%(queriesSelector)s}',
          },
        },
      },
    },
  }
