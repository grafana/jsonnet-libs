function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'solr_metrics_core_errors_total',
    },
    signals: {
      updateHandlerAdds: {
        name: 'Update handlers',
        nameShort: 'Update handlers',
        type: 'raw',
        description: 'Counts the increase in document additions over the specified interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by(job, base_url, collection, core) (increase(solr_metrics_core_update_handler_adds_total{%(queriesSelector)s}[$__interval:])) > 0',
            legendCustomTemplate: '{{collection}} - {{core}}',
          },
        },
      },
      queryLoad5min: {
        name: 'Core search query load',
        nameShort: 'Query load',
        type: 'raw',
        description: 'Average rate of queries per second over a 5-minute period for core search and retrieval operations.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_5minRate{%(queriesSelector)s, searchHandler=~"/select|/query|/get"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      queryP95: {
        name: 'Core search 95p query latency',
        nameShort: 'Query p95',
        type: 'raw',
        description: '95th percentile latency for core search and retrieval queries.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p95_ms{%(queriesSelector)s, searchHandler=~"/select|/query|/get"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      queryP99: {
        name: 'Core search 99p query latency',
        nameShort: 'Query p99',
        type: 'raw',
        description: '99th percentile latency for core search and retrieval queries.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p99_ms{%(queriesSelector)s, searchHandler=~"/select|/query|/get"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      queryLocalLoad5min: {
        name: 'Core search local query load',
        nameShort: 'Local query load',
        type: 'raw',
        description: 'Average rate of local queries per second over a 5-minute period for core search and retrieval operations.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_5minRate{%(queriesSelector)s, searchHandler=~"/select|/query|/get"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      queryLocalP95: {
        name: 'Core search local 95p query latency',
        nameShort: 'Local query p95',
        type: 'raw',
        description: '95th percentile latency for local core search and retrieval queries.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p95_ms{%(queriesSelector)s, searchHandler=~"/select|/query|/get"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      queryLocalP99: {
        name: 'Core search local 99p query latency',
        nameShort: 'Local query p99',
        type: 'raw',
        description: '99th percentile latency for local core search and retrieval queries.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p99_ms{%(queriesSelector)s, searchHandler=~"/select|/query|/get"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      specializedQueryLoad5min: {
        name: 'Specialized query load',
        nameShort: 'Specialized load',
        type: 'raw',
        description: 'Average rate of specialized queries per second over a 5-minute period.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_5minRate{%(queriesSelector)s, searchHandler=~"/sql|/export|/stream"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      specializedQueryP95: {
        name: 'Specialized 95p query latency',
        nameShort: 'Specialized p95',
        type: 'raw',
        description: '95th percentile latency for specialized query types.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p95_ms{%(queriesSelector)s, searchHandler=~"/sql|/export|/stream"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      specializedQueryP99: {
        name: 'Specialized 99p query latency',
        nameShort: 'Specialized p99',
        type: 'raw',
        description: '99th percentile latency for specialized query types.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_p99_ms{%(queriesSelector)s, searchHandler=~"/sql|/export|/stream"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      specializedLocalLoad5min: {
        name: 'Specialized local query load',
        nameShort: 'Spec local load',
        type: 'raw',
        description: 'Average rate of local specialized queries per second over a 5-minute period.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_5minRate{%(queriesSelector)s, searchHandler=~"/sql|/export|/stream"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      specializedLocalP95: {
        name: 'Specialized local 95p query latency',
        nameShort: 'Spec local p95',
        type: 'raw',
        description: '95th percentile latency for specialized local queries.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p95_ms{%(queriesSelector)s, searchHandler=~"/sql|/export|/stream"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      specializedLocalP99: {
        name: 'Specialized local 99p query latency',
        nameShort: 'Spec local p99',
        type: 'raw',
        description: '99th percentile latency for specialized local queries.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'avg by(searchHandler, job, base_url, collection, core) (solr_metrics_core_query_local_p99_ms{%(queriesSelector)s, searchHandler=~"/sql|/export|/stream"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{searchHandler}}',
          },
        },
      },
      cacheEvictions: {
        name: 'Cache evictions',
        nameShort: 'Cache evictions',
        type: 'raw',
        description: 'Number of cache evictions.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by(type, job, base_url, collection, core) (increase(solr_metrics_core_searcher_cache{%(queriesSelector)s, type=~"documentCache|filterCache|queryResultCache", item=~"evictions"}[$__interval:])) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{type}}',
          },
        },
      },
      cacheHitRatio: {
        name: 'Cache hit ratio',
        nameShort: 'Cache hit ratio',
        type: 'raw',
        description: 'Cache hit ratio for documentCache, filterCache, and queryResultCache.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'avg by(type, job, base_url, collection, core) (100 * solr_metrics_core_searcher_cache_ratio{%(queriesSelector)s, type=~"documentCache|filterCache|queryResultCache"}) > 0',
            legendCustomTemplate: '{{collection}} - {{core}} - {{type}}',
          },
        },
      },
      searcherCacheRatio: {
        name: 'Searcher cache hit ratio',
        nameShort: 'Searcher cache %',
        type: 'raw',
        description: 'Cache hit ratio aggregated without instance labels (used for alerting).',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum without(base_url, category, collection, item, replica, shard) (solr_metrics_core_searcher_cache_ratio{%(queriesSelector)s, item="hitratio", type=~"documentCache|filterCache|queryResultCache"})',
            legendCustomTemplate: '{{core}} - {{type}}',
          },
        },
      },
      coreTimeouts: {
        name: 'Core timeouts',
        nameShort: 'Core timeouts',
        type: 'raw',
        description: 'Increase in query timeouts at the core level over the specified interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by(job, base_url, collection, core) (increase(solr_metrics_core_timeouts_total{%(queriesSelector)s}[$__interval:]))',
            legendCustomTemplate: '{{collection}} - {{core}}',
          },
        },
      },
      nodeTimeouts: {
        name: 'Node timeouts',
        nameShort: 'Node timeouts',
        type: 'raw',
        description: 'Increase in node-level query timeouts over the specified interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by(job, base_url) (increase(solr_metrics_node_timeouts_total{%(queriesSelector)s}[$__interval:]))',
            legendCustomTemplate: '{{base_url}}',
          },
        },
      },
      queryErrorRate: {
        name: 'Query error rate',
        nameShort: 'Query errors',
        type: 'raw',
        description: 'Rate of query errors over a 1-minute period.',
        unit: 'errors/min',
        sources: {
          prometheus: {
            expr: 'avg by(job, base_url, collection, core) (solr_metrics_core_query_errors_1minRate{%(queriesSelector)s})',
            legendCustomTemplate: '{{collection}} - {{core}}',
          },
        },
      },
      queryClientErrors: {
        name: 'Query client error rate',
        nameShort: 'Client errors',
        type: 'raw',
        description: 'Rate of client errors over a 1-minute period.',
        unit: 'errors/min',
        sources: {
          prometheus: {
            expr: 'avg by(job, base_url, collection, core) (solr_metrics_core_query_client_errors_1minRate{%(queriesSelector)s})',
            legendCustomTemplate: '{{collection}} - {{core}}',
          },
        },
      },
    },
  }
