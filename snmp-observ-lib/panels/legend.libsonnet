local g = import '../g.libsonnet';
local legend = g.panel.timeSeries.options.legend;
{
  table:
    legend.withCalcs(['min', 'mean', 'max', 'lastNotNull'])
    + legend.withDisplayMode('table')
    + legend.withPlacement('right')
    + legend.withSortBy('Mean')
    + legend.withSortDesc(true),
}
