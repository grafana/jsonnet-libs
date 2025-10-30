local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'sum',
    signals: {
      cpu_busy_percent: {
        name: 'CPU busy percent',
        type: 'gauge',
        aggLevel: 'none',
        description: 'CPU usage percentage of the SAP HANA system.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'hanadb_cpu_busy_percent{%(queriesSelector)s}',
            legendCustomTemplate: '{{host}} - core {{core}}',
            aggKeepLabels: ['host', 'core'],
          },
        },
      },

      cpu_busy_percent_by_host: {
        name: 'CPU busy percent by host',
        type: 'gauge',
        aggLevel: 'none',
        aggFunction: 'sum',
        description: 'Total CPU usage percentage by host in the SAP HANA system.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, core) (hanadb_cpu_busy_percent{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - core {{core}}',
          },
        },
      },
    },
  }
