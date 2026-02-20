function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'squid_client_http_requests_total',
    },

    signals: {

      clientHTTPRequests: {
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

      clientHTTPErrors: {
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

      clientCacheHitRatio: {
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

      clientHTTPSentThroughput: {
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

      clientHTTPReceivedThroughput: {
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

      clientCacheHitThroughput: {
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

      serverFTPRequests: {
        name: 'Server FTP requests',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of FTP server requests.',
        sources: {
          prometheus: {
            expr: 'squid_server_ftp_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: 'FTP',
          },
        },
      },

      serverHTTPRequests: {
        name: 'Server HTTP requests',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of HTTP server requests.',
        sources: {
          prometheus: {
            expr: 'squid_server_http_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: 'HTTP',
          },
        },
      },

      serverOtherRequests: {
        name: 'Server other requests',
        type: 'counter',
        unit: 'reqps',
        description: 'The number of other server requests.',
        sources: {
          prometheus: {
            expr: 'squid_server_other_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: 'other',
          },
        },
      },

      serverFTPErrors: {
        name: 'Server FTP errors',
        type: 'counter',
        unit: 'errors/s',
        description: 'The number of FTP server request errors.',
        sources: {
          prometheus: {
            expr: 'squid_server_ftp_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: 'FTP',
          },
        },
      },

      serverHTTPErrors: {
        name: 'Server HTTP errors',
        type: 'counter',
        unit: 'errors/s',
        description: 'The number of HTTP server request errors.',
        sources: {
          prometheus: {
            expr: 'squid_server_http_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: 'HTTP',
          },
        },
      },

      serverOtherErrors: {
        name: 'Server other errors',
        type: 'counter',
        unit: 'errors/s',
        description: 'The number of other server request errors.',
        sources: {
          prometheus: {
            expr: 'squid_server_other_errors_total{%(queriesSelector)s}',
            legendCustomTemplate: 'other',
          },
        },
      },

      serverFTPSentThroughput: {
        name: 'Server FTP sent throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of FTP server data sent.',
        sources: {
          prometheus: {
            expr: 'squid_server_ftp_kbytes_out_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'FTP',
          },
        },
      },

      serverHTTPSentThroughput: {
        name: 'Server HTTP sent throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of HTTP server data sent.',
        sources: {
          prometheus: {
            expr: 'squid_server_http_kbytes_out_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'HTTP',
          },
        },
      },

      serverOtherSentThroughput: {
        name: 'Server other sent throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of other server data sent.',
        sources: {
          prometheus: {
            expr: 'squid_server_other_kbytes_out_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'other',
          },
        },
      },

      swapIns: {
        name: 'Server object swap ins',
        type: 'counter',
        unit: 'cps',
        description: 'The number of objects read from disk.',
        sources: {
          prometheus: {
            expr: 'squid_swap_ins_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - read',
          },
        },
      },

      swapOuts: {
        name: 'Server object swap outs',
        type: 'counter',
        unit: 'cps',
        description: 'The number of objects saved to disk.',
        sources: {
          prometheus: {
            expr: 'squid_swap_outs_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{instance}} - saved',
          },
        },
      },

      serverFTPReceivedThroughput: {
        name: 'Server FTP received throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of FTP server data received.',
        sources: {
          prometheus: {
            expr: 'squid_server_ftp_kbytes_in_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'FTP',
          },
        },
      },

      serverHTTPReceivedThroughput: {
        name: 'Server HTTP received throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of HTTP server data received.',
        sources: {
          prometheus: {
            expr: 'squid_server_http_kbytes_in_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'HTTP',
          },
        },
      },

      serverOtherReceivedThroughput: {
        name: 'Server other received throughput',
        type: 'counter',
        unit: 'KBs',
        description: 'The throughput of other server data received.',
        sources: {
          prometheus: {
            expr: 'squid_server_other_kbytes_in_kbytes_total{%(queriesSelector)s}',
            legendCustomTemplate: 'other',
          },
        },
      },

      // HTTP Request service time percentiles
      httpRequestsAll50: {
        name: 'HTTP requests service time p50',
        type: 'gauge',
        unit: 's',
        description: 'HTTP request service time 50th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_HTTP_Requests_All_50{%(queriesSelector)s}',
            legendCustomTemplate: '50%%',
          },
        },
      },

      httpRequestsAll75: {
        name: 'HTTP requests service time p75',
        type: 'gauge',
        unit: 's',
        description: 'HTTP request service time 75th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_HTTP_Requests_All_75{%(queriesSelector)s}',
            legendCustomTemplate: '75%%',
          },
        },
      },

      httpRequestsAll95: {
        name: 'HTTP requests service time p95',
        type: 'gauge',
        unit: 's',
        description: 'HTTP request service time 95th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_HTTP_Requests_All_95{%(queriesSelector)s}',
            legendCustomTemplate: '95%%',
          },
        },
      },

      // Cache hits service time percentiles
      cacheHits50: {
        name: 'Cache hits service time p50',
        type: 'gauge',
        unit: 's',
        description: 'Cache hits service time 50th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_Cache_Hits_50{%(queriesSelector)s}',
            legendCustomTemplate: '50%%',
          },
        },
      },

      cacheHits75: {
        name: 'Cache hits service time p75',
        type: 'gauge',
        unit: 's',
        description: 'Cache hits service time 75th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_Cache_Hits_75{%(queriesSelector)s}',
            legendCustomTemplate: '75%%',
          },
        },
      },

      cacheHits95: {
        name: 'Cache hits service time p95',
        type: 'gauge',
        unit: 's',
        description: 'Cache hits service time 95th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_Cache_Hits_95{%(queriesSelector)s}',
            legendCustomTemplate: '95%%',
          },
        },
      },

      // Cache misses service time percentiles
      cacheMisses50: {
        name: 'Cache misses service time p50',
        type: 'gauge',
        unit: 's',
        description: 'Cache misses service time 50th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_Cache_Misses_50{%(queriesSelector)s}',
            legendCustomTemplate: '50%%',
          },
        },
      },

      cacheMisses75: {
        name: 'Cache misses service time p75',
        type: 'gauge',
        unit: 's',
        description: 'Cache misses service time 75th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_Cache_Misses_75{%(queriesSelector)s}',
            legendCustomTemplate: '75%%',
          },
        },
      },

      cacheMisses95: {
        name: 'Cache misses service time p95',
        type: 'gauge',
        unit: 's',
        description: 'Cache misses service time 95th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_Cache_Misses_95{%(queriesSelector)s}',
            legendCustomTemplate: '95%%',
          },
        },
      },

      // DNS lookup service time percentiles
      dnsLookups50: {
        name: 'DNS lookup service time p50',
        type: 'gauge',
        unit: 's',
        description: 'DNS lookup service time 50th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_DNS_Lookups_50{%(queriesSelector)s}',
            legendCustomTemplate: '50%%',
          },
        },
      },

      dnsLookups75: {
        name: 'DNS lookup service time p75',
        type: 'gauge',
        unit: 's',
        description: 'DNS lookup service time 75th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_DNS_Lookups_75{%(queriesSelector)s}',
            legendCustomTemplate: '75%%',
          },
        },
      },

      dnsLookups95: {
        name: 'DNS lookup service time p95',
        type: 'gauge',
        unit: 's',
        description: 'DNS lookup service time 95th percentile.',
        sources: {
          prometheus: {
            expr: 'squid_DNS_Lookups_95{%(queriesSelector)s}',
            legendCustomTemplate: '95%%',
          },
        },
      },
    },
  }
