local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local generic = import '../../generic/stat/main.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;

base {
  new(title='Rate', targets, description='Rate of requests.'):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + stat.standardOptions.color.withMode(tokens.base.colors.mode.monochrome)
    + stat.standardOptions.color.withFixedColor(tokens.base.colors.palette.rate)
    + stat.options.withGraphMode('none'),
}
