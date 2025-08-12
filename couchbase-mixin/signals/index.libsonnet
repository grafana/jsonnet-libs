local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'index_num_requests',
    },
    signals: {
      // Index service requests
      indexServiceRequests: {
        name: 'Index service requests',
        nameShort: 'Index Requests',
        type: 'counter',
        description: 'Rate of index service requests served.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(couchbase_cluster, instance, job) (rate(index_num_requests{%(queriesSelector)s}[$__rate_interval]))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },

      // Index cache hit ratio
      indexCacheHitRatio: {
        name: 'Index cache hit ratio',
        nameShort: 'Cache Hit %',
        type: 'raw',
        description: 'Ratio at which cache scans result in a hit rather than a miss.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'sum by(couchbase_cluster, job, instance) (increase(index_cache_hits{%(queriesSelector)s}[$__rate_interval])) / (clamp_min(sum by(couchbase_cluster, job, instance) (increase(index_cache_hits{%(queriesSelector)s}[$__rate_interval])), 1) + sum by(couchbase_cluster, job, instance) (increase(index_cache_misses{%(queriesSelector)s}[$__rate_interval])))',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}}',
          },
        },
      },

      // Index average scan latency
      indexAverageScanLatency: {
        name: 'Index average scan latency',
        nameShort: 'Scan Latency',
        type: 'gauge',
        description: 'Average time to serve a scan request per index.',
        unit: 'ns',
        sources: {
          prometheus: {
            expr: 'sum by(couchbase_cluster, index, instance, job) (index_avg_scan_latency{%(queriesSelector)s})',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - {{index}}',
          },
        },
      },
    },
  } 