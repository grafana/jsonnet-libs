local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local stat = g.panel.stat;
local base = import './base.libsonnet';
// This panel can be used to display ratio metrics with possible values range 0-1 (percentunit).
// Examples: error ratio, cache hit ratio etc.
base {
  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + stat.standardOptions.withDecimals(1)
    + stat.standardOptions.withUnit('percentunit')
    + stat.options.withColorMode('value')
    // Change color from blue(cold) to red(hot)
    + stat.standardOptions.color.withMode(tokens.base.colors.mode.coldhot)
    + stat.standardOptions.withMax(1)
    + stat.standardOptions.withMin(0)
    // Show last value by default, not mean.
    + stat.options.withReduceOptions({})
    + stat.options.reduceOptions.withCalcsMixin(
      [
        'lastNotNull',
      ]
    ),
}
