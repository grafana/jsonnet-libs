// Signals for the Microsoft IIS Applications dashboard
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      // Worker request signals
      workerRequests: {
        name: 'Worker requests per second',
        type: 'counter',
        description: 'The HTTP request rate for an IIS application.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_requests_total{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      workerRequestErrors: {
        name: 'Worker request errors per second',
        type: 'counter',
        description: 'Requests that have resulted in errors for an IIS application.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_request_errors_total{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}} - {{status_code}}',
          },
        },
      },

      // Websocket signals
      websocketConnectionAttempts: {
        name: 'Websocket connection attempts',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of attempted websocket connections for an IIS application.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_websocket_connection_attempts_total{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      websocketConnectionAccepted: {
        name: 'Websocket connections accepted',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of accepted websocket connections for an IIS application.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_websocket_connection_accepted_total{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      websocketConnectionSuccessRate: {
        name: 'Websocket connection success rate',
        type: 'raw',
        description: 'The success rate of websocket connection attempts for an IIS application.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(app, job, instance) (increase(windows_iis_worker_websocket_connection_accepted_total{%(queriesSelector)s, app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_websocket_connection_attempts_total{%(queriesSelector)s, app=~"$application"}[$__interval:]),1)) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      // Worker thread signals
      currentWorkerThreads: {
        name: 'Current worker threads',
        type: 'gauge',
        description: 'The current number of worker threads processing requests for an IIS application.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_threads{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}} - {{state}}',
          },
        },
      },

      maxWorkerThreads: {
        name: 'Maximum worker threads',
        type: 'gauge',
        description: 'The maximum number of worker threads for an IIS application.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_max_threads{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      threadPoolUtilization: {
        name: 'Thread pool utilization',
        type: 'raw',
        description: 'The current application thread pool utilization for an IIS application.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by (job, instance, app) (windows_iis_worker_threads{%(queriesSelector)s, app=~"$application"})/ clamp_min(sum by (job, instance, app) (windows_iis_worker_max_threads{%(queriesSelector)s, app=~"$application"}),1) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      // Application pool signals
      currentWorkerProcesses: {
        name: 'Current worker processes',
        type: 'gauge',
        description: 'The current number of worker processes for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_current_worker_processes{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      applicationPoolState: {
        name: 'Application pool state',
        type: 'gauge',
        description: 'The current state of an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_current_application_pool_state{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}} - {{state}}',
          },
        },
      },

      // Worker process failure signals
      totalWorkerProcessFailures: {
        name: 'Total worker process failures',
        type: 'counter',
        description: 'Total worker process failures for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_total_worker_process_failures{%(queriesSelector)s, app=~"$application"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      workerProcessStartupFailures: {
        name: 'Worker process startup failures',
        type: 'counter',
        description: 'Worker process startup failures for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_total_worker_process_startup_failures{%(queriesSelector)s, app=~"$application"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      workerProcessShutdownFailures: {
        name: 'Worker process shutdown failures',
        type: 'counter',
        description: 'Worker process shutdown failures for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_total_worker_process_shutdown_failures{%(queriesSelector)s, app=~"$application"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      workerProcessPingFailures: {
        name: 'Worker process ping failures',
        type: 'counter',
        description: 'Worker process ping failures for an IIS application pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_total_worker_process_ping_failures{%(queriesSelector)s, app=~"$application"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      // Worker cache signals
      workerFileCacheHitRatio: {
        name: 'Worker file cache hit ratio',
        type: 'raw',
        description: 'The current file cache hit ratio for an IIS worker process.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, app) (increase(windows_iis_worker_file_cache_hits_total{%(queriesSelector)s, app=~"$application"}[$__interval:] offset $__interval) / clamp_min(increase(windows_iis_worker_file_cache_queries_total{%(queriesSelector)s, app=~"$application"}[$__interval:] offset $__interval),1)) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      workerUriCacheHitRatio: {
        name: 'Worker URI cache hit ratio',
        type: 'raw',
        description: 'The current URI cache hit ratio for an IIS worker process.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(instance, job, app) (increase(windows_iis_worker_uri_cache_hits_total{%(queriesSelector)s, app=~"$application"}[$__interval:] offset $__interval) / clamp_min(increase(windows_iis_worker_uri_cache_queries_total{%(queriesSelector)s, app=~"$application"}[$__interval:] offset $__interval),1)) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      workerMetadataCacheHitRatio: {
        name: 'Worker metadata cache hit ratio',
        type: 'raw',
        description: 'The current metadata cache hit ratio for an IIS worker process.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, app)(increase(windows_iis_worker_metadata_cache_hits_total{%(queriesSelector)s, app=~"$application"}[$__interval:] offset $__interval) / clamp_min(increase(windows_iis_worker_metadata_cache_queries_total{%(queriesSelector)s, app=~"$application"}[$__interval:] offset $__interval),1)) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      workerOutputCacheHitRatio: {
        name: 'Worker output cache hit ratio',
        type: 'raw',
        description: 'The current output cache hit ratio for an IIS worker process.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, app) (increase(windows_iis_worker_output_cache_hits_total{%(queriesSelector)s, app=~"$application"}[$__interval:] offset $__interval) / clamp_min(increase(windows_iis_worker_output_queries_total{%(queriesSelector)s, app=~"$application"}[$__interval:] offset $__interval),1))',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },
    },
  }
