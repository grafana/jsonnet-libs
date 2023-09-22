local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
base {
  new(
    title='Disk I/O',
    targets,
    description=|||
      The number of I/O requests per second for the device/volume.
    |||
  ):
    super.new(title, targets, description),
  stylize():
    super.stylize()
    + timeSeries.standardOptions.withUnit('iops')
    + super.withNegateOutPackets(),
}
