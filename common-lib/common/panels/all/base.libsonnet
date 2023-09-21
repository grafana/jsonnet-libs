local g = import '../../g.libsonnet';

local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
{
  new(title, targets, description=''):
    timeSeries.queryOptions.withTargets(targets)
    // set first target's datasource
    // to panel's datasource if only sinlge type of
    // datasoures are used accross all targets:
    + timeSeries.panelOptions.withDescription(description)
    + if std.length(std.set(targets, function(t) t.datasource.type)) == 1 then
      timeSeries.queryOptions.withDatasource(
        targets[0].datasource.type, targets[0].datasource.uid
      ) else {},
  stylize(): {},
}
