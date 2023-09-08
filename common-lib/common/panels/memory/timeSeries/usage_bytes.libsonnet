local g = import '../../../g.libsonnet';
local base = import './base.libsonnet';
local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
base + {
  new(
    title='Memory usage',
    targets,
    description='',
    totalRegexp='.*(T|t)otal.*',
  ):
    super.base.new(title=title, targets=targets, description=description)
     + timeSeries.standardOptions.withUnit("bytes")
     + timeSeries.standardOptions.withMin(0)
     + base.threshold.stylizeByRegexp(totalRegexp)
}
