local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    legendCustomTemplate: '{{entPhysicalName}}',
    enableLokiLogs: this.enableLokiLogs,
    discoveryMetric: {
      cisco: 'entSensorValue',
    },
    signals: {
      fanSpeed: {
        name: 'Fan speed',
        description: |||
          Fan speed.
        |||,
        type: 'gauge',
        unit: 'rotrpm',
        optional: true,
        sources: {
          cisco: {
            expr: |||
              (entSensorValue{entSensorType="10", entSensorScale="9", %(queriesSelector)s}
              *10^-entSensorPrecision{entSensorType="10", %(queriesSelector)s}
              or 
              entSensorValue{entSensorType="10", entSensorScale="8", %(queriesSelector)s}
              *10^-3
              *10^-entSensorPrecision{entSensorType="10", %(queriesSelector)s}
              or 
              entSensorValue{entSensorType="10", entSensorScale="7", %(queriesSelector)s}
              *10^-6
              *10^-entSensorPrecision{entSensorType="10", %(queriesSelector)s})
            |||,
            aggKeepLabels: ['entPhysicalName'],
          },

        },
      },

    },
  }
