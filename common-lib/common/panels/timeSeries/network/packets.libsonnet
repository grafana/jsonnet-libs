local g = import '../../../g.libsonnet';
local base = import 'base.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;

function(
  title='Network packets',
  targets,
  description='',
  negateOutPackets=false,
)
  base(title, targets, description, negateOutPackets)
  + timeSeries.standardOptions.withUnit('pps')
