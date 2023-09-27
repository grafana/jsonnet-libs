local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
//simple info panel with text or count
base {
  stylize():
    // Style choice: No color for simple text panels by default
    stat.options.withColorMode('fixed')
    + stat.standardOptions.color.withFixedColor('text')
    // Style choice: No graph
    + stat.options.withGraphMode('none')
    // Show last value by default, not mean.
    + stat.options.withReduceOptions({})
    + stat.options.reduceOptions.withCalcsMixin(
      [
        'lastNotNull',
      ]
    ),

}
