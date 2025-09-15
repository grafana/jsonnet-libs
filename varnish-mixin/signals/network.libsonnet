function(this)
  local legendCustomTemplate = this.legendCustomTemplate;
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    legendCustomTemplate: legendCustomTemplate,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'varnish_main_sessions',
    },
    signals: {
      // Frontend response header bytes
      frontendResponseHeaderBytes: {
        name: 'Frontend response header bytes',
        nameShort: 'Frontend header',
        type: 'counter',
        description: 'Rate of response header bytes for frontend.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'varnish_main_s_resp_hdrbytes{%(queriesSelector)s}',
            rangeFunction: 'irate',
            legendCustomTemplate: legendCustomTemplate + ' - Frontend header',
          },
        },
      },

      // Frontend response body bytes
      frontendResponseBodyBytes: {
        name: 'Frontend response body bytes',
        nameShort: 'Frontend body',
        type: 'counter',
        description: 'Rate of response body bytes for frontend.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'varnish_main_s_resp_bodybytes{%(queriesSelector)s}',
            rangeFunction: 'irate',
            legendCustomTemplate: legendCustomTemplate + ' - Frontend body',
          },
        },
      },

      // Backend response header bytes
      backendResponseHeaderBytes: {
        name: 'Backend response header bytes',
        nameShort: 'Backend header',
        type: 'counter',
        description: 'Rate of response header bytes for backend.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'varnish_backend_beresp_hdrbytes{%(queriesSelector)s}',
            rangeFunction: 'irate',
            legendCustomTemplate: legendCustomTemplate + ' - {{backend}} - Backend header',
          },
        },
      },

      // Backend response body bytes
      backendResponseBodyBytes: {
        name: 'Backend response body bytes',
        nameShort: 'Backend body',
        type: 'counter',
        description: 'Rate of response body bytes for backend.',
        unit: 'decbytes',
        sources: {
          prometheus: {
            expr: 'varnish_backend_beresp_bodybytes{%(queriesSelector)s}',
            rangeFunction: 'irate',
            legendCustomTemplate: legendCustomTemplate + ' - {{backend}} - Backend body',
          },
        },
      },
    },
  }
