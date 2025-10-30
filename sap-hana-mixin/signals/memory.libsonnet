local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    signals: {
      // Physical memory metrics
      host_memory_resident_mb: {
        name: 'Host memory resident',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Resident memory usage in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_host_memory_resident_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - resident',
          },
        },
      },

      host_memory_physical_total_mb: {
        name: 'Host memory physical total',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Total physical memory in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_host_memory_physical_total_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      // Physical memory usage percentage (raw calculation)
      physical_memory_usage_percent: {
        name: 'Physical memory usage percent',
        type: 'raw',
        description: 'Current physical memory usage of the host as a percentage.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum by (job, sid, host) (hanadb_host_memory_resident_mb{%(queriesSelector)s}) / sum by (job, sid, host) (hanadb_host_memory_physical_total_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - resident',
          },
        },
      },

      // Swap memory metrics
      host_memory_swap_used_mb: {
        name: 'Host memory swap used',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Used swap memory in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_host_memory_swap_used_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - swap',
          },
        },
      },

      host_memory_swap_free_mb: {
        name: 'Host memory swap free',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Free swap memory in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_host_memory_swap_free_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      // Swap memory usage percentage (raw calculation)
      swap_memory_usage_percent: {
        name: 'Swap memory usage percent',
        type: 'raw',
        description: 'Current swap memory usage as a percentage.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum by (job, sid, host) (hanadb_host_memory_swap_used_mb{%(queriesSelector)s}) / (sum by (job, sid, host) (hanadb_host_memory_swap_used_mb{%(queriesSelector)s}) + sum by (job, sid, host) (hanadb_host_memory_swap_free_mb{%(queriesSelector)s}))',
            legendCustomTemplate: '{{host}} - swap',
          },
        },
      },

      // SAP HANA memory metrics
      host_memory_used_total_mb: {
        name: 'Host memory used total',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Total SAP HANA memory used in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_host_memory_used_total_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      host_memory_alloc_limit_mb: {
        name: 'Host memory allocation limit',
        type: 'gauge',
        aggLevel: 'none',
        description: 'SAP HANA memory allocation limit in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_host_memory_alloc_limit_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      // SAP HANA memory usage percentage (raw calculation)
      hana_memory_usage_percent: {
        name: 'SAP HANA memory usage percent',
        type: 'raw',
        description: 'Current SAP HANA memory usage as a percentage of allocation limit.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum by (job, sid, host) (hanadb_host_memory_used_total_mb{%(queriesSelector)s}) / sum by (job, sid, host) (hanadb_host_memory_alloc_limit_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      // Memory allocation limit percentage (raw calculation)
      memory_alloc_limit_percent: {
        name: 'Memory allocation limit percent',
        type: 'raw',
        description: 'Memory allocation limit as a percentage of total physical memory.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum by (job, sid, host) (hanadb_host_memory_alloc_limit_mb{%(queriesSelector)s}) / sum by (job, sid, host) (hanadb_host_memory_physical_total_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      // Schema memory usage
      schema_used_memory_mb: {
        name: 'Schema used memory',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Memory used by SAP HANA schemas.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, database_name, schema_name) (hanadb_schema_used_memory_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - {{database_name}} - {{schema_name}}',
          },
        },
      },
    },
  }
