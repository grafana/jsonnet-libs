local g = import '../../../g.libsonnet';
local tokens = import '../../../tokens/main.libsonnet';
local timeSeries = g.panel.timeSeries;
local base = import './base.libsonnet';
// This panel can be used to display ratio metrics with possible values range 0-1 (percentunit).
// Examples: error ratio, cache hit ratio etc.
base {
  stylize(allLayers=true):
    (if allLayers then super.stylize() else {})
    + timeSeries.standardOptions.withDecimals(1)
    + timeSeries.standardOptions.withUnit('percentunit')
    // Change color from blue(cold) to red(hot)
    + timeSeries.standardOptions.color.withMode(tokens.base.colors.mode.coldhot)
    + timeSeries.fieldConfig.defaults.custom.withGradientMode('scheme')
    + timeSeries.standardOptions.withMax(1)
    + timeSeries.standardOptions.withMin(0),
}
