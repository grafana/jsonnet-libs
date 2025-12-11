// Signals for the Microsoft IIS Overview dashboard
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      // Requests signals
      requests: {
        name: 'Requests per second',
        type: 'counter',
        description: 'The request rate split by HTTP Method for an IIS site.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_iis_requests_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{site}} - {{method}}',
          },
        },
      },

      lockedErrors: {
        name: 'Locked errors per second',
        type: 'counter',
        description: 'Requests that resulted in locked errors for an IIS site.',
        unit: 'errors/sec',
        sources: {
          prometheus: {
            expr: 'windows_iis_locked_errors_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{site}} - locked',
          },
        },
      },

      notFoundErrors: {
        name: 'Not found errors per second',
        type: 'counter',
        description: 'Requests that resulted in not found errors for an IIS site.',
        unit: 'errors/sec',
        sources: {
          prometheus: {
            expr: 'windows_iis_not_found_errors_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{site}} - not found',
          },
        },
      },

      // Async I/O signals
      blockedAsyncIORequests: {
        name: 'Blocked async I/O requests',
        type: 'counter',
        description: 'Number of async I/O requests that are currently queued for an IIS site.',
        unit: 'requests',
        sources: {
          prometheus: {
            expr: 'windows_iis_blocked_async_io_requests_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
            rangeFunction: 'increase',
          },
        },
      },

      rejectedAsyncIORequests: {
        name: 'Rejected async I/O requests',
        type: 'counter',
        description: 'Number of async I/O requests that have been rejected for an IIS site.',
        unit: 'requests',
        sources: {
          prometheus: {
            expr: 'windows_iis_rejected_async_io_requests_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
            rangeFunction: 'increase',
          },
        },
      },

      // Data transfer signals
      bytesSent: {
        name: 'Bytes sent per second',
        type: 'counter',
        description: 'The traffic sent by an IIS site.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'windows_iis_sent_bytes_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      bytesReceived: {
        name: 'Bytes received per second',
        type: 'counter',
        description: 'The traffic received by an IIS site.',
        unit: 'Bps',
        sources: {
          prometheus: {
            expr: 'windows_iis_received_bytes_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      filesSent: {
        name: 'Files sent per second',
        type: 'counter',
        description: 'The files sent by an IIS site.',
        unit: 'files',
        sources: {
          prometheus: {
            expr: 'windows_iis_files_sent_total{%(queriesSelector)s, site=~"$site"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      filesReceived: {
        name: 'Files received per second',
        type: 'counter',
        description: 'The files received by an IIS site.',
        unit: 'files',
        sources: {
          prometheus: {
            expr: 'windows_iis_files_received_total{%(queriesSelector)s, site=~"$site"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      // Connection signals
      currentConnections: {
        name: 'Current connections',
        type: 'gauge',
        description: 'The number of current connections to an IIS site.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_current_connections{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      connectionAttempts: {
        name: 'Connection attempts',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of attempted connections to an IIS site.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_connection_attempts_all_instances_total{%(queriesSelector)s, site=~"$site"}',
            legendCustomTemplate: '{{instance}} - {{site}}',
          },
        },
      },

      // Server cache signals
      fileCacheHitRatio: {
        name: 'File cache hit ratio',
        type: 'raw',
        description: 'The current file cache hit ratio for an IIS server.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'increase(windows_iis_server_file_cache_hits_total{%(queriesSelector)s}[$__interval:] offset $__interval) / clamp_min(increase(windows_iis_server_file_cache_queries_total{%(queriesSelector)s}[$__interval:] offset $__interval),1) * 100',
            legendCustomTemplate: '{{job}} - {{instance}}',
          },
        },
      },

      uriCacheHitRatio: {
        name: 'URI cache hit ratio',
        type: 'raw',
        description: 'The current URI cache hit ratio for an IIS server.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(instance, job) (increase(windows_iis_server_uri_cache_hits_total{%(queriesSelector)s}[$__interval:] offset $__interval) / clamp_min(increase(windows_iis_server_uri_cache_queries_total{%(queriesSelector)s}[$__interval:] offset $__interval),1)) * 100',
            legendCustomTemplate: '{{job}} - {{instance}}',
          },
        },
      },

      metadataCacheHitRatio: {
        name: 'Metadata cache hit ratio',
        type: 'raw',
        description: 'The current metadata cache hit ratio for an IIS server.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'increase(windows_iis_server_metadata_cache_hits_total{%(queriesSelector)s}[$__interval:] offset $__interval) / clamp_min(increase(windows_iis_server_metadata_cache_queries_total{%(queriesSelector)s}[$__interval:] offset $__interval),1) * 100',
            legendCustomTemplate: '{{job}} - {{instance}}',
          },
        },
      },

      outputCacheHitRatio: {
        name: 'Output cache hit ratio',
        type: 'raw',
        description: 'The current output cache hit ratio for an IIS site.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'increase(windows_iis_server_output_cache_hits_total{%(queriesSelector)s}[$__interval:] offset $__interval) / clamp_min(increase(windows_iis_server_output_cache_queries_total{%(queriesSelector)s}[$__interval:] offset $__interval), 1) * 100',
            legendCustomTemplate: '{{job}} - {{instance}}',
          },
        },
      },
    },
  }
