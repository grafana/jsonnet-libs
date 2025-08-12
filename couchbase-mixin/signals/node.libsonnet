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
      prometheus: 'sys_mem_actual_used',
    },
    signals: {
      // Node system metrics
      memoryUtilization: {
        name: 'Memory utilization',
        nameShort: 'Memory %',
        type: 'raw',
        description: 'Percentage of memory allocated to Couchbase on this node actually in use.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'sys_mem_actual_used{%(queriesSelector)s} / (clamp_min(sys_mem_actual_free{%(queriesSelector)s} + sys_mem_actual_used{%(queriesSelector)s}, 1))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },
      cpuUtilization: {
        name: 'CPU utilization',
        nameShort: 'CPU %',
        type: 'gauge',
        description: 'CPU utilization percentage across all available cores on this Couchbase node.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(couchbase_cluster, job, instance) (sys_cpu_utilization_rate{%(queriesSelector)s})',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },

      // Memory by service
      dataServiceMemoryUsed: {
        name: 'Data service memory used',
        nameShort: 'Data Memory',
        type: 'gauge',
        description: 'Memory used by the data service for a node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'sum by(couchbase_cluster, instance, job) (kv_mem_used_bytes{%(queriesSelector)s})',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - data',
          },
        },
      },
      indexServiceMemoryUsed: {
        name: 'Index service memory used',
        nameShort: 'Index Memory',
        type: 'gauge',
        description: 'Memory used by the index service for a node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'index_memory_used_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - index',
          },
        },
      },
      analyticsServiceMemoryUsed: {
        name: 'Analytics service memory used',
        nameShort: 'Analytics Memory',
        type: 'gauge',
        description: 'Memory used by the analytics service for a node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'cbas_direct_memory_used_bytes{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - analytics',
          },
        },
      },

      // Node backup and connections
      backupSize: {
        name: 'Backup size',
        nameShort: 'Backup',
        type: 'gauge',
        description: 'Size of the backup for a node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'sum by(couchbase_cluster, instance, job) (backup_data_size{%(queriesSelector)s})',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },
      currentConnections: {
        name: 'Current connections',
        nameShort: 'Connections',
        type: 'gauge',
        description: 'Number of active connections to a node.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'kv_curr_connections{%(queriesSelector)s}',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },

      // HTTP metrics
      httpResponseCodes: {
        name: 'HTTP response codes',
        nameShort: 'HTTP Codes',
        type: 'counter',
        description: 'Rate of HTTP response codes handled by the cluster manager.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, couchbase_cluster, code) (rate(cm_http_requests_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - {{code}}',
          },
        },
      },
      httpRequestMethods: {
        name: 'HTTP request methods',
        nameShort: 'HTTP Methods',
        type: 'counter',
        description: 'Rate of HTTP request methods handled by the cluster manager.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, couchbase_cluster, method) (rate(cm_http_requests_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - {{method}}',
          },
        },
      },
    },
  } 