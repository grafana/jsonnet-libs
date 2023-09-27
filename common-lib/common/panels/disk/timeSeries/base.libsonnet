local g = import '../../../g.libsonnet';
local base = import '../../all/timeSeries/main.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
base {
  new(
    title,
    targets,
    description=''
  ):
    super.base.new(title, targets, description)
    // Decrease opacity (would look better with too many timeseries)
    + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(1),
  stylize(): {},
  withNegateOutPackets(regexp='/write|written/'):
    defaults.custom.withAxisLabel('write(-) | read(+)')
    + defaults.custom.withAxisCenteredZero(true)
    + timeSeries.standardOptions.withOverrides(
      fieldOverride.byRegexp.new(regexp)
      + fieldOverride.byRegexp.withPropertiesFromOptions(
        defaults.custom.withTransform('negative-Y')
      )
    ),

}