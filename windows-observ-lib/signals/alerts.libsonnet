local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'instance',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'ALERTS',
    },
    signals: {
      alertsCritical: {
        name: 'Critical alerts',
        nameShort: 'Critical',
        type: 'raw',
        description: 'Number of critical alerts firing',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'count by (%(agg)s) (max_over_time(ALERTS{%(queriesSelector)s, alertstate="firing", severity="critical"}[1m])) * group by (%(agg)s) (windows_os_info{%(queriesSelector)s})',
          },
        },
      },
      alertsWarning: {
        name: 'Warning alerts',
        nameShort: 'Warning',
        type: 'raw',
        description: 'Number of warning alerts firing',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'count by (%(agg)s) (max_over_time(ALERTS{%(queriesSelector)s, alertstate="firing", severity="warning"}[1m])) * group by (%(agg)s) (windows_os_info{%(queriesSelector)s})',
          },
        },
      },
    },
  }
