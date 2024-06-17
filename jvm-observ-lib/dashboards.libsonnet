local g = import './g.libsonnet';
{
  new(this):
    {
      'jvm-dashboard.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'JVM overview')
        + g.dashboard.withVariables(this.signals.memory.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-jvm-dashboard')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            std.flattenArrays([
              this.grafana.rows.overview,
              this.process.grafana.rows.process,
              this.grafana.rows.memory,
              this.grafana.rows.gc,
              this.grafana.rows.threads,
              this.grafana.rows.buffers,
              this.grafana.rows.hikari,
              this.grafana.rows.logback,
            ])
          ),
          setPanelIDs=false
        ),
    },
}
