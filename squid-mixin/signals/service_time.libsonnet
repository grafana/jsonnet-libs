function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {

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
