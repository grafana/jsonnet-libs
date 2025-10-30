function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {

      httpRequests: {
        name: 'Client HTTP requests',
        type: 'counter',
        unit: 'reqps',
        description: 'The request rate of client.',
        sources: {
          prometheus: {
            expr: 'squid_client_http_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      httpErrors: {
        name: 'Client HTTP errors',
        type: 'counter',
        unit: 'errors/s',
        description: 'The number of client HTTP errors.',
        sources: {
          prometheus: {
            expr: 'squid_client_http_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      httpHits: {
        name: 'Client HTTP cache hits',
        type: 'counter',
        unit: 'ops',
        description: 'The number of client cache hits.',
        sources: {
          prometheus: {
            expr: 'squid_client_http_hits_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      cacheHitRatio: {
        name: 'Client cache hit ratio',
        type: 'raw',
        unit: 'percent',
        description: 'The client cache hit ratio.',
        sources: {
          prometheus: {
            expr: '(rate(squid_client_http_hits_total{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(squid_client_http_requests_total{%(queriesSelector)s}[$__rate_interval]),1)) * 100',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      httpSentThroughput: {
        name: 'Client HTTP sent throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of client HTTP data sent.',
        sources: {
          prometheus: {
            expr: 'squid_client_http_kbytes_out_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      httpReceivedThroughput: {
        name: 'Client HTTP received throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of client HTTP data received.',
        sources: {
          prometheus: {
            expr: 'squid_client_http_kbytes_in_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      cacheHitThroughput: {
        name: 'Client cache hit throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of client cache hit.',
        sources: {
          prometheus: {
            expr: 'squid_client_http_hit_kbytes_out_bytes_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },
    },
  }
