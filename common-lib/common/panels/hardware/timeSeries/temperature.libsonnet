local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local generic = import '../../generic/timeSeries/main.libsonnet';
local base = import './base.libsonnet';
local timeSeries = g.panel.timeSeries;
base {
  new(
    title='Temperature',
    targets,
    description=|||
      Temperature sensors values.
    |||
  ):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true, softMin=0, softMax=100, unit='celsius'):
    (if allLayers then super.stylize() else {})
    + timeSeries.fieldConfig.defaults.custom.withAxisSoftMax(softMax)
    + timeSeries.fieldConfig.defaults.custom.withAxisSoftMin(softMin)
    + timeSeries.standardOptions.withDecimals(1)
    + timeSeries.standardOptions.withUnit(unit)
    // Change color from blue(cold) to red(hot)
    + timeSeries.standardOptions.color.withMode(tokens.base.colors.mode.coldhot)
    + timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),
}
