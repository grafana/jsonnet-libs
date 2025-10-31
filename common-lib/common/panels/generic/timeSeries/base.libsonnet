local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';

local timeSeries = g.panel.timeSeries;
local fieldOverride = g.panel.timeSeries.fieldOverride;
local custom = timeSeries.fieldConfig.defaults.custom;
local defaults = timeSeries.fieldConfig.defaults;
local options = timeSeries.options;
local standardOptions = g.panel.timeSeries.standardOptions;
local base = import '../base.libsonnet';
base {
  new(title, targets, description=''):
    timeSeries.new(title)
    + super.new(targets, description),

  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + custom.withLineWidth(tokens.panels.timeSeries.lines.width.default)
    + custom.withFillOpacity(tokens.panels.timeSeries.lines.opacity.default)
    + custom.withShowPoints(tokens.panels.timeSeries.lines.showPoints.default)
    + custom.withGradientMode(tokens.panels.timeSeries.lines.gradientMode.default)
    + custom.withLineInterpolation(tokens.panels.timeSeries.lines.interpolation.default)
    // Style choice: Show all values in tooltip, sorted
    + options.tooltip.withMode('multi')
    + options.tooltip.withSort('desc')
    // Style choice: Use simple legend without any values (cleaner look)
    + options.legend.withDisplayMode('list')
    + options.legend.withCalcs([]),

  withDataLink(instanceLabels, drillDownDashboardUid):
    standardOptions.withLinks(
      {
        url: '/d/' + drillDownDashboardUid + '?' + std.join('&', std.map(function(l) 'var-%s=${__field.labels.%s}' % [l, l], instanceLabels)) + '&${__url_time_range}&${datasource:queryparam}',
        title: 'Drill down to this instance',
      }
    ),

}
