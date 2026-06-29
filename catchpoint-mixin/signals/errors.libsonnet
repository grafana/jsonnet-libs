function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'catchpoint_any_error',
    },
    signals: {
      anyError: {
        name: 'Any error',
        nameShort: 'Any error',
        type: 'gauge',
        description: 'Indicates any error occurred during the test.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_any_error{%(queriesSelector)s}',
          },
        },
      },
      errorObjectsLoaded: {
        name: 'Error objects loaded',
        nameShort: 'Object errors',
        type: 'gauge',
        description: 'Number of objects that failed to load.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_error_objects_loaded{%(queriesSelector)s}',
          },
        },
      },
      dnsError: {
        name: 'DNS error',
        nameShort: 'DNS error',
        type: 'gauge',
        description: 'DNS resolution error indicator.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_dns_error{%(queriesSelector)s}',
          },
        },
      },
      loadError: {
        name: 'Load error',
        nameShort: 'Load error',
        type: 'gauge',
        description: 'Page load error indicator.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_load_error{%(queriesSelector)s}',
          },
        },
      },
      timeoutError: {
        name: 'Timeout error',
        nameShort: 'Timeout',
        type: 'gauge',
        description: 'Connection or request timeout error indicator.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_timeout_error{%(queriesSelector)s}',
          },
        },
      },
      connectionError: {
        name: 'Connection error',
        nameShort: 'Conn error',
        type: 'gauge',
        description: 'Connection establishment error indicator.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_connection_error{%(queriesSelector)s}',
          },
        },
      },
      transactionError: {
        name: 'Transaction error',
        nameShort: 'Txn error',
        type: 'gauge',
        description: 'Transaction-level error indicator.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_transaction_error{%(queriesSelector)s}',
          },
        },
      },
    },
  }
