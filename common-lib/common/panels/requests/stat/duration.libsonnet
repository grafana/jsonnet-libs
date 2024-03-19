local g = import '../../../g.libsonnet';
local generic = import '../../generic/stat/main.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
base {
  new(title='Response time', targets, description='Response time.'):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + stat.standardOptions.color.withMode('fixed')
    + stat.standardOptions.color.withFixedColor('blue')
    + stat.standardOptions.withUnit('s')
    + stat.options.withGraphMode('none'),
}
