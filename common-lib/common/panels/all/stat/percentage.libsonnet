local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
// Panels to display metrics that can go from 0 to 100%.
// (cpu utilization, memory utilization etc).
base {
  stylize():
    stat.standardOptions.withDecimals(1)
    + stat.standardOptions.withUnit('percent')
    + stat.options.withColorMode('value')
    + stat.standardOptions.color.withMode('continuous-BlYlRd')
    + stat.standardOptions.withMax(100)
    + stat.standardOptions.withMin(0)
    // Show last value by default, not mean.
    + stat.options.withReduceOptions({})
    + stat.options.reduceOptions.withCalcsMixin(
      [
        'lastNotNull',
      ]
    ),

}
