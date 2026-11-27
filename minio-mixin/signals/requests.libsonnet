function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'group',
    aggFunction: 'sum',
    discoveryMetric: {
      prometheus: 'minio_version_info',
    },
    signals: {
      requests: {
        name: 'Requests',
        type: 'counter',
        unit: 'reqps',
        description: 'Rate of S3 requests, by API.',
        sources: {
          prometheus: {
            expr: 's3_requests_total{%(queriesSelector)s}',
            aggKeepLabels: ['api'],
            legendCustomTemplate: '{{api}}',
          },
        },
      },
      ttfb: {
        name: 'Time to first byte',
        nameShort: 'TTFB',
        type: 'histogram',
        unit: 's',
        description: 'Time to first byte of S3 requests.',
        sources: {
          prometheus: {
            expr: 's3_ttfb_seconds_bucket{%(queriesSelector)s}',
          },
        },
      },
      ttfbAverage: {
        name: 'Average time to first byte',
        nameShort: 'Average',
        type: 'raw',
        unit: 's',
        description: 'Average time to first byte of S3 requests.',
        sources: {
          // Ratio of sums: `sum` is intentional; the by-clause must stay %(agg)s.
          prometheus: {
            expr: |||
              sum by (%(agg)s) (rate(s3_ttfb_seconds_sum{%(queriesSelector)s}[%(interval)s]))
              /
              sum by (%(agg)s) (rate(s3_ttfb_seconds_count{%(queriesSelector)s}[%(interval)s]))
            |||,
          },
        },
      },
    },
  }
