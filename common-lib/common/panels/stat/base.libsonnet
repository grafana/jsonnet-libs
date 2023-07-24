local g = import '../../g.libsonnet';
local stat = g.panel.stat;
function(title, targets, description='')

  stat.new(title)
  + stat.queryOptions.withTargets(targets)
  + stat.panelOptions.withDescription(description)
  + stat.queryOptions.withInterval('1m')
