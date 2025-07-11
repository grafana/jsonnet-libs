local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'mssql_server_total_memory_bytes',
    },
    signals: {
      osMemoryUsage: {
        name: 'OS memory usage',
        nameShort: 'OS Memory',
        type: 'gauge',
        description: 'Operating system memory usage by state.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'mssql_os_memory{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ state }}',
          },
        },
      },
      memoryManagerTotal: {
        name: 'Memory manager total',
        nameShort: 'Memory Total',
        type: 'gauge',
        description: 'Total memory allocated by SQL Server memory manager.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'mssql_server_total_memory_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - total',
          },
        },
      },
      memoryManagerTarget: {
        name: 'Memory manager target',
        nameShort: 'Memory Target',
        type: 'gauge',
        description: 'Target memory for SQL Server memory manager.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'mssql_server_target_memory_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - target',
          },
        },
      },
      committedMemoryUtilization: {
        name: 'Committed memory utilization',
        nameShort: 'Memory Utilization',
        type: 'raw',
        description: 'Percentage of committed memory utilization.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * mssql_server_total_memory_bytes{%(queriesSelector)s} / clamp_min(mssql_available_commit_memory_bytes{%(queriesSelector)s}, 1)',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      pageFileMemory: {
        name: 'Page file memory',
        nameShort: 'Page File',
        type: 'gauge',
        description: 'Page file memory usage by state.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'mssql_os_page_file{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - {{ state }}',
          },
        },
      },
      bufferCacheHitPercentage: {
        name: 'Buffer cache hit percentage',
        nameShort: 'Buffer Cache Hit',
        type: 'gauge',
        description: 'Buffer cache hit ratio percentage.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'mssql_buffer_cache_hit_ratio{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      pageCheckpoints: {
        name: 'Page checkpoints',
        nameShort: 'Checkpoints',
        type: 'gauge',
        description: 'Number of checkpoint pages per second.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'mssql_checkpoint_pages_sec{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
      pageFaults: {
        name: 'Page faults',
        nameShort: 'Page Faults',
        type: 'raw',
        description: 'Rate of page faults per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'increase(mssql_page_fault_count_total{%(queriesSelector)s}[$__rate_interval:])',
            legendCustomTemplate: '{{ instance }}',
          },
        },
      },
    },
  }
