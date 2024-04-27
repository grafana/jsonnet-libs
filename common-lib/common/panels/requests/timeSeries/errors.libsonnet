local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
base {
  new(
    title='Errors',
    targets,
    description='Request errors.'
  ):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    local timeSeries = g.panel.timeSeries;
    local fieldOverride = g.panel.timeSeries.fieldOverride;

    (if allLayers then super.stylize() else {})
    + timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars')
    + timeSeries.queryOptions.withMaxDataPoints(100)
    + timeSeries.fieldConfig.defaults.custom.withFillOpacity(100)
    + timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
    + timeSeries.standardOptions.color.withMode('fixed')
    + timeSeries.standardOptions.color.withFixedColor('light-red')
    + timeSeries.standardOptions.withNoValue('No errors'),
}
