function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      fileCacheHitRatio: {
        name: 'Worker file cache hit ratio',
        type: 'raw',
        description: 'The current file cache hit ratio for an IIS worker process.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, app) (increase(windows_iis_worker_file_cache_hits_total{%(queriesSelector)s, app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_file_cache_queries_total{%(queriesSelector)s, app=~"$application"}[$__interval:]),1)) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      uriCacheHitRatio: {
        name: 'Worker URI cache hit ratio',
        type: 'raw',
        description: 'The current URI cache hit ratio for an IIS worker process.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(instance, job, app) (increase(windows_iis_worker_uri_cache_hits_total{%(queriesSelector)s, app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_uri_cache_queries_total{%(queriesSelector)s, app=~"$application"}[$__interval:]),1)) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      metadataCacheHitRatio: {
        name: 'Worker metadata cache hit ratio',
        type: 'raw',
        description: 'The current metadata cache hit ratio for an IIS worker process.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, app)(increase(windows_iis_worker_metadata_cache_hits_total{%(queriesSelector)s, app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_metadata_cache_queries_total{%(queriesSelector)s, app=~"$application"}[$__interval:]),1)) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      outputCacheHitRatio: {
        name: 'Worker output cache hit ratio',
        type: 'raw',
        description: 'The current output cache hit ratio for an IIS worker process.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by(job, instance, app) (increase(windows_iis_worker_output_cache_hits_total{%(queriesSelector)s, app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_output_queries_total{%(queriesSelector)s, app=~"$application"}[$__interval:]),1))',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },
    },
  }
