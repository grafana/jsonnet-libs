local g = import '../../../g.libsonnet';
local base = import '../base.libsonnet';
local statusHistory = g.panel.statusHistory;
local fieldOverride = g.panel.statusHistory.fieldOverride;
local custom = statusHistory.fieldConfig.defaults.custom;
local defaults = statusHistory.fieldConfig.defaults;
local options = statusHistory.options;
base {
  new(
    title,
    targets,
    description=''
  ):
    statusHistory.new(title)
    // To avoid 'Too many points error'
    + statusHistory.queryOptions.withMaxDataPoints(50)
    + super.new(title, targets, description),
}
