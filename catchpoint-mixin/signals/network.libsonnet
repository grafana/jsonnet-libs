function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'catchpoint_requests_count',
    },
    signals: {
      requestsCount: {
        name: 'Requests count',
        nameShort: 'Requests',
        type: 'gauge',
        description: 'Total number of requests made.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_requests_count{%(queriesSelector)s}',
          },
        },
      },
      failedRequestsCount: {
        name: 'Failed requests',
        nameShort: 'Failed',
        type: 'gauge',
        description: 'Number of failed requests.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'catchpoint_failed_requests_count{%(queriesSelector)s}',
          },
        },
      },
      requestFailureRatio: {
        name: 'Request failure ratio',
        nameShort: 'Failure ratio',
        type: 'raw',
        description: 'Ratio of failed requests to total requests.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'catchpoint_failed_requests_count{%(queriesSelector)s} / clamp_min(catchpoint_requests_count{%(queriesSelector)s}, 1)',
          },
        },
      },
      // Per-series success ratio. Aggregation (avg_over_time/avg by/bottomk) is
      // applied at the panel level via expression wrappers.
      requestSuccessRatio: {
        name: 'Request success ratio',
        nameShort: 'Success ratio',
        type: 'raw',
        description: 'Ratio of successful requests to total requests.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: '((catchpoint_requests_count{%(queriesSelector)s} - catchpoint_failed_requests_count{%(queriesSelector)s}) / clamp_min(catchpoint_requests_count{%(queriesSelector)s},1))',
          },
        },
      },
      // Ratio of averages, aggregated by node. Kept as a baked expression so
      // the ratio-of-averages semantics match the legacy query exactly.
      requestSuccessRatioByNode: {
        name: 'Requests success ratio',
        nameShort: 'Success ratio',
        type: 'raw',
        description: 'Success ratio of requests made.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: '(avg by (node_name) (catchpoint_requests_count{%(queriesSelector)s}) - avg by (node_name) (catchpoint_failed_requests_count{%(queriesSelector)s})) / avg by (node_name) (catchpoint_requests_count{%(queriesSelector)s})',
          },
        },
      },
      // Ratio of averages, aggregated by test.
      requestSuccessRatioByTest: {
        name: 'Requests success ratio',
        nameShort: 'Success ratio',
        type: 'raw',
        description: 'Success ratio of requests made.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: '(avg by (test_name) (catchpoint_requests_count{%(queriesSelector)s}) - avg by (test_name) (catchpoint_failed_requests_count{%(queriesSelector)s})) / avg by (test_name) (catchpoint_requests_count{%(queriesSelector)s})',
          },
        },
      },
      connectionsCount: {
        name: 'Network connections',
        nameShort: 'Connections',
        type: 'gauge',
        description: 'Number of connections made.',
        unit: 'conn',
        sources: {
          prometheus: {
            expr: 'catchpoint_connections_count{%(queriesSelector)s}',
          },
        },
      },
      hostsCount: {
        name: 'Hosts contacted',
        nameShort: 'Hosts',
        type: 'gauge',
        description: 'Number of hosts contacted.',
        unit: 'hosts',
        sources: {
          prometheus: {
            expr: 'catchpoint_hosts_count{%(queriesSelector)s}',
          },
        },
      },
      cachedCount: {
        name: 'Cache access',
        nameShort: 'Cache hits',
        type: 'gauge',
        description: 'Number of cached elements accessed.',
        unit: '',
        sources: {
          prometheus: {
            expr: 'catchpoint_cached_count{%(queriesSelector)s}',
          },
        },
      },
      redirectionsCount: {
        name: 'Redirects',
        nameShort: 'Redirects',
        type: 'gauge',
        description: 'Number of HTTP redirections encountered.',
        unit: '',
        sources: {
          prometheus: {
            expr: 'catchpoint_redirections_count{%(queriesSelector)s}',
          },
        },
      },
      responseContentSize: {
        name: 'Response content size',
        nameShort: 'Content size',
        type: 'gauge',
        description: 'Size of the HTTP response content.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_response_content_size{%(queriesSelector)s}',
          },
        },
      },
      responseHeaderSize: {
        name: 'Response header size',
        nameShort: 'Header size',
        type: 'gauge',
        description: 'Size of the HTTP response headers.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_response_header_size{%(queriesSelector)s}',
          },
        },
      },
      totalContentSize: {
        name: 'Total content size',
        nameShort: 'Total content',
        type: 'gauge',
        description: 'Total size of the HTTP response content.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_total_content_size{%(queriesSelector)s}',
          },
        },
      },
      totalHeaderSize: {
        name: 'Total header size',
        nameShort: 'Total headers',
        type: 'gauge',
        description: 'Total size of the HTTP response headers.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'catchpoint_total_header_size{%(queriesSelector)s}',
          },
        },
      },
    },
  }
