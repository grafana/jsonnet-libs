local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local generic = import '../../generic/timeSeries/main.libsonnet';
local base = import './base.libsonnet';

base {
  new(
    title='Response time',
    targets,
    description=|||
      Response time.
    |||
  ):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + g.panel.timeSeries.standardOptions.color.withMode(tokens.base.colors.mode.monochrome)
    + g.panel.timeSeries.standardOptions.color.withFixedColor(tokens.base.colors.palette.duration)
    + g.panel.timeSeries.standardOptions.withUnit('s'),
}
