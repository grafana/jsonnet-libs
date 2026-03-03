function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'count',
    discoveryMetric: {
      prometheus: 'ALERTS',
    },
    signals: {
      alerts: {
        name: 'Firing alerts',
        nameShort: 'Alerts',
        description: 'Firing alerts.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ALERTS{alertstate="firing", %(queriesSelector)s}',
          },
        },
      },
      alertsCritical: {
        name: 'Critical alert',
        nameShort: 'Critical',
        description: 'Critical alerts.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ALERTS{alertstate="firing", severity="critical", %(queriesSelector)s}',
          },
        },
      },
      alertsWarning: {
        name: 'Warning alert',
        nameShort: 'Warnings',
        description: 'Warning alerts.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ALERTS{alertstate="firing", severity="warning", %(queriesSelector)s}',
          },
        },
      },
      alertsInfo: {
        name: 'Info alert',
        nameShort: 'Info',
        description: 'Info alerts.',
        type: 'gauge',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ALERTS{alertstate="firing", severity="info", %(queriesSelector)s}',
          },
        },
      },
    },
  }
