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
    + g.panel.timeSeries.standardOptions.color.withMode('fixed')
    + g.panel.timeSeries.standardOptions.color.withFixedColor('light-red'),
}
