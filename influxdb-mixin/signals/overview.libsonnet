function(this)
  local groupAggListWithoutInstance = std.join(',', this.groupLabels);
  local groupAggListWithInstance = groupAggListWithoutInstance + ', ' + std.join(',', this.instanceLabels);
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: '{{influxdb_cluster}} - ' + std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'influxdb_uptime_seconds',
    },
    signals: {
      uptime: {
        name: 'Uptime',
        nameShort: 'Uptime',
        type: 'gauge',
        description: 'Uptime for a cluster.',
        unit: 'seconds',
        sources: {
          prometheus: {
            expr: 'influxdb_uptime_seconds{%(queriesSelector)s}',
            legendCustomTemplate: 'Uptime',
          },
        },
      },

      buckets: {
        name: 'Buckets',
        nameShort: 'Buckets',
        type: 'gauge',
        description: 'Number of buckets in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'influxdb_buckets_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Buckets',
          },
        },
      },

      users: {
        name: 'Users',
        nameShort: 'Users',
        type: 'gauge',
        description: 'Number of users in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'influxdb_users_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Users',
          },
        },
      },

      replications: {
        name: 'Replications',
        nameShort: 'Replications',
        type: 'gauge',
        description: 'Number of replications in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'influxdb_replications_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Replications',
          },
        },
      },

      remotes: {
        name: 'remotes',
        nameShort: 'Remotes',
        type: 'gauge',
        description: 'Number of dashboards in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'influxdb_remotes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Remotes',
          },
        },
      },

      scrapers: {
        name: 'Scrapers',
        nameShort: 'Scrapers',
        type: 'gauge',
        description: 'Number of scrapers in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'influxdb_scrapers_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Scrapers',
          },
        },
      },

      dashboards: {
        name: 'Dashboards',
        nameShort: 'Dashboards',
        type: 'gauge',
        description: 'Number of dashboards in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'influxdb_dashboards_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Dashboards',
          },
        },
      },

      topInstancesByHTTPAPIRequests: {
        name: 'Top instances by HTTP API requests',
        nameShort: 'Top instances by HTTP API requests',
        type: 'raw',
        description: 'Top instances by HTTP API requests in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk($k, sum by(job, influxdb_cluster, instance) (rate(http_api_requests_total{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{influxdb_cluster}} - {{instance}}',
          },
        },
      },

      httpAPIRequestDuration: {
        name: 'HTTP API request duration',
        nameShort: 'HTTP API request duration',
        type: 'raw',
        description: 'HTTP API request duration in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'histogram_quantile(0.95, sum by(le, job, influxdb_cluster) (rate(http_api_request_duration_seconds_bucket{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{influxdb_cluster}}',
          },
        },
      },

      httpAPIResponseCodes: {
        name: 'HTTP API response codes',
        nameShort: 'HTTP API response codes',
        type: 'raw',
        description: 'HTTP API response codes in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster, response_code) (rate(http_api_requests_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{influxdb_cluster}} - {{response_code}}',
          },
        },
      },

      httpQueryOperations: {
        name: 'HTTP operations',
        nameShort: 'HTTP operations',
        type: 'raw',
        description: 'HTTP operations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster, status) (rate(http_query_request_count{%(queriesSelector)s}[$__rate_interval])) > 0',
            legendCustomTemplate: '{{influxdb_cluster}} - query -{{status}}',
          },
        },
      },

      httpWriteOperations: {
        name: 'HTTP write operations',
        nameShort: 'HTTP write operations',
        type: 'raw',
        description: 'HTTP write operations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster, status) (rate(http_write_request_count{%(queriesSelector)s}[$__rate_interval])) > 0',
            legendCustomTemplate: '{{influxdb_cluster}} - write -{{status}}',
          },
        },
      },

      httpQueryRequestOperationsData: {
        name: 'HTTP query request operations data',
        nameShort: 'HTTP query request operations data',
        type: 'raw',
        description: 'HTTP query request operations data in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster) (rate(http_query_request_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{influxdb_cluster}} - query - request',
          },
        },
      },

      httpQueryResponseOperationsData: {
        name: 'HTTP query response operations data',
        nameShort: 'HTTP query response operations data',
        type: 'raw',
        description: 'HTTP query response operations data in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster) (rate(http_query_response_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{influxdb_cluster}} - query - response',
          },
        },
      },

      httpWriteRequestOperationsData: {
        name: 'HTTP write request operations data',
        nameShort: 'HTTP write request operations data',
        type: 'raw',
        description: 'HTTP write request operations data in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster) (rate(http_write_request_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{influxdb_cluster}} - write - request',
          },
        },
      },

      httpWriteResponseOperationsData: {
        name: 'HTTP write response operations data',
        nameShort: 'HTTP write response operations data',
        type: 'raw',
        description: 'HTTP write response operations data in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster) (rate(http_write_response_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{influxdb_cluster}} - write - response',
          },
        },
      },

      topInstancesByIQLQueryRate: {
        name: 'Top instances by InfluxQL query rate',
        nameShort: 'Top instances by InfluxQL query rate',
        type: 'raw',
        description: 'Top instances by InfluxQL query rate in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'topk($k, sum by(job, influxdb_cluster, instance) (rate(influxql_service_requests_total{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{influxdb_cluster}} - {{instance}}',
          },
        },
      },


      iqlQueryResponseTime: {
        name: 'InfluxQL query response time',
        nameShort: 'InfluxQL query response time',
        type: 'raw',
        description: 'InfluxQL query response time in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster, result) (increase(influxql_service_executing_duration_seconds_sum{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{influxdb_cluster}}',
          },
        },
      },

      boltdbReadOperations: {
        name: 'BoltDB read operations',
        nameShort: 'BoltDB read operations',
        type: 'counter',
        description: 'BoltDB read operations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'boltdb_reads_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{influxdb_cluster}} - read',
          },
        },
      },

      boltdbWriteOperations: {
        name: 'BoltDB write operations',
        nameShort: 'BoltDB write operations',
        type: 'counter',
        description: 'BoltDB write operations in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'boltdb_writes_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{influxdb_cluster}} - write',
          },
        },
      },

      activeTasks: {
        name: 'Active tasks',
        nameShort: 'Active tasks',
        type: 'raw',
        description: 'Active tasks in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster) (task_scheduler_current_execution{%(queriesSelector)s})',
            legendCustomTemplate: '{{influxdb_cluster}}',
          },
        },
      },

      activeWorkers: {
        name: 'Active workers',
        nameShort: 'Active workers',
        type: 'raw',
        description: 'Active workers in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster) (task_executor_total_runs_active{%(queriesSelector)s})',
            legendCustomTemplate: '{{influxdb_cluster}}',
          },
        },
      },

      executionTotals: {
        name: 'Execution totals',
        nameShort: 'Execution totals',
        type: 'raw',
        description: 'Execution totals in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster) (task_scheduler_total_execution_calls{%(queriesSelector)s})',
            legendCustomTemplate: '{{influxdb_cluster}} - total',
          },
        },
      },

      executionFailures: {
        name: 'Execution failures',
        nameShort: 'Execution failures',
        type: 'raw',
        description: 'Execution failures in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, influxdb_cluster) (task_scheduler_total_execute_failure{%(queriesSelector)s})',
            legendCustomTemplate: '{{influxdb_cluster}} - failed',
          },
        },
      },


      scheduleTotals: {
        name: 'Schedule totals',
        nameShort: 'Schedule totals',
        type: 'counter',
        description: 'Schedule totals in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_scheduler_total_schedule_calls{%(queriesSelector)s}',
            legendCustomTemplate: '{{influxdb_cluster}} - total',
          },
        },
      },

      scheduleFailures: {
        name: 'Schedule failures',
        nameShort: 'Schedule failures',
        type: 'counter',
        description: 'Schedule failures in a cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_scheduler_total_schedule_fails{%(queriesSelector)s}',
            legendCustomTemplate: '{{influxdb_cluster}} - failed',
          },
        },
      },

      topInstancesByHeapMemoryUsage: {
        name: 'Top instances by heap memory usage',
        nameShort: 'Top instances by heap memory usage',
        type: 'raw',
        description: 'Top instances by heap memory usage in a cluster.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'topk($k, sum by(job, influxdb_cluster, instance) (go_memstats_heap_alloc_bytes{%(queriesSelector)s}/clamp_min(go_memstats_heap_idle_bytes{%(queriesSelector)s} + go_memstats_heap_alloc_bytes{%(queriesSelector)s}, 1)))',
            legendCustomTemplate: '{{influxdb_cluster}} - {{instance}}',
          },
        },
      },

      topInstancesByGCCPUUsage: {
        name: 'Top instances by GC CPU usage',
        nameShort: 'Top instances by GC CPU usage',
        type: 'gauge',
        description: 'Top instances by GC CPU usage in a cluster.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'go_memstats_gc_cpu_fraction{%(queriesSelector)s}',
            legendCustomTemplate: '{{influxdb_cluster}} - {{instance}}',
          },
        },
      },
    },
  }
