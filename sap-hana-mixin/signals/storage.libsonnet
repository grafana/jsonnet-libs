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
      table_cs_top_mem_total_mb: {
        name: 'Table column store top memory',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Top table column store memory consumption in MB.',
        unit: 'decmbytes',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host, database_name, schema_name, table_name) (hanadb_table_cs_top_mem_total_mb{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}} - {{database_name}} - {{schema_name}} - {{table_name}}',
          },
        },
      },
    },
  }
