function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      fileCacheHitRatio: {
        name: 'File cache hit ratio',
        type: 'raw',
        description: 'The current file cache hit ratio for an IIS server.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'increase(windows_iis_server_file_cache_hits_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(windows_iis_server_file_cache_queries_total{%(queriesSelector)s}[$__interval:]),1) * 100',
            legendCustomTemplate: '{{job}} - {{instance}}',
          },
        },
      },

      uriCacheHitRatio: {
        name: 'URI cache hit ratio',
        type: 'raw',
        description: 'The current URI cache hit ratio for an IIS server.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(instance, job) (increase(windows_iis_server_uri_cache_hits_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(windows_iis_server_uri_cache_queries_total{%(queriesSelector)s}[$__interval:]),1)) * 100',
            legendCustomTemplate: '{{job}} - {{instance}}',
          },
        },
      },

      metadataCacheHitRatio: {
        name: 'Metadata cache hit ratio',
        type: 'raw',
        description: 'The current metadata cache hit ratio for an IIS server.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'increase(windows_iis_server_metadata_cache_hits_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(windows_iis_server_metadata_cache_queries_total{%(queriesSelector)s}[$__interval:]),1) * 100',
            legendCustomTemplate: '{{job}} - {{instance}}',
          },
        },
      },

      outputCacheHitRatio: {
        name: 'Output cache hit ratio',
        type: 'raw',
        description: 'The current output cache hit ratio for an IIS site.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'increase(windows_iis_server_output_cache_hits_total{%(queriesSelector)s}[$__interval:]) / clamp_min(increase(windows_iis_server_output_cache_queries_total{%(queriesSelector)s}[$__interval:]), 1) * 100',
            legendCustomTemplate: '{{job}} - {{instance}}',
          },
        },
      },
    },
  }
