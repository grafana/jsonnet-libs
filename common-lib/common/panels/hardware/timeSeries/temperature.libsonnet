local g = import '../../../g.libsonnet';
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

  stylize(allLayers=true, softMin=0, softMax=100, unit='Celsius'):
    (if allLayers then super.stylize() else {})
    + timeSeries.fieldConfig.defaults.custom.withAxisSoftMax(softMax)
    + timeSeries.fieldConfig.defaults.custom.withAxisSoftMin(softMin)
    + timeSeries.standardOptions.withDecimals(1)
    + timeSeries.standardOptions.withUnit('celsius')
    // Change color from blue(cold) to red(hot)
    + timeSeries.standardOptions.color.withMode('continuous-BlYlRd')
    + timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme'),
}
