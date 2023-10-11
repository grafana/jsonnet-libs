local g = import '../../../g.libsonnet';
local stat = g.panel.stat;
// This panel can be used to display gauge metrics with possible values range 0-100%.
// Examples: cpu utilization, memory utilization etc.
{
  new(title, targets, description=''):
    super.new(title, targets, description)
    + self.stylize(),
  stylize():
    stat.standardOptions.withDecimals(1)
    + stat.standardOptions.withUnit('percent')
    + stat.options.withColorMode('value')
    // Change color from blue(cold) to red(hot)
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
