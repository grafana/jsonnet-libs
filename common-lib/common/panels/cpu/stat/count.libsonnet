local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;

base {
  new(title='CPU count', targets, description=''):
    super.new(title, targets, description)
    + base.info.stylize()
}
