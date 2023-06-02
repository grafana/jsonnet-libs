local p = import './panels.libsonnet';
local queries = import './queries/loki.libsonnet';
local g = import 'g.libsonnet';

{
  new(
    title,
    datasourceRegex,
    filterSelector,
    labels,
    formatParser=null
  ): {
    local this = self,
    queries::
      queries.new(
        datasourceRegex,
        filterSelector,
        labels,
        formatParser,
      ),

    panels:
      p.new(
        this.queries.logsVolumeTarget(),
        this.queries.logsTarget(),
      ),

    dashboard:
      local titleString = title + ' logs';
      g.dashboard.new(titleString)
      + g.dashboard.withUid(g.util.string.slugify(titleString))
      + g.dashboard.withDescription('Logs dashboard for ' + title)
      + g.dashboard.graphTooltip.withSharedCrosshair()
      + g.dashboard.withVariables(this.queries.variables.toArray)
      + g.dashboard.withPanels(
        //g.util.grid.makeGrid(
        [
          this.panels.logsVolume
          + g.panel.timeSeries.gridPos.withH(6)
          + g.panel.timeSeries.gridPos.withW(24),
          this.panels.logs
          + g.panel.logs.gridPos.withH(18)
          + g.panel.logs.gridPos.withW(24),
        ]
        //, panelWidth=24)
      ),

  },
}
