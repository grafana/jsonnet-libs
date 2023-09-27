local g = import '../../../g.libsonnet';
local base = import '../../all/timeSeries/main.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
base {
  new(
    title='Memory usage',
    targets,
    description=|||
      RAM (random-access memory) currently in use by the operating system and running applications, in percent.
    |||
  ):
    super.new(title=title, targets=targets, description=description)
    + base.percentage.stylize(),
}
