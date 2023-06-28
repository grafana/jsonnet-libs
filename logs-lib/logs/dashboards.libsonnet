local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';

function(
  title,
  showLogsVolume,
  panels,
  variables,
)
  {
    local this = self,
    local titleString = title + ' logs',
    logs:
      g.dashboard.new(titleString)
      + g.dashboard.withUid(g.util.string.slugify(titleString))
      + g.dashboard.withDescription('Logs dashboard for ' + title)
      + g.dashboard.graphTooltip.withSharedCrosshair()
      + g.dashboard.withVariables(variables.toArray)
      + g.dashboard.withPanels(
        (
          if showLogsVolume then
            [panels.logsVolume
             + g.panel.timeSeries.gridPos.withH(6)
             + g.panel.timeSeries.gridPos.withW(24)]
          else []
        )
        +
        [
          panels.logs
          + g.panel.logs.gridPos.withH(18)
          + g.panel.logs.gridPos.withW(24),
        ]
      ),
  }
