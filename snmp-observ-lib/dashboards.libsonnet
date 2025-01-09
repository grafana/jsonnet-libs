local g = import './g.libsonnet';
{
  new(this):
    {
      'snmp-fleet.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'SNMP fleet overview')
        + g.dashboard.withVariables(
          std.setUnion(
            this.signals.interface.getVariablesMultiChoice(),
            this.signals.system.getVariablesMultiChoice(),
            keyF=function(x) x.name
          )
        )
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-snmp-fleet')
        + g.dashboard.withLinks(this.grafana.links.otherDashboards)
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.system,
                this.grafana.rows.interface,
              ]
            )
          ), setPanelIDs=false
        ),
      'snmp-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' SNMP overview')
        + g.dashboard.withVariables(this.signals.interface.getVariablesSingleChoice())
        + g.dashboard.withTags(this.config.dashboardTags)
        + g.dashboard.withUid(this.config.uid + '-snmp-overview')
        + g.dashboard.withLinks(this.grafana.links.otherDashboards)
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.system,
                this.grafana.rows.interface,
              ]
            )
          ), setPanelIDs=false
        ),
    },
}
