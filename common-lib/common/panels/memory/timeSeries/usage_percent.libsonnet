local g = import '../../../g.libsonnet';
local commonTimeSeries = import '../../all/timeSeries/main.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
commonTimeSeries + {
  new(
    title='Memory usage',
    targets,
    description=''
  ):
    super.new(title=title, targets=targets, description=description)
     + commonTimeSeries.percentage.stylize()
}
