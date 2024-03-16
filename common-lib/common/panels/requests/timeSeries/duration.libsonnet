local g = import '../../../g.libsonnet';
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
    + generic.percentage.stylize(allLayers=false),
}
