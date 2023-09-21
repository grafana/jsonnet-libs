local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
// local timeSeries = g.panel.timeSeries;
// local fieldOverride = g.panel.timeSeries.fieldOverride;
// local custom = timeSeries.fieldConfig.defaults.custom;
// local defaults = timeSeries.fieldConfig.defaults;
// local options = timeSeries.options;
base {
  new(
    title='CPU usage by modes',
    targets,
    description='CPU usage by different modes.'
  ):
    super.new(title, targets, description)
    + self.stylize(),

  stylize():
    local timeSeries = g.panel.timeSeries;
    local fieldOverride = g.panel.timeSeries.fieldOverride;
    timeSeries.standardOptions.withUnit('percent')
    + timeSeries.fieldConfig.defaults.custom.withFillOpacity(80)
    + timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
    + timeSeries.standardOptions.withOverrides(
      [
        fieldOverride.byName.new('idle')
        + fieldOverride.byName.withPropertiesFromOptions(
          timeSeries.standardOptions.color.withMode('fixed')
          + timeSeries.standardOptions.color.withFixedColor('light-blue'),
        ),
        fieldOverride.byName.new('interrupt')
        + fieldOverride.byName.withPropertiesFromOptions(
          timeSeries.standardOptions.color.withMode('fixed')
          + timeSeries.standardOptions.color.withFixedColor('light-purple'),
        ),
        fieldOverride.byName.new('user')
        + fieldOverride.byName.withPropertiesFromOptions(
          timeSeries.standardOptions.color.withMode('fixed')
          + timeSeries.standardOptions.color.withFixedColor('light-orange'),
        ),
        fieldOverride.byRegexp.new('system|privileged')
        + fieldOverride.byRegexp.withPropertiesFromOptions(
          timeSeries.standardOptions.color.withMode('fixed')
          + timeSeries.standardOptions.color.withFixedColor('light-red'),
        ),
      ]
    ),
}
