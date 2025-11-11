// for Session related signals
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
      prometheus: 'wildfly_undertow_expired_sessions_total',
    },
    signals: {
      activeSessions: {
        name: 'Active sessions',
        nameShort: 'Active sessions',
        type: 'gauge',
        description: 'Number of active sessions to deployment over time',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_active_sessions{%(queriesSelector)s,deployment=~"$deployment"}',
            legendCustomTemplate: '{{deployment}}',
          },
        },
      },
      expiredSessions: {
        name: 'Expired sessions',
        nameShort: 'Expired sessions',
        type: 'counter',
        description: 'Number of sessions that have expired for a deployment over time',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_expired_sessions_total{%(queriesSelector)s,deployment=~"$deployment"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{deployment}}',
          },
        },
      },
      rejectedSessions: {
        name: 'Rejected sessions',
        nameShort: 'Rejected sessions',
        type: 'counter',
        description: 'Number of sessions that have been rejected from a deployment over time',
        sources: {
          prometheus: {
            expr: 'wildfly_undertow_rejected_sessions_total{%(queriesSelector)s,deployment=~"$deployment"}',
            rangeFunction: 'increase',
            legendCustomTemplate: '{{deployment}}',
          },
        },
      },
    },
  }
