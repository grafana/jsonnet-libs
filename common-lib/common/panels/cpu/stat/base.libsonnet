local g = import '../../../g.libsonnet';
local stat = g.panel.stat;
local base = import '../../generic/stat/base.libsonnet';

base {
  new(title, targets, description=''):
    super.new(title, targets, description),
}
