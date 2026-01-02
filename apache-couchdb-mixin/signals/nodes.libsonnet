function(this) {
  local legendCustomTemplate = std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
  local groupLabelAggTerm = std.join(', ', this.groupLabels + this.instanceLabels),
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  legendCustomTemplate: legendCustomTemplate,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  discoveryMetric: {
    prometheus: 'couchdb_database_reads_total',
  },

  signals: {
    erlangMemoryUsage: {
      name: 'Erlang memory usage',
      nameShort: 'Erlang memory',
      type: 'gauge',
      description: "The amount of memory used by a node's Erlang Virtual Machine.",
      unit: 'decbytes',
      sources: {
        prometheus: {
          expr: 'couchdb_erlang_memory_bytes{%(queriesSelector)s, memory_type="total"}',
        },
      },
    },

    openOSFiles: {
      name: 'Open OS files',
      nameShort: 'Open OS files',
      type: 'gauge',
      description: 'The total number of file descriptors open on a node.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'couchdb_open_os_files{%(queriesSelector)s}',
        },
        prometheusWithTotal: {
          expr: 'couchdb_open_os_files_total{%(queriesSelector)s}',
        },
      },
    },

    openDatabases: {
      name: 'Open databases',
      nameShort: 'Open databases',
      type: 'gauge',
      description: 'The total number of open databases on a node.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'couchdb_open_databases{%(queriesSelector)s}',
        },
        prometheusWithTotal: {
          expr: 'couchdb_open_databases_total{%(queriesSelector)s}',
        },
      },
    },

    databaseWrites: {
      name: 'Database writes',
      nameShort: 'Database writes',
      type: 'counter',
      description: 'The total number of database writes on a node.',
      unit: 'wps',
      sources: {
        prometheus: {
          expr: 'couchdb_database_writes_total{%(queriesSelector)s}',
        },
      },
    },

    databaseReads: {
      name: 'Database reads',
      nameShort: 'Database reads',
      type: 'counter',
      description: 'The total number of database reads on a node.',
      unit: 'rps',
      sources: {
        prometheus: {
          expr: 'couchdb_database_reads_total{%(queriesSelector)s}',
        },
      },
    },

    viewReads: {
      name: 'View reads',
      nameShort: 'View reads',
      type: 'counter',
      description: 'The total number of view reads on a node.',
      unit: 'rps',
      sources: {
        prometheus: {
          expr: 'couchdb_httpd_view_reads_total{%(queriesSelector)s}',
        },
      },
    },

    viewTimeouts: {
      name: 'View timeouts',
      nameShort: 'View timeouts',
      type: 'counter',
      description: 'The total number of view requests that timed out on a node.',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'couchdb_httpd_view_timeouts_total{%(queriesSelector)s}',
        },
      },
    },

    temporaryViewReads: {
      name: 'Temporary view reads',
      nameShort: 'Temporary view reads',
      type: 'counter',
      description: 'The number of temporary view reads on a node.',
      unit: 'rps',
      sources: {
        prometheus: {
          expr: 'couchdb_httpd_temporary_view_reads_total{%(queriesSelector)s}',
        },
      },
    },


    // requests

    requestMethods: {
      name: 'Request methods',
      nameShort: 'Request methods',
      type: 'raw',
      description: 'The request rate split by HTTP Method for a node.',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'rate(couchdb_httpd_request_methods{%(queriesSelector)s}[$__rate_interval]) > 0',
          legendCustomTemplate: legendCustomTemplate + ' - {{method}}',
        },
      },
    },

    averageRequestLatency: {
      name: 'Average request latency',
      nameShort: 'Average request latency',
      type: 'raw',
      description: 'The average request latency for a node.',
      unit: 's',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ', quantile) (couchdb_request_time_seconds{%(queriesSelector)s})',
          legendCustomTemplate: legendCustomTemplate + ' - {{quantile}}',
        },
      },
    },

    bulkRequests: {
      name: 'Bulk requests',
      nameShort: 'Bulk requests',
      type: 'counter',
      description: 'The number of bulk requests on a node.',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'couchdb_httpd_bulk_requests_total{%(queriesSelector)s}',
        },
      },
    },

    responseStatus2xx: {
      name: 'Response status 2XX',
      nameShort: 'Response status 2XX',
      type: 'raw',
      description: 'The number of response status 2XX on a node.',
      unit: 'requests',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (increase(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"2.*"}[$__interval:] offset -$__interval)) != 0',
          legendCustomTemplate: legendCustomTemplate + ' - 2xx',
        },
      },
    },

    responseStatus3xx: {
      name: 'Response status 3XX',
      nameShort: 'Response status 3XX',
      type: 'raw',
      description: 'The number of response status 3XX on a node.',
      unit: 'requests',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (increase(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"3.*"}[$__interval:] offset -$__interval)) != 0',
          legendCustomTemplate: legendCustomTemplate + ' - 3xx',
        },
      },
    },

    responseStatus4xx: {
      name: 'Response status 4XX',
      nameShort: 'Response status 4XX',
      type: 'raw',
      description: 'The number of response status 4XX on a node.',
      unit: 'requests',
      aggLevel: 'instance',
      aggFunction: 'sum',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (increase(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"4.*"}[$__interval:] offset -$__interval)) != 0',
          rangeFunction: 'increase',
          legendCustomTemplate: legendCustomTemplate + ' - 4xx',
        },
      },
    },

    responseStatus5xx: {
      name: 'Response status 5XX',
      nameShort: 'Response status 5XX',
      type: 'raw',
      description: 'The number of response status 5XX on a node.',
      unit: 'requests',
      aggLevel: 'instance',
      aggFunction: 'sum',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (increase(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"5.*"}[$__interval:] offset -$__interval)) != 0',
          rangeFunction: 'increase',
          legendCustomTemplate: legendCustomTemplate + ' - 5xx',
        },
      },
    },

    goodResponseStatuses: {
      name: 'Good response statuses',
      nameShort: 'Good response status',
      type: 'raw',
      description: 'The response rate split by good HTTP statuses for a node.',
      unit: 'reqps',
      sources: {
        prometheus: {
          // filter out 0 values to declutter information that is not pertinent
          expr: 'rate(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"[23].*"}[$__rate_interval]) > 0',
          legendCustomTemplate: legendCustomTemplate + ' - {{code}}',
        },
      },
    },

    errorResponseStatuses: {
      name: 'Error response statuses',
      nameShort: 'Error response status',
      type: 'raw',
      description: 'The response rate split by error HTTP statuses for a node.',
      unit: 'reqps',
      sources: {
        prometheus: {
          // filter out 0 values to declutter information that is not pertinent
          expr: 'rate(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"[45].*"}[$__rate_interval]) > 0',
          legendCustomTemplate: legendCustomTemplate + ' - {{code}}',
        },
      },
    },

    logTypes: {
      name: 'Log types',
      nameShort: 'Log types',
      type: 'raw',
      description: 'The number of logged messages for a node.',
      unit: 'none',
      sources: {
        prometheus: {
          // filter out 0 values to declutter information that is not pertinent
          expr: 'increase(couchdb_couch_log_requests_total{%(queriesSelector)s}[$__interval:] offset -$__interval) > 0',
          legendCustomTemplate: legendCustomTemplate + ' - {{level}}',
        },
      },
    },
  },
}
