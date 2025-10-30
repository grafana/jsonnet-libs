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
      connections_total_count: {
        name: 'Total connections count',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Total count of database connections.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_connections_total_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      connections_total_count_by_type: {
        name: 'Total connections count by type',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Total count of database connections by type and status.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, connection_type, connection_status) (hanadb_connections_total_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - {{connection_type}} - {{connection_status}}',
          },
        },
      },
    },
  }
