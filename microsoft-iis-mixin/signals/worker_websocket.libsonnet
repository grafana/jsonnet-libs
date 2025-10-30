function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {
      connectionAttempts: {
        name: 'Websocket connection attempts',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of attempted websocket connections for an IIS application.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_websocket_connection_attempts_total{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      connectionAccepted: {
        name: 'Websocket connections accepted',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'The number of accepted websocket connections for an IIS application.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'windows_iis_worker_websocket_connection_accepted_total{%(queriesSelector)s, app=~"$application"}',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },

      connectionSuccessRate: {
        name: 'Websocket connection success rate',
        type: 'raw',
        description: 'The success rate of websocket connection attempts for an IIS application.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by(app, job, instance) (increase(windows_iis_worker_websocket_connection_accepted_total{%(queriesSelector)s, app=~"$application"}[$__interval:]) / clamp_min(increase(windows_iis_worker_websocket_connection_attempts_total{%(queriesSelector)s, app=~"$application"}[$__interval:]),1)) * 100',
            legendCustomTemplate: '{{instance}} - {{app}}',
          },
        },
      },
    },
  }
