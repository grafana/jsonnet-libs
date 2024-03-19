local g = import '../../../g.libsonnet';
local generic = import '../../generic/stat/main.libsonnet';
local base = import './base.libsonnet';
local stat = g.panel.stat;
// Uptime panel. expects duration in seconds as input
base {
  new(title='Rate', targets, description='Rate of requests.'):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + stat.standardOptions.color.withMode('fixed')
    + stat.standardOptions.color.withFixedColor('light-purple')
    + stat.options.withGraphMode('none'),
}
