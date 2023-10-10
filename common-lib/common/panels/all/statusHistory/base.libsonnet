local g = import '../../../g.libsonnet';
local base = import '../base.libsonnet';
local statusHistory = g.panel.statusHistory;
local fieldOverride = g.panel.statusHistory.fieldOverride;
local custom = statusHistory.fieldConfig.defaults.custom;
local defaults = statusHistory.fieldConfig.defaults;
local options = statusHistory.options;
base {

  new(title, targets, description=''):
    statusHistory.new(title)
    + super.new(title, targets, description)
    + statusHistory.queryOptions.withMaxDataPoints(50),

  stylize(): {},
}
