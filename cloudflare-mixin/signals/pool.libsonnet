function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'cloudflare_zone_pool_health_status',
    },
    signals: {
      poolStatus: {
        name: 'Pool status',
        nameShort: 'Status',
        type: 'gauge',
        description: 'Status of the pool (0=unhealthy, 1=healthy).',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_pool_health_status{%(queriesSelector)s}',
            legendCustomTemplate: '{{ pool_name }}',
          },
        },
      },
      requests: {
        name: 'Request rate',
        nameShort: 'Rate',
        type: 'counter',
        description: 'Rate of requests to the pool.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_pool_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ pool_name }}',
          },
        },
      },
    },
  }
