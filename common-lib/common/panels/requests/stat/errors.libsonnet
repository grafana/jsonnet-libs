local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local generic = import '../../generic/stat/main.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;

base {
  new(title='Errors', targets, description='Rate of errors.'):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + stat.standardOptions.color.withMode(tokens.base.colors.mode.monochrome)
    + stat.standardOptions.color.withFixedColor(tokens.base.colors.palette.errors)
    + stat.standardOptions.withNoValue('No errors')
    + stat.options.withGraphMode('none'),
}
