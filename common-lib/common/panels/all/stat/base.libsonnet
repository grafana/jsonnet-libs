local g = import '../../../g.libsonnet';
local stat = g.panel.stat;
local base = import '../base.libsonnet';

stat + base {
  new(title, targets, description=''):
    stat.new(title)
    + super.new(title, targets, description)
    + self.stylize(),
  stylize():
    super.stylize(),
}
