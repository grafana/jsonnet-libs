function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    datasource: 'prometheus_datasource',
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'catchpoint_load_time',
    },
    signals: {
      loadTime: {
        name: 'Total load time',
        nameShort: 'Load time',
        type: 'gauge',
        description: 'Total load time.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_load_time{%(queriesSelector)s}',
          },
        },
      },
      documentCompleteTime: {
        name: 'Document completion time',
        nameShort: 'Doc complete',
        type: 'gauge',
        description: 'Time for the browser to fully render the page after all resources are downloaded.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_document_complete_time{%(queriesSelector)s}',
          },
        },
      },
      totalTime: {
        name: 'Total page load time',
        nameShort: 'Total time',
        type: 'gauge',
        description: 'Total time for the webpage to fully load.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_total_time{%(queriesSelector)s}',
          },
        },
      },
      dnsTime: {
        name: 'DNS resolution time',
        nameShort: 'DNS time',
        type: 'gauge',
        description: 'Time taken for DNS resolution.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_dns_time{%(queriesSelector)s}',
          },
        },
      },
      sslTime: {
        name: 'SSL handshake time',
        nameShort: 'SSL time',
        type: 'gauge',
        description: 'Time taken to establish an SSL handshake.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_ssl_time{%(queriesSelector)s}',
          },
        },
      },
      connectTime: {
        name: 'Connection setup time',
        nameShort: 'Connect time',
        type: 'gauge',
        description: 'Time taken to establish a network connection.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_connect_time{%(queriesSelector)s}',
          },
        },
      },
      contentLoadTime: {
        name: 'Content load time',
        nameShort: 'Content load',
        type: 'gauge',
        description: 'Time taken to load content on the webpage.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_content_load_time{%(queriesSelector)s}',
          },
        },
      },
      renderStartTime: {
        name: 'Render start time',
        nameShort: 'Render start',
        type: 'gauge',
        description: 'Time when the browser starts rendering the page.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_render_start_time{%(queriesSelector)s}',
          },
        },
      },
      clientTime: {
        name: 'Client processing time',
        nameShort: 'Client time',
        type: 'gauge',
        description: 'Time spent on client-side processing, including script execution and rendering.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_client_time{%(queriesSelector)s}',
          },
        },
      },
      redirectTime: {
        name: 'Redirect time',
        nameShort: 'Redirect time',
        type: 'gauge',
        description: 'Additional delays encountered due to redirects.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_redirect_time{%(queriesSelector)s}',
          },
        },
      },
      waitTime: {
        name: 'Wait time',
        nameShort: 'Wait time',
        type: 'gauge',
        description: 'Time from successful connection to receiving the first byte (TTFB).',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'catchpoint_wait_time{%(queriesSelector)s}',
          },
        },
      },
    },
  }
