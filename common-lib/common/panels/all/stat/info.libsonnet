local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
//simple info panel with text or count
base {
  new(title, targets, description=''):
    super.new(title, targets, description)
    + self.stylize(),
  stylize():
    // Style choice: Make it bigger
    stat.options.text.withValueSize(20)
    // Style choice: No color for simple text panels by default
    + stat.options.withColorMode('fixed')
    + stat.standardOptions.color.withFixedColor('text')
    // Style choice: No graph
    + stat.options.withGraphMode('none')
    // Show last value by default, not mean.
    + stat.options.reduceOptions.withCalcs([
      'lastNotNull',
    ]),
}
