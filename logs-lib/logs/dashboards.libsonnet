local g = import './g.libsonnet';

function(
  title,
  showLogsVolume,
  panels,
  variables,
)
  {
    local this = self,
    logs:
      g.dashboard.new(title)
      + g.dashboard.withUid(g.util.string.slugify(title))
      + g.dashboard.withVariables(variables.toArray)
      + g.dashboard.withPanels(
        g.util.grid.wrapPanels(
          (
            if showLogsVolume then
              [panels.logsVolume]
            else []
          )
          +
          [
            panels.logs,
          ]
        )
      ),
  }
