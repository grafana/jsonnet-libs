local g = import '../../../g.libsonnet';
local base = import '../base.libsonnet';
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
    super.new(title, targets, description)
    + self.standardOptions.withDecimals(1)
    + self.standardOptions.withUnit('pps'),

  withNegateOutPackets(regexp='/transmit|tx|out/'):
    defaults.custom.withAxisLabel('out(-) | in(+)')
    + timeSeries.standardOptions.withOverrides(
      fieldOverride.byRegexp.new(regexp)
      + fieldOverride.byType.withPropertiesFromOptions(
        defaults.custom.withTransform('negative-Y')
      )
    ),
}
