local g = import '../../../g.libsonnet';
local base = import 'base.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
base {
  new(
    title='Network packets',
    targets,
    description='',
  ):
    super.new(title, targets, description)
    + timeSeries.standardOptions.withUnit('pps')
}