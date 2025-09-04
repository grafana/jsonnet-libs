local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  local groupAggListWithInstance = std.join(',', this.groupLabels) + (if std.length(this.instanceLabels) > 0 then ',' + std.join(',', this.instanceLabels) else '');
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: '{{couchbase_cluster}} - ' + std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels)),
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
        nameShort: 'Index requests',
        type: 'raw',
        description: 'Rate of index service requests served.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ') (rate(index_num_requests{%(queriesSelector)s}[$__rate_interval]))',
          },
        },
      },

      // Index cache hit ratio
      indexCacheHitRatio: {
        name: 'Index cache hit ratio',
        nameShort: 'Cache hit %',
        type: 'raw',
        description: 'Ratio at which cache scans result in a hit rather than a miss.',
        unit: 'percentunit',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ') (increase(index_cache_hits{%(queriesSelector)s}[$__interval:] offset $__interval)) / (clamp_min(sum by(' + groupAggListWithInstance + ') (increase(index_cache_hits{%(queriesSelector)s}[$__interval:] offset $__interval)), 1) + sum by(' + groupAggListWithInstance + ') (increase(index_cache_misses{%(queriesSelector)s}[$__interval:] offset $__interval)))',
          },
        },
      },

      // Index average scan latency
      indexAverageScanLatency: {
        name: 'Index average scan latency',
        nameShort: 'Scan latency',
        type: 'raw',
        description: 'Average time to serve a scan request per index.',
        unit: 'ns',
        sources: {
          prometheus: {
            expr: 'sum by(' + groupAggListWithInstance + ', index) (index_avg_scan_latency{%(queriesSelector)s})',
            legendCustomTemplate: '{{couchbase_cluster}} - {{instance}} - {{index}}',
          },
        },
      },
    },
  }
