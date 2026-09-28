// Network and response-size breakdown for the two drilldown dashboards.
// `pivot` is the label each series is aggregated by, see signals/timing.libsonnet.
function(this, pivot)
  {
    filteringSelector: this.drilldownSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    datasource: 'prometheus_datasource',
    aggLevel: 'aggKeepLabels',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'catchpoint_requests_count',
    },
    signals: {
      // Raw because the value divides two metrics. Legacy takes the ratio of the
      // per-pivot averages rather than averaging the per-series ratio, so the
      // aggregation is part of the expression and cannot come from aggKeepLabels.
      requestSuccessRatio: {
        name: 'Requests success ratio',
        nameShort: 'Success ratio',
        type: 'raw',
        description: 'Success ratio of requests made.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: '(avg by (' + pivot + ') (catchpoint_requests_count{%(queriesSelector)s}) - avg by (' + pivot + ') (catchpoint_failed_requests_count{%(queriesSelector)s})) / avg by (' + pivot + ') (catchpoint_requests_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{%s}}' % pivot,
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: '{{%s}}' % pivot,
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: '{{%s}}' % pivot,
          },
        },
      },
      cachedCount: {
        name: 'Cache access',
        nameShort: 'Cache hits',
        type: 'gauge',
        description: 'Number of cached elements accessed.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_cached_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: '{{%s}}' % pivot,
          },
        },
      },
      redirectionsCount: {
        name: 'Redirects',
        nameShort: 'Redirects',
        type: 'gauge',
        description: 'Number of HTTP redirections encountered.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'catchpoint_redirections_count{%(queriesSelector)s}',
            aggKeepLabels: [pivot],
            legendCustomTemplate: '{{%s}}' % pivot,
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: '{{%s}} - content' % pivot,
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: '{{%s}} - header' % pivot,
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: '{{%s}} - content' % pivot,
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
            aggKeepLabels: [pivot],
            legendCustomTemplate: '{{%s}} - header' % pivot,
          },
        },
      },
    },
  }
