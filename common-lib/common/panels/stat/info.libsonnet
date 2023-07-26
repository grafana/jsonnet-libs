local g = import '../../g.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
//simple info panel with text or count
base {
  new(title, targets, description=''):
    super.new(title, targets, description)
    + stat.options.withColorMode('fixed')
    + stat.options.text.withValueSize(20)
    + stat.standardOptions.color.withFixedColor('text')
    + stat.options.withGraphMode('none')
    + stat.options.reduceOptions.withCalcs([
      'lastNotNull',
    ]),
}
