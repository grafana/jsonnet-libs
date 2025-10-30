local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    signals: {
      sr_replication: {
        name: 'System replication status',
        type: 'gauge',
        aggLevel: 'none',
        description: 'State of the replicas in the SAP HANA system.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hanadb_sr_replication{%(queriesSelector)s}',
            legendCustomTemplate: '{{secondary_site_name}}',
          },
        },
      },

      sr_ship_delay: {
        name: 'System replication ship delay',
        type: 'gauge',
        aggLevel: 'none',
        aggFunction: 'avg',
        description: 'Average system replication log shipping delay.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'avg by (job, sid, secondary_site_name) (hanadb_sr_ship_delay{%(queriesSelector)s})',
            legendCustomTemplate: '{{secondary_site_name}}',
          },
        },
      },
    },
  }
