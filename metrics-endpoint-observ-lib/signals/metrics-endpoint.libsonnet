function(this)
  {
    discoveryMetric: {
      prometheus: 'metrics_endpoint_export_response_success',
    },
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',  // group, instance, or none.
    alertsInterval: '5m',
    signals: {
      scrapeStatus: {
        name: 'Scrape response',
        type: 'gauge',
        description: 'Tracks if the last request to the provided URL was successful or not',
        aggLevel: 'instance',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          prometheus:
            {
              expr: 'metrics_endpoint_export_response_success{%(queriesSelector)s}',
              legendCustomTemplate: '%(aggLegend)s',
            },
        },
      },
      samplesScraped: {
        name: 'Samples scraped',
        type: 'gauge',
        description: 'Number of samples scraped. Every unique metric/label combination counts as a separate sample.',
        unit: 'short',
        sources: {
          prometheus:
            {
              expr: 'scrape_samples_scraped{%(queriesSelector)s}',
              legendCustomTemplate: '%(aggLegend)s',
            },
        },
      },
      topCardinality: {
        name: 'Highest cardinality metrics',
        type: 'raw',
        description: 'Top ten metrics with the highest cardinality. For more information on cardinality, refer to the [cardinality management dashboards](https://grafana.com/docs/grafana-cloud/cost-management-and-billing/analyze-costs/metrics-costs/prometheus-metrics-costs/cardinality-management/)',
        unit: 'short',
        sources: {
          prometheus:
            {
              expr: 'topk(10,count({%(queriesSelector)s}) by (__name__))',
              legendCustomTemplate: '{{ __name__ }}',
            },
        },
      },
      scrapeDuration: {
        name: 'Scrape duration',
        type: 'gauge',
        description: 'How long it takes for the metrics scrape to complete. Long durations might indicate issues with the endpoint.',
        unit: 's',
        sources: {
          prometheus:
            {
              expr: 'scrape_duration_seconds{%(queriesSelector)s}',
            },
        },
      },

    },
  }
