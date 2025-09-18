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
      // Backend connections accepted
      backendConnectionsAccepted: {
        name: 'Backend connections accepted',
        nameShort: 'Accepted',
        type: 'counter',
        description: 'Rate of accepted backend connections.',
        unit: 'conn/s',
        sources: {
          prometheus: {
            expr: 'varnish_main_backend_conn{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Accepted',
          },
        },
      },

      // Backend connections recycled
      backendConnectionsRecycled: {
        name: 'Backend connections recycled',
        nameShort: 'Recycled',
        type: 'counter',
        description: 'Rate of recycled backend connections.',
        unit: 'conn/s',
        sources: {
          prometheus: {
            expr: 'varnish_main_backend_recycle{%(queriesSelector)s}',
            rangeFunction: 'irate',
            legendCustomTemplate: legendCustomTemplate + ' - Recycled',
          },
        },
      },

      // Backend connections reused
      backendConnectionsReused: {
        name: 'Backend connections reused',
        nameShort: 'Reused',
        type: 'counter',
        description: 'Rate of reused backend connections.',
        unit: 'conn/s',
        sources: {
          prometheus: {
            expr: 'varnish_main_backend_reuse{%(queriesSelector)s}',
            rangeFunction: 'irate',
            legendCustomTemplate: legendCustomTemplate + ' - Reused',
          },
        },
      },

      // Backend connections busy
      backendConnectionsBusy: {
        name: 'Backend connections busy',
        nameShort: 'Busy',
        type: 'counter',
        description: 'Rate of busy backend connections.',
        unit: 'conn/s',
        sources: {
          prometheus: {
            expr: 'varnish_main_backend_busy{%(queriesSelector)s}',
            rangeFunction: 'irate',
            legendCustomTemplate: legendCustomTemplate + ' - Busy',
          },
        },
      },

      // Backend connections unhealthy
      backendConnectionsUnhealthy: {
        name: 'Backend connections unhealthy',
        nameShort: 'Unhealthy',
        type: 'counter',
        description: 'Rate of unhealthy backend connections.',
        unit: 'conn/s',
        sources: {
          prometheus: {
            expr: 'varnish_main_backend_unhealthy{%(queriesSelector)s}',
            rangeFunction: 'irate',
            legendCustomTemplate: legendCustomTemplate + ' - Unhealthy',
          },
        },
      },
    },
  }
