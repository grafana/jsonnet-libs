local g = import '../../../g.libsonnet';
local base = import '../base.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;

function(
  title,
  targets,
  description='',
  negateOutPackets,
)
  base(title, targets, description)
  + timeSeries.standardOptions.withDecimals(1)
  + timeSeries.standardOptions.withUnit('pps')
  +
  (if negateOutPackets then
     defaults.custom.withAxisLabel('out(-) | in(+)')
     + timeSeries.standardOptions.withOverrides(
       fieldOverride.byRegexp.new('/transmit|tx|out/')
       + fieldOverride.byType.withPropertiesFromOptions(
         defaults.custom.withTransform('negative-Y')
       )
     ))
