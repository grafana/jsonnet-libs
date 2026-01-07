local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local fieldConfig = g.panel.timeSeries.fieldConfig;

// Turns any series to threshold line: dashed red line without gradient fill
{
  local this = self,

  stylize():
    fieldConfig.defaults.custom.withLineStyleMixin(
      {
        fill: 'dash',
        dash: [10, 10],
      }
    )
    + fieldConfig.defaults.custom.withFillOpacity(0)
    + timeSeries.standardOptions.color.withMode(tokens.base.colors.mode.single)
    + timeSeries.standardOptions.color.withFixedColor(tokens.base.colors.palette.threshold),
  stylizeByRegexp(regexp):
    timeSeries.standardOptions.withOverridesMixin(
      fieldOverride.byRegexp.new(regexp)
      + fieldOverride.byRegexp.withPropertiesFromOptions(this.stylize())
    ),
}
