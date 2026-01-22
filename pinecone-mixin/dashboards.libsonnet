local g = import './g.libsonnet';

{
  new(this):
    {
      'pinecone-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' overview')
        + g.dashboard.withUid(this.config.uid + '-overview')
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withTimezone(this.config.dashboardTimezone)
        + g.dashboard.withRefresh(this.config.dashboardRefresh)
        + g.dashboard.time.withFrom(this.config.dashboardPeriod)
        + g.dashboard.withVariables(
          this.signals.operations.getVariablesMultiChoice()
        )
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            this.grafana.rows.overview
            + this.grafana.rows.writeOperations
            + this.grafana.rows.readOperations
            + this.grafana.rows.resourceUsage
          )
        ),
    },
}
