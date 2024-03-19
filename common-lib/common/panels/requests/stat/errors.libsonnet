local g = import '../../../g.libsonnet';
local generic = import '../../generic/stat/main.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
// Uptime panel. expects duration in seconds as input
base {
  new(title='Errors', targets, description='Rate of errors.'):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + stat.standardOptions.color.withMode('fixed')
    + stat.standardOptions.color.withFixedColor('light-red')
    + stat.standardOptions.withNoValue('No errors')
    + stat.options.withGraphMode('none'),
}
