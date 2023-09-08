local g = import '../../../g.libsonnet';
local base = import '../stat/base.libsonnet';
local table = g.panel.table;
local fieldOverride = g.panel.table.fieldOverride;
local custom = table.fieldConfig.defaults.custom;
local defaults = table.fieldConfig.defaults;
local options = table.options;
{
  stylize():
    base.percentage.stylize()
}
