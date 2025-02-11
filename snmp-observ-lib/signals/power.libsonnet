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
    discoveryMetric: {
      cisco: 'entSensorValue',
    },
    signals: {
      dcVoltage: {
        name: 'DC voltage',
        description: |||
          DC voltage sensor.
        |||,
        type: 'gauge',
        unit: 'volt',
        optional: true,
        sources: {

          cisco: {
            expr: |||
              (entSensorValue{entSensorType="4", entSensorScale="9", %(queriesSelector)s}
              *10^-entSensorPrecision{entSensorType="4", %(queriesSelector)s}
              or 
              entSensorValue{entSensorType="4", entSensorScale="8", %(queriesSelector)s}
              *10^-3
              *10^-entSensorPrecision{entSensorType="4", %(queriesSelector)s}
              or 
              entSensorValue{entSensorType="4", entSensorScale="7", %(queriesSelector)s}
              *10^-6
              *10^-entSensorPrecision{entSensorType="4", %(queriesSelector)s})
            |||,
            aggKeepLabels: ['entPhysicalName'],
          },

        },
      },
      power: {
        name: 'Power',
        description: |||
          Power used in Watts.
        |||,
        type: 'gauge',
        unit: 'watt',
        optional: true,
        sources: {
          cisco: {
            expr: |||
              (entSensorValue{entSensorType="6", entSensorScale="9", %(queriesSelector)s}
              *10^-entSensorPrecision{entSensorType="6", %(queriesSelector)s}
              or 
              entSensorValue{entSensorType="6", entSensorScale="8", %(queriesSelector)s}
              *10^-3
              *10^-entSensorPrecision{entSensorType="6", %(queriesSelector)s}
              or 
              entSensorValue{entSensorType="6", entSensorScale="7", %(queriesSelector)s}
              *10^-6
              *10^-entSensorPrecision{entSensorType="6", %(queriesSelector)s})
            |||,
            aggKeepLabels: ['entPhysicalName'],
          },

        },
      },
      rxtxPower: {
        name: 'Receive/Transmit power',
        description: |||
          Receive/Transmit power.
        |||,
        type: 'gauge',
        unit: 'dBm',
        optional: true,
        sources: {
          cisco: {
            expr: |||
              (entSensorValue{entSensorType="14", entSensorScale="9", %(queriesSelector)s}
              *10^-entSensorPrecision{entSensorType="14", %(queriesSelector)s}
              or 
              entSensorValue{entSensorType="14", entSensorScale="8", %(queriesSelector)s}
              *10^-3
              *10^-entSensorPrecision{entSensorType="14", %(queriesSelector)s}
              or 
              entSensorValue{entSensorType="14", entSensorScale="7", %(queriesSelector)s}
              *10^-6
              *10^-entSensorPrecision{entSensorType="14", %(queriesSelector)s})
            |||,
            aggKeepLabels: ['entPhysicalName'],
          },

        },
      },
    },
  }
