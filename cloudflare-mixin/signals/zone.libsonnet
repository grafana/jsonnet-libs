local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'cloudflare_zone_requests_total',
    },
    signals: {
      requestsTotal: {
        name: 'Zone requests total',
        nameShort: 'Requests',
        type: 'counter',
        description: 'Total number of requests to the zone.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      requestsCached: {
        name: 'Zone cached requests',
        nameShort: 'Cached requests',
        type: 'raw',
        description: 'Number of cached requests to the zone.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'increase(cloudflare_zone_requests_cached{%(queriesSelector)s}[$__interval:]) / increase(cloudflare_zone_requests_total{%(queriesSelector)s}[$__interval:])',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      threatsTotal: {
        name: 'Zone threats',
        nameShort: 'Threats',
        type: 'counter',
        description: 'Number of threats blocked for the zone.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_threats_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      bandwidthTotal: {
        name: 'Zone bandwidth',
        nameShort: 'Bandwidth',
        type: 'counter',
        description: 'Total bandwidth usage for the zone.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_bandwidth_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      bandwidthSslEncrypted: {
        name: 'Zone SSL encrypted bandwidth',
        nameShort: 'SSL bandwidth',
        type: 'counter',
        description: 'SSL encrypted bandwidth for the zone.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_bandwidth_ssl_encrypted{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      bandwidthCached: {
        name: 'Zone cached bandwidth',
        nameShort: 'Cached bandwidth',
        type: 'counter',
        description: 'Cached bandwidth for the zone.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_bandwidth_cached{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      bandwidthContentType: {
        name: 'Zone bandwidth by content type',
        nameShort: 'Bandwidth by type',
        type: 'counter',
        description: 'Bandwidth usage broken down by content type.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_bandwidth_content_type{%(queriesSelector)s}',
            legendCustomTemplate: '{{ content_type }}',
          },
        },
      },
      uniquesTotal: {
        name: 'Zone unique visitors',
        nameShort: 'Unique visitors',
        type: 'counter',
        description: 'Number of unique visitors to the zone.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_uniques_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      pageviewsTotal: {
        name: 'Zone pageviews',
        nameShort: 'Pageviews',
        type: 'counter',
        description: 'Total pageviews for the zone.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_pageviews_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      repeatVisitors: {
        name: 'Zone repeat visitors',
        nameShort: 'Repeat visitors',
        type: 'raw',
        description: 'Number of repeat visitors (pageviews - uniques).',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_pageviews_total{%(queriesSelector)s} - cloudflare_zone_uniques_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      requestsStatus: {
        name: 'Zone requests by status',
        nameShort: 'Requests by status',
        type: 'counter',
        description: 'Requests broken down by HTTP status code.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_requests_status{%(queriesSelector)s}',
            legendCustomTemplate: '{{ status }}',
          },
        },
      },
      requestsBrowserMap: {
        name: 'Zone browser map pageviews',
        nameShort: 'Browser map',
        type: 'counter',
        description: 'Browser map pageviews count.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_requests_browser_map_page_views_count{%(queriesSelector)s}',
            legendCustomTemplate: '{{ zone }}',
          },
        },
      },
      colocationRequests: {
        name: 'Zone colocation requests',
        nameShort: 'Colocation requests',
        type: 'counter',
        description: 'Requests by colocation center.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_colocation_requests_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ colo_code }}',
          },
        },
      },
      // Country-based metrics for geomap visualization
      requestsByCountry: {
        name: 'Zone requests by country',
        nameShort: 'Requests by country',
        type: 'counter',
        description: 'Number of requests to the zone by country.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_requests_country{%(queriesSelector)s}',
            legendCustomTemplate: '{{ country_code }}',
          },
        },
      },
      bandwidthByCountry: {
        name: 'Zone bandwidth by country',
        nameShort: 'Bandwidth by country',
        type: 'counter',
        description: 'Amount of bandwidth used by requests to the zone by country.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_bandwidth_country{%(queriesSelector)s}',
            legendCustomTemplate: '{{ country_code }}',
          },
        },
      },
      threatsByCountry: {
        name: 'Zone threats by country',
        nameShort: 'Threats by country',
        type: 'counter',
        description: 'Number of threats blocked for the zone by country.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'cloudflare_zone_threats_country{%(queriesSelector)s}',
            legendCustomTemplate: '{{ country_code }}',
          },
        },
      },
    },
  }
