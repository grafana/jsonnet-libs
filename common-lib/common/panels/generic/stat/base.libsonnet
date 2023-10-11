local g = import '../../../g.libsonnet';
local stat = g.panel.stat;
local base = import '../base.libsonnet';

base {
  new(title, targets, description=''):
    stat.new(title)
    + super.new(title, targets, description),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {}),
}
