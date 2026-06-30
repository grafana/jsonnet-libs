local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      istioComponentStatus: {
        name: 'Istio component status',
        nameShort: 'Component status',
        type: 'gauge',
        description: 'Status of Istio components. Values below 1 indicate a component is down.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'istio_build{%(queriesSelector)s}',
          },
        },
      },
    },
  }
