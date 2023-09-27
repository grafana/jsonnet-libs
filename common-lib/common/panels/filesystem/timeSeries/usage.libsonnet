local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
base {
  new(
    title='Filesystem space used',
    targets,
    description=|||
      Disk space usage is the amount of storage being used on a device's hard drive or storage medium, in bytes.
    |||,
  ):
    super.new(title, targets, description)
    + timeSeries.standardOptions.withUnit('bytes'),
}
