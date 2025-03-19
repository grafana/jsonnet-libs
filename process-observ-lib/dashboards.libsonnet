local g = import './g.libsonnet';
{
  new(this):
    {
      'process-dashboard.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'process overview')
        + g.dashboard.withVariables(this.signals.process.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-process')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.process,
              ]
            ),
          ),
          setPanelIDs=false
        ),
    },
}
