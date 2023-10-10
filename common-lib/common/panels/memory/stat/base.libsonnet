local g = import '../../../g.libsonnet';
local stat = g.panel.stat;
local base = import '../../all/stat/base.libsonnet';

base {
  new(title, targets, description=''):
    super.new(title, targets, description),
}
