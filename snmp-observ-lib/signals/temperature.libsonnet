local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'instance',
    aggFunction: 'avg',
    legendCustomTemplate: '{{entPhysicalName}}{{jnxOperatingDescr}}',
    discoveryMetric: {
      cisco: 'entSensorValue',
      juniper: 'jnxOperatingTemp',
    },
    signals: {
      temperature: {
        name: 'Temperature',
        description: |||
          Temperature sensor.
        |||,
        type: 'gauge',
        unit: 'celsius',
        optional: true,
        sources: {
          cisco: {

            expr: |||
              # https://www.ietf.org/rfc/rfc3433.html
              # entSensorPrecision:
              # If an object of this type contains a value in the range 1 to
              # 9, it represents the number of decimal places in the
              # fractional part of an associated EntitySensorValue fixed-
              # point number.
              # If an object of this type contains a value in the range -8
              # to -1, it represents the number of accurate digits in the
              # associated EntitySensorValue fixed-point number.
              # entSensorScale
              #     SYNTAX INTEGER {
              #         yocto(1),   -- 10^-24
              #         zepto(2),   -- 10^-21
              #         atto(3),    -- 10^-18
              #         femto(4),   -- 10^-15
              #         pico(5),    -- 10^-12
              #         nano(6),    -- 10^-9
              #         micro(7),   -- 10^-6
              #         milli(8),   -- 10^-3
              #         units(9),   -- 10^0
              #         kilo(10),   -- 10^3
              #         mega(11),   -- 10^6
              #         giga(12),   -- 10^9
              #         tera(13),   -- 10^12
              #         exa(14),    -- 10^15
              #         peta(15),   -- 10^18
              #         zetta(16),  -- 10^21
              #         yotta(17)   -- 10^24
              #     }
              (
                entSensorValue{entSensorScale="9", %(ciscoTemperatureSelector)s, %%(queriesSelector)s}
                *10^-entSensorPrecision{%%(queriesSelector)s}
                or
                entSensorValue{entSensorScale="8", %(ciscoTemperatureSelector)s, %%(queriesSelector)s}
                *10^-3
                *10^-entSensorPrecision{%%(queriesSelector)s}
                or 
                entSensorValue{entSensorScale="7", %(ciscoTemperatureSelector)s, %%(queriesSelector)s}
                *10^-6
                *10^-entSensorPrecision{%%(queriesSelector)s}
              )
            ||| % { ciscoTemperatureSelector: this.ciscoTemperatureSelector },
            aggKeepLabels: ['entPhysicalName'],
          },
          juniper: {
            expr: 'jnxOperatingTemp{%(queriesSelector)s}',
            aggKeepLabels: ['jnxOperatingDescr'],
            //ignore entities with no temperature
            exprWrappers: [
              ['(', ')!=0'],
            ],
          },
        },
      },
    },
  }
