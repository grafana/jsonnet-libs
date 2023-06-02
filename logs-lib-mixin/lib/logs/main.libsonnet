local panels = import './panels.libsonnet';
local queries = import './queries/loki.libsonnet';
local g = import 'g.libsonnet';

{
  new(title): {
    local this = self,
    dashboard:
      local titleString = title + ' logs';
      g.dashboard.new(titleString)
      + g.dashboard.withUid(g.util.string.slugify(titleString))
      + g.dashboard.withDescription('Logs dashboard for ' + title)
      + g.dashboard.graphTooltip.withSharedCrosshair()
      + g.dashboard.withVariables(this.queries.variables.toArray)
      + g.dashboard.withPanels(
        //g.util.grid.makeGrid(
        panels.new(
          this.panels.logsVolumeTarget,
          this.panels.logsTarget,
        )
        //, panelWidth=24)
      ),
  },
  withQueries(datasourceRegex, filterSelector, labels, formatParser=null): {
    queries::
      queries.new(
        datasourceRegex,
        filterSelector,
        labels,
        formatParser,
      ),
  },

  addPanels(): {
    local this = self,
    panels+:: {
      logsVolumeTarget: this.queries.logsVolumeTarget(),
      logsTarget: this.queries.logsTarget(),
    },
  },
}
