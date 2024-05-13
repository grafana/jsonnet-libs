local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

{
  new(this):
    {
      local t = this.grafana.targets,
      local stat = g.panel.stat,
      local barGauge = g.panel.barGauge,
      local fieldOverride = g.panel.table.fieldOverride,

    },
}
