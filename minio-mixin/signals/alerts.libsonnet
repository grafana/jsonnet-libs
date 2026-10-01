// Firing alerts for annotations. Keeps `alertname` so the annotation text can show it.
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'count',
    discoveryMetric: {
      prometheus: 'minio_version_info',
    },
    signals: {
      alertsCritical: {
        name: 'Critical alerts',
        nameShort: 'Critical',
        type: 'raw',
        unit: 'none',
        description: 'Firing critical alerts.',
        sources: {
          prometheus: {
            expr: 'count by (%(agg)s, alertname) (ALERTS{alertstate="firing", severity="critical", %(queriesSelector)s})',
          },
        },
      },
      alertsWarning: {
        name: 'Warning alerts',
        nameShort: 'Warning',
        type: 'raw',
        unit: 'none',
        description: 'Firing warning alerts.',
        sources: {
          prometheus: {
            expr: 'count by (%(agg)s, alertname) (ALERTS{alertstate="firing", severity="warning", %(queriesSelector)s})',
          },
        },
      },
    },
  }
