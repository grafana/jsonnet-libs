local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'windows_memory_physical_total_bytes',
      prometheus_pre_0_30: 'windows_cs_physical_memory_bytes',
    },
    signals: {
      memoryTotal: {
        name: 'Memory total',
        nameShort: 'Total',
        type: 'gauge',
        description: 'Total physical memory in bytes',
        unit: 'bytes',
        sources: {
          prometheus_pre_0_30: {
            expr: 'windows_cs_physical_memory_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Memory total',
          },
          prometheus: {
            expr: 'windows_memory_physical_total_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Memory total',
          },
        },
      },
      memoryFree: {
        name: 'Memory free',
        nameShort: 'Free',
        type: 'gauge',
        description: 'Free physical memory in bytes',
        unit: 'bytes',
        sources: {
          prometheus_pre_0_30: {
            expr: 'windows_os_physical_memory_free_bytes{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'windows_memory_physical_free_bytes{%(queriesSelector)s}',
          },
        },
      },
      memoryUsed: {
        name: 'Memory used',
        nameShort: 'Used',
        type: 'raw',
        description: 'Used physical memory in bytes',
        unit: 'bytes',
        sources: {
          prometheus_pre_0_30: {
            expr: 'windows_cs_physical_memory_bytes{%(queriesSelector)s} - windows_os_physical_memory_free_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Memory used',
          },
          prometheus: {
            expr: 'windows_memory_physical_total_bytes{%(queriesSelector)s} - windows_memory_physical_free_bytes{%(queriesSelector)s}',
            legendCustomTemplate: 'Memory used',
          },

        },
      },
      memoryUsagePercent: {
        name: 'Memory usage',
        nameShort: 'Usage',
        type: 'raw',
        description: 'Memory usage percentage',
        unit: 'percent',
        sources: {
          prometheus_pre_0_30: {
            expr: '100 - windows_os_physical_memory_free_bytes{%(queriesSelector)s} / windows_cs_physical_memory_bytes{%(queriesSelector)s} * 100',
          },
          prometheus: {
            expr: '100 - windows_memory_physical_free_bytes{%(queriesSelector)s} / windows_memory_physical_total_bytes{%(queriesSelector)s} * 100',
          },
        },
      },
      memoryPageTotal: {
        name: 'Page file total',
        nameShort: 'Page total',
        type: 'gauge',
        description: 'Total page file size in bytes',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'windows_pagefile_limit_bytes{%(queriesSelector)s}',
          },
          prometheus_pre_0_30: {
            expr: 'windows_os_paging_limit_bytes{%(queriesSelector)s}',
          },
        },
      },
      memoryPageFree: {
        name: 'Page file free',
        nameShort: 'Page free',
        type: 'gauge',
        description: 'Free page file space in bytes',
        unit: 'bytes',
        sources: {
          //https://github.com/prometheus-community/windows_exporter/pull/1735
          prometheus_pre_0_30: {
            expr: 'windows_os_paging_free_bytes{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'windows_pagefile_free_bytes{%(queriesSelector)s}',
          },
        },
      },
      memoryPageUsed: {
        name: 'Page file used',
        nameShort: 'Page used',
        type: 'raw',
        description: 'Used page file space in bytes',
        unit: 'bytes',
        sources: {
          prometheus_pre_0_30: {
            expr: 'windows_os_paging_limit_bytes{%(queriesSelector)s} - windows_os_paging_free_bytes{%(queriesSelector)s}',
          },
          prometheus: {
            expr: 'windows_pagefile_limit_bytes{%(queriesSelector)s} - windows_pagefile_free_bytes{%(queriesSelector)s}',
          },
        },
      },
    },
  }
