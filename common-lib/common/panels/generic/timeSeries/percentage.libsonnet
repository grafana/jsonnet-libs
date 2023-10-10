local g = import '../../../g.libsonnet';
local timeSeries = g.panel.timeSeries;
local base = import './base.libsonnet';
// Style to display metrics that can go from 0 to 100%.
// (cpu utilization, memory utilization etc).
base {
  new(title, targets, description=''):
    super.new(title, targets, description)
    + self.stylize(),

  stylize():
    timeSeries.standardOptions.withDecimals(1)
    + timeSeries.standardOptions.withUnit('percent')
    + timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
    + timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
    + timeSeries.standardOptions.withMax(100)
    + timeSeries.standardOptions.withMin(0),
}
