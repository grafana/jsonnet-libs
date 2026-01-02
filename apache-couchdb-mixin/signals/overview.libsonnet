function(this) {
  local legendCustomTemplate = '{{ couchdb_cluster }}',
  local groupLabelAggTerm = std.join(', ', this.groupLabels),
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
    clusterCount: {
      name: 'Number of clusters',
      nameShort: 'Clusters',
      type: 'raw',
      description: 'The number of clusters being reported.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'count(count by(' + groupLabelAggTerm + ') (couchdb_request_time_seconds_count{%(queriesSelector)s}))',
        },
      },
    },

    nodeCount: {
      name: 'Number of nodes',
      nameShort: 'Nodes',
      type: 'raw',
      description: 'The number of nodes being reported.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum(count by(' + groupLabelAggTerm + ', instance) (couchdb_request_time_seconds_count{%(queriesSelector)s}))',
        },
      },
    },

    clusterHealth: {
      name: 'Clusters healthy',
      nameShort: 'Cluster healthy',
      type: 'raw',
      description: 'Percentage of clusters that have all nodes that are currently reporting healthy.',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: 'sum(min by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_cluster_is_stable{%(queriesSelector)s})) / count(count by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_cluster_is_stable{%(queriesSelector)s})) * 100',
        },
      },
    },

    openOSFiles: {
      name: 'Open OS files',
      nameShort: 'Open OS files',
      type: 'raw',
      description: 'The total number of file descriptors open aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_open_os_files{%(queriesSelector)s})',
        },
        prometheusWithTotal: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_open_os_files_total{%(queriesSelector)s})',
        },
      },
    },

    openDatabases: {
      name: 'Open databases',
      nameShort: 'Open databases',
      type: 'raw',
      description: 'The total number of open databases aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_open_databases{%(queriesSelector)s})',
        },
        prometheusWithTotal: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_open_databases_total{%(queriesSelector)s})',
        },
      },
    },

    databaseWrites: {
      name: 'Database writes',
      nameShort: 'Database writes',
      type: 'raw',
      description: 'The total number of database writes aggregated across all nodes.',
      unit: 'wps',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (rate(couchdb_database_writes_total{%(queriesSelector)s}[$__rate_interval]))',
        },
      },
    },

    databaseReads: {
      name: 'Database reads',
      nameShort: 'Database reads',
      type: 'raw',
      description: 'The total number of database reads aggregated across all nodes.',
      unit: 'rps',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (rate(couchdb_database_reads_total{%(queriesSelector)s}[$__rate_interval]))',
        },
      },
    },

    viewReads: {
      name: 'View reads',
      nameShort: 'View reads',
      type: 'raw',
      description: 'The total number of view reads aggregated across all nodes.',
      unit: 'rps',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (rate(couchdb_httpd_view_reads_total{%(queriesSelector)s}[$__rate_interval]))',
        },
      },
    },

    viewTimeouts: {
      name: 'View timeouts',
      nameShort: 'View timeouts',
      type: 'raw',
      description: 'The total number of view requests that timed out aggregated across all nodes.',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (rate(couchdb_httpd_view_timeouts_total{%(queriesSelector)s}[$__rate_interval]))',
        },
      },
    },

    temporaryViewReads: {
      name: 'Temporary view reads',
      nameShort: 'Temporary view reads',
      type: 'raw',
      description: 'The total number of temporary view reads aggregated across all nodes.',
      unit: 'rps',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (rate(couchdb_httpd_temporary_view_reads_total{%(queriesSelector)s}[$__rate_interval]))',
        },
      },
    },

    requestMethods: {
      name: 'Request methods',
      nameShort: 'Request methods',
      type: 'raw',
      description: 'The request rate split by HTTP Method aggregated across all nodes.',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ', method) (increase(couchdb_httpd_request_methods{%(queriesSelector)s}[$__interval:] offset $__interval))',
          legendCustomTemplate: legendCustomTemplate + ' - {{method}}',
        },
      },
    },

    requestLatency: {
      name: 'Request latency',
      nameShort: 'Request latency',
      type: 'raw',
      description: 'The request latency aggregated across all nodes.',
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
      type: 'raw',
      description: 'The total number of bulk requests aggregated across all nodes.',
      unit: 'reqps',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (rate(couchdb_httpd_bulk_requests{%(queriesSelector)s}[$__rate_interval]))',
        },
        prometheusWithTotal: {
          expr: 'sum by(' + groupLabelAggTerm + ') (rate(couchdb_httpd_bulk_requests_total{%(queriesSelector)s}[$__rate_interval]))',
        },
      },
    },

    responseStatus2xx: {
      name: 'Response status 2XX',
      nameShort: 'Response status 2XX',
      type: 'raw',
      description: 'The total number of response status 2XX aggregated across all nodes.',
      unit: 'requests',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (increase(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"2.*"}[$__interval:] offset $__interval)) != 0',
          legendCustomTemplate: legendCustomTemplate + ' - 2xx',
        },
      },
    },

    responseStatus3xx: {
      name: 'Response status 3XX',
      nameShort: 'Response status 3XX',
      type: 'raw',
      description: 'The total number of response status 3XX aggregated across all nodes.',
      unit: 'requests',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (increase(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"3.*"}[$__interval:] offset $__interval)) != 0',
          legendCustomTemplate: legendCustomTemplate + ' - 3xx',
        },
      },
    },

    responseStatus4xx: {
      name: 'Response status 4XX',
      nameShort: 'Response status 4XX',
      type: 'raw',
      description: 'The total number of response status 4XX aggregated across all nodes.',
      unit: 'requests',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (increase(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"4.*"}[$__interval:] offset $__interval)) != 0',
          legendCustomTemplate: legendCustomTemplate + ' - 4xx',
        },
      },
    },

    responseStatus5xx: {
      name: 'Response status 5XX',
      nameShort: 'Response status 5XX',
      type: 'raw',
      description: 'The total number of response status 5XX aggregated across all nodes.',
      unit: 'requests',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (increase(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"5.*"}[$__interval:] offset $__interval)) != 0',
          legendCustomTemplate: legendCustomTemplate + ' - 5xx',
        },
      },
    },

    goodResponseStatuses: {
      name: 'Good response statuses',
      nameShort: 'Good response statuses',
      type: 'raw',
      description: 'The total number of good response (HTTP 2xx-3xx) statuses aggregated across all nodes.',
      unit: 'requests',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ', code) (rate(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"[23].*"}[$__rate_interval]))',
          legendCustomTemplate: legendCustomTemplate + ' - {{code}}',
        },
      },
    },

    errorResponseStatuses: {
      name: 'Error response statuses',
      nameShort: 'Error response statuses',
      type: 'raw',
      description: 'The total number of error response (HTTP 4xx-5xx) statuses aggregated across all nodes.',
      unit: 'requests',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ', code) (rate(couchdb_httpd_status_codes{%(queriesSelector)s, code=~"[45].*"}[$__rate_interval]))',
          legendCustomTemplate: legendCustomTemplate + ' - {{code}}',
        },
      },
    },
  },
}
