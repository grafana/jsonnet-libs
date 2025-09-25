function(this)
  local groupAggListWithInstance = std.join(',', this.groupLabels) + (if std.length(this.instanceLabels) > 0 then ',' + std.join(',', this.instanceLabels) else '');
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
      // Instance stats
      uptime: {
        name: 'Uptime',
        nameShort: 'Uptime',
        type: 'gauge',
        description: 'Uptime for an instance.',
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
        description: 'Number of buckets on an instance.',
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
        description: 'Number of users on an instance.',
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
        description: 'Number of replications configured on an instance.',
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
        description: 'Number of remotes configured on an instance.',
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
        description: 'Number of scrapers configured on an instance.',
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
        description: 'Number of dashboards on an instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'influxdb_dashboards_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Dashboards',
          },
        },
      },

      httpAPIRequests: {
        name: 'HTTP API requests',
        nameShort: 'HTTP API requests',
        type: 'raw',
        description: 'Rate of HTTP API requests on an instance.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ') (rate(http_api_requests_total{%(queriesSelector)s}[$__rate_interval]))',
          },
        },
      },

      compilingActiveQueries: {
        name: 'Compiling active queries',
        nameShort: 'Compiling active queries',
        type: 'raw',
        description: 'Number of active queries being compiled on an instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (qc_compiling_active{%(queriesSelector)s})',
            legendCustomTemplate: '{{instance}} - compiling',
          },
        },
      },


      queuingQueries: {
        name: 'Queuing queries',
        nameShort: 'Queuing queries',
        type: 'raw',
        description: 'Number of queries being queued on an instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (qc_queueing_active{%(queriesSelector)s})',
            legendCustomTemplate: '{{instance}} - queuing',
          },
        },
      },

      executingQueries: {
        name: 'Executing queries',
        nameShort: 'Executing queries',
        type: 'raw',
        description: 'Number of queries being executed on an instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (qc_executing_active{%(queriesSelector)s})',
            legendCustomTemplate: '{{instance}} - executing',
          },
        },
      },

      httpOperationQueries: {
        name: 'HTTP operation queries',
        nameShort: 'HTTP operation queries',
        type: 'raw',
        description: 'Number of queries being executed on an instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (rate(http_query_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{instance}} - query - {{status}}',
          },
        },
      },

      httpOperationWrites: {
        name: 'HTTP operation writes',
        nameShort: 'HTTP operation writes',
        type: 'raw',
        description: 'Number of queries being executed on an instance.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (rate(http_write_request_count{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{instance}} - write - {{status}}',
          },
        },
      },

      httpOperationsDataQueryRequests: {
        name: 'HTTP operations data query requests',
        nameShort: 'HTTP operations data query requests',
        type: 'raw',
        description: 'Rate of database HTTP query requests.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (rate(http_query_request_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{instance}} - query request',
          },
        },
      },

      httpOperationsDataQueryResponses: {
        name: 'HTTP operations data query responses',
        nameShort: 'HTTP operations data query responses',
        type: 'raw',
        description: 'Rate of database HTTP query responses.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (rate(http_query_response_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{instance}} - query response',
          },
        },
      },

      httpOperationsDataWriteRequests: {
        name: 'HTTP operations data write requests',
        nameShort: 'HTTP operations data write requests',
        type: 'raw',
        description: 'Rate of database HTTP write requests.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (rate(http_write_request_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{instance}} - write request',
          },
        },
      },

      httpOperationsDataWriteResponses: {
        name: 'HTTP operations data write responses',
        nameShort: 'HTTP operations data write responses',
        type: 'raw',
        description: 'Rate of database HTTP write responses.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ') (rate(http_write_response_bytes{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{instance}} - write response',
          },
        },
      },

      iqlQueryRate: {
        name: 'IQL query rate',
        nameShort: 'IQL query rate',
        type: 'raw',
        description: 'Rate of InfluxQL queries for the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ', result) (rate(influxql_service_requests_total{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{instance}} - {{result}}',
          },
        },
      },


      iqlQueryResponseTime: {
        name: 'IQL query response time',
        nameShort: 'IQL query response time',
        type: 'raw',
        description: 'Response time for recent InfluxQL queries.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (' + groupAggListWithInstance + ', result) (increase(influxql_service_executing_duration_seconds_sum{%(queriesSelector)s}[$__interval] offset -$__interval))',
            legendCustomTemplate: '{{instance}} - {{result}}',
          },
        },
      },


      boltdbReadOperations: {
        name: 'BoltDB read operations',
        nameShort: 'BoltDB read operations',
        type: 'counter',
        description: 'Rate of reads to the underlying BoltDB storage engine for the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'boltdb_reads_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - read',
          },
        },
      },

      boltdbWriteOperations: {
        name: 'BoltDB write operations',
        nameShort: 'BoltDB write operations',
        type: 'counter',
        description: 'Rate of writes to the underlying BoltDB storage engine for the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'boltdb_writes_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - write',
          },
        },
      },

      activeTasks: {
        name: 'Active tasks',
        nameShort: 'Active tasks',
        type: 'gauge',
        description: 'Number of currently executing tasks in the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_scheduler_current_execution{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      activeWorkers: {
        name: 'Active workers',
        nameShort: 'Active workers',
        type: 'gauge',
        description: 'Number of workers currently running tasks on the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_executor_total_runs_active{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },


      workerUsage: {
        name: 'Worker usage',
        nameShort: 'Worker usage',
        type: 'gauge',
        description: 'Percentage of available workers that are currently busy.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_executor_workers_busy{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },


      executionsTotal: {
        name: 'Executions total',
        nameShort: 'Executions total',
        type: 'counter',
        description: 'Rate of executions for the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_scheduler_total_execution_calls{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - total',
          },
        },
      },

      executionsFailures: {
        name: 'Executions failures',
        nameShort: 'Executions failures',
        type: 'counter',
        description: 'Rate of failures for the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_scheduler_total_execute_failure{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - failed',
          },
        },
      },

      scheduleTotals: {
        name: 'Schedule totals',
        nameShort: 'Schedule totals',
        type: 'counter',
        description: 'Rate of schedules for the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_scheduler_total_schedule_calls{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - total',
          },
        },
      },

      scheduleFailures: {
        name: 'Schedule failures',
        nameShort: 'Schedule failures',
        type: 'counter',
        description: 'Rate of failures for the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'task_scheduler_total_schedule_fails{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - failed',
          },
        },
      },


      timeSinceLastGC: {
        name: 'Time since last GC',
        nameShort: 'Time since last GC',
        type: 'raw',
        description: 'Time since the last garbage collection.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'time() - go_memstats_last_gc_time_seconds{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },


      gcTime: {
        name: 'GC time / $__interval',
        nameShort: 'GC time',
        type: 'counter',
        description: 'Server CPU time spent on garbage collection.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'go_gc_duration_seconds_sum{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      gcCPUUsage: {
        name: 'GC CPU usage',
        nameShort: 'GC CPU usage',
        type: 'gauge',
        description: 'Server CPU time spent on garbage collection.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'go_memstats_gc_cpu_fraction{%(queriesSelector)s}',
          },
        },
      },


      goHeapMemoryUsage: {
        name: 'Go heap memory usage',
        nameShort: 'Go heap memory usage',
        type: 'gauge',
        description: 'Heap memory usage for the server.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'go_memstats_heap_alloc_bytes{%(queriesSelector)s} / clamp_min(go_memstats_heap_idle_bytes{%(queriesSelector)s} + go_memstats_heap_alloc_bytes{%(queriesSelector)s}, 1)',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      goThreads: {
        name: 'Go threads',
        nameShort: 'Go threads',
        type: 'gauge',
        description: 'Number of threads for the server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'go_threads{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
