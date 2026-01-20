local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local generic = import '../../generic/timeSeries/main.libsonnet';
local base = import './base.libsonnet';
base {
  new(
    title='Load / $__interval',
    targets,
    description=|||
      Requests rate per $__interval
    |||,

  ):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + g.panel.timeSeries.fieldConfig.defaults.custom.withDrawStyle('bars')
    + g.panel.timeSeries.queryOptions.withMaxDataPoints(100)
    + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(100)
    + g.panel.timeSeries.fieldConfig.defaults.custom.withStacking({ mode: 'normal' })
    + g.panel.timeSeries.standardOptions.color.withMode(tokens.base.colors.mode.monochrome)
    + g.panel.timeSeries.standardOptions.color.withFixedColor(tokens.base.colors.palette.rate),
}
