local p = import './panels.libsonnet';
local variables = import './variables.libsonnet';
local targets = import './targets.libsonnet';
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

{
  new(
    title,
    datasourceRegex,
    filterSelector,
    labels,
    formatParser=null,
    showLogsVolume=true,
  ): {

      local this = self,
      variables: variables(
          datasourceRegex,
          filterSelector,
          labels,
      ),

      targets: targets(
          this.variables,
          formatParser,
        ),

      panels: p.new(
        this.targets.logsVolumeTarget,
        this.targets.logsTarget
      ),

      dashboards:{
        local titleString = title + ' logs',
        logs:
        g.dashboard.new(titleString)
        + g.dashboard.withUid(g.util.string.slugify(titleString))
        + g.dashboard.withDescription('Logs dashboard for ' + title)
        + g.dashboard.graphTooltip.withSharedCrosshair()
        + g.dashboard.withVariables(this.variables.toArray)
        + g.dashboard.withPanels(
          //g.util.grid.makeGrid(
          (
            if showLogsVolume then
              [this.panels.logsVolume
              + g.panel.timeSeries.gridPos.withH(6)
              + g.panel.timeSeries.gridPos.withW(24)] 
            else []
          )
          +
          [
            this.panels.logs
            + g.panel.logs.gridPos.withH(18)
            + g.panel.logs.gridPos.withW(24),
          ]
          //, panelWidth=24)
        ),
      }
    },
  // extras
  withShowTime(value): 
    {
      panels+: 
        p.withShowTime(value),
    },
  withEnableLogDetails(value):
    {
      panels+: 
        p.withEnableLogDetails(value),
    },
  
}
