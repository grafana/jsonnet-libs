function(this)
  local legendCustomTemplate = this.legendCustomTemplate;
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'varnish_main_sessions',
    },
    signals: {
      // Cache hit rate as percentage
      cacheHitRate: {
        name: 'Cache hit rate',
        nameShort: 'Hit rate',
        type: 'raw',
        description: 'Rate of cache hits to misses.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'avg((rate(varnish_main_cache_hit{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(varnish_main_cache_hit{%(queriesSelector)s}[$__rate_interval]) + rate(varnish_main_cache_miss{%(queriesSelector)s}[$__rate_interval]), 1))) * 100',
          },
        },
      },

      // Cache hit ratio for timeseries
      cacheHitRatio: {
        name: 'Cache hit ratio',
        nameShort: 'Hit ratio',
        type: 'raw',
        description: 'Ratio of cache hits to cache misses.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'avg by (instance, job) ((rate(varnish_main_cache_hit{%(queriesSelector)s}[$__rate_interval]) / clamp_min(rate(varnish_main_cache_hit{%(queriesSelector)s}[$__rate_interval]) + rate(varnish_main_cache_miss{%(queriesSelector)s}[$__rate_interval]), 1))) * 100',
          },
        },
      },

      // Cache hits rate
      cacheHits: {
        name: 'Cache hits',
        nameShort: 'Hits',
        type: 'raw',
        description: 'The rate of cache hits.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'irate(varnish_main_cache_hit{%(queriesSelector)s}[$__rate_interval])',
          },
        },
      },

      // Cache hit pass rate
      cacheHitPass: {
        name: 'Cache hit pass',
        nameShort: 'Hit pass',
        type: 'raw',
        description: 'Rate of cache hits for pass objects (fulfilled requests that are not cached).',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'irate(varnish_main_cache_hitpass{%(queriesSelector)s}[$__rate_interval])',
          },
        },
      },

      // Cache events - expired objects
      cacheExpired: {
        name: 'Cache expired',
        nameShort: 'Expired',
        type: 'raw',
        description: 'Rate of expired objects.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'irate(varnish_main_n_expired{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: legendCustomTemplate + ' - Expired',
          },
        },
      },

      // Cache events - LRU nuked objects
      cacheLruNuked: {
        name: 'Cache LRU nuked',
        nameShort: 'LRU nuked',
        type: 'raw',
        description: 'Rate of LRU (least recently used) nuked objects.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'irate(varnish_main_n_lru_nuked{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: legendCustomTemplate + ' - Nuked',
          },
        },
      },
    },
  }
