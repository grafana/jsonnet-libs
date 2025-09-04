local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  local groupAggListWithInstance = std.join(',', this.groupLabels) + (if std.length(this.instanceLabels) > 0 then ',' + std.join(',', this.instanceLabels) else '');
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: '{{couchbase_cluster}} - ' + std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
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
          },
        },
      },
      cpuUtilization: {
        name: 'CPU utilization',
        nameShort: 'CPU %',
        type: 'raw',
        description: 'CPU utilization percentage across all available cores on this Couchbase node.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ') (sys_cpu_utilization_rate{%(queriesSelector)s})',
          },
        },
      },

      // Memory by service
      dataServiceMemoryUsed: {
        name: 'Data service memory used',
        nameShort: 'Data memory',
        type: 'gauge',
        description: 'Memory used by the data service for a node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ') (kv_mem_used_bytes{%(queriesSelector)s})',
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
        type: 'raw',
        description: 'Size of the backup for a node.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ') (backup_data_size{%(queriesSelector)s})',
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
          },
        },
      },

      // HTTP metrics
      httpResponseCodes: {
        name: 'HTTP response codes',
        nameShort: 'HTTP codes',
        type: 'raw',
        description: 'Rate of HTTP response codes handled by the cluster manager.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ', code) (rate(cm_http_requests_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - {{code}}',
          },
        },
      },
      httpRequestMethods: {
        name: 'HTTP request methods',
        nameShort: 'HTTP methods',
        type: 'raw',
        description: 'Rate of HTTP request methods handled by the cluster manager.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ', method) (rate(cm_http_requests_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - {{method}}',
          },
        },
      },
    },
  }
