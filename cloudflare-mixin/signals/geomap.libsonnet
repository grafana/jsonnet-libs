function(this) {
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '2m',
  discoveryMetric: {
    prometheus: 'cloudflare_zone_requests_country',
  },
  signals: {
    geoMapByCountry: {
      name: '$geo_metric Distribution',
      nameShort: 'Distribution',
      type: 'counter',
      description: 'Distribution of the selected metric by country.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: '${geo_metric}{%(queriesSelector)s}',
          rangeFunction: 'increase',
        },
      },
    },
    geoMetricsByCountryTable: {
      name: '$geo_metric Distribution',
      nameShort: 'Distribution',
      type: 'counter',
      description: 'Distribution of the selected metric by country.',
      unit: 'short',
      sources: {
        prometheus: {
          expr: '${geo_metric}{%(queriesSelector)s}',
          rangeFunction: 'increase',
        },
      },
    },
  },
}
