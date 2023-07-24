local g = import '../../g.libsonnet';

local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;

function(title, targets, description='')
  timeSeries.new(title)
  + timeSeries.queryOptions.withTargets(targets)
  + timeSeries.queryOptions.withInterval('1m')
  + timeSeries.panelOptions.withDescription(description)
  + custom.withLineWidth(2)
  + custom.withFillOpacity(10)
  + custom.withShowPoints('never')
  + custom.withGradientMode('opacity')
  + custom.withLineInterpolation('smooth')
  + options.withTooltip(
    options.tooltip.withMode('multi')
    + options.tooltip.withSort('desc')
  )
  + options.withLegend(
    options.legend.withDisplayMode('list')
    + options.legend.withCalcs([])
  )
