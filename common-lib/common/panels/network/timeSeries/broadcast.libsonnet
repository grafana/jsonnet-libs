local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
base {
  new(
    title='Broadcast packets',
    targets,
    description='Packets sent from one source to all network nodes.',
  ):
    super.new(title, targets, description)
    + self.stylize(),

  stylize(allLayers=true):
    (if allLayers == true then super.stylize() else {})
    + timeSeries.standardOptions.withNoValue('No broadcast packets'),
}
