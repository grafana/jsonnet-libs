local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      requestsSourceTotal: {
        name: 'Requests total (source reporter)',
        nameShort: 'Requests (source)',
        type: 'counter',
        description: 'Total number of requests reported by the source proxy.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{reporter="source", %(queriesSelector)s}',
          },
        },
      },

      requestsDestinationTotal: {
        name: 'Requests total (destination reporter)',
        nameShort: 'Requests (dest)',
        type: 'counter',
        description: 'Total number of requests reported by the destination proxy.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'istio_requests_total{reporter="destination", %(queriesSelector)s}',
          },
        },
      },

      requestDurationMillisecondsBucket: {
        name: 'Request duration histogram',
        nameShort: 'Duration',
        type: 'raw',
        description: 'Histogram of HTTP request durations in milliseconds.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'istio_request_duration_milliseconds_bucket{%(queriesSelector)s}',
          },
        },
      },

      requestBytesBucket: {
        name: 'Request bytes histogram',
        nameShort: 'Request bytes',
        type: 'raw',
        description: 'Histogram of HTTP request body sizes in bytes.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'istio_request_bytes_bucket{%(queriesSelector)s}',
          },
        },
      },

      responseBytesBucket: {
        name: 'Response bytes histogram',
        nameShort: 'Response bytes',
        type: 'raw',
        description: 'Histogram of HTTP response body sizes in bytes.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'istio_response_bytes_bucket{%(queriesSelector)s}',
          },
        },
      },
    },
  }
