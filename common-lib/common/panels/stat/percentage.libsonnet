local g = import '../../g.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
// Panels to display metrics that can go from 0 to 100%.
// (cpu utilization, memory utilization etc).
{
  new(title, targets, description=''): 
    base.new(title, targets, description)
      + stat.standardOptions.withDecimals(1)
      + stat.standardOptions.withUnit('percent')
      + stat.options.withColorMode('value')
      + stat.standardOptions.color.withMode('continuous-BlYlRd')
      + stat.standardOptions.withMax(100)
      + stat.standardOptions.withMin(0)

}
 