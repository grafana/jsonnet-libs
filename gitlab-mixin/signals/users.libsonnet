// for Gitlab user related signals
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'user_session_logins_total',
    },
    signals: {
      sessionLogins: {
        name: 'User sessions',
        nameShort: 'Sessions',
        type: 'counter',
        description: 'The rate of user logins.',
        unit: 'sessions/s',
        sources: {
          prometheus: {
            expr: 'user_session_logins_total{%(queriesSelector)s}',
            legendCustomTemplate: 'sessions',
          },
        },
      },
    },
  }
