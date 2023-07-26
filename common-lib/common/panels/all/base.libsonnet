local g = import 'g.libsonnet';

local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
{
  new(title, targets, description=''):
    timeSeries.queryOptions.withInterval('1m')
    + timeSeries.queryOptions.withTargets(targets)
    + timeSeries.panelOptions.withDescription(description),
}
