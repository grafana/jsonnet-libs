local g = import './g.libsonnet';
{
  new(this):
    {
      'zookeeper-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'ZooKeeper overview')
        + g.dashboard.withVariables(this.signals.zookeeper.getVariablesMultiChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-zookeeper-overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.overview,
                this.grafana.rows.latency,
                this.grafana.rows.jvm.overview + g.panel.row.withCollapsed(true),
                this.grafana.rows.jvm.process + g.panel.row.withCollapsed(true),
                this.grafana.rows.jvm.memory + g.panel.row.withCollapsed(true),
                this.grafana.rows.jvm.gc + g.panel.row.withCollapsed(true),
                this.grafana.rows.jvm.threads + g.panel.row.withCollapsed(true),
                this.grafana.rows.jvm.buffers + g.panel.row.withCollapsed(true),
              ]
            )
          ),
          setPanelIDs=false
        ),
    },
}
