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
      alerts_current_rating: {
        name: 'Current alerts rating',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Count of current system alerts.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'sum by (job, sid, host) (hanadb_alerts_current_rating{%(queriesSelector)s})',
            legendCustomTemplate: '{{host}}',
          },
        },
      },

      alerts_current_rating_detail: {
        name: 'Current alerts rating detail',
        type: 'gauge',
        aggLevel: 'none',
        description: 'Detailed current system alerts with metadata.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'hanadb_alerts_current_rating{%(queriesSelector)s}',
            legendCustomTemplate: '{{alert_details}} {{alert_useraction}}',
          },
        },
      },
    },
  }
