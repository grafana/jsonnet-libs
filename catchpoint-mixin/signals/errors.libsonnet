// Per-category error indicators feeding the bar gauge on the two drilldown
// dashboards. `pivot` is the label each series is aggregated by; the legend names
// the error category rather than the pivot.
function(this, pivot)
  {
    filteringSelector: this.drilldownSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    datasource: 'prometheus_datasource',
    aggLevel: 'aggKeepLabels',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'catchpoint_any_error',
    },
    signals: {
      errorObjectsLoaded: {
        name: 'Error objects loaded',
        nameShort: 'Object errors',
        type: 'gauge',
        description: 'Number of objects that failed to load.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_error_objects_loaded{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'object loaded',
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'DNS',
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'load',
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'timeout',
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'connection',
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: 'transaction',
          },
        },
      },
    },
  }
