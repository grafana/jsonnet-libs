local g = import './g.libsonnet';
{
  local root = self,
  new(this):
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local panels = this.grafana.panels;
    local stat = g.panel.stat;
    {
      'snmp-fleet.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'SNMP fleet overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              this.grafana.rows.fleet.panels,
            )
          ), setPanelIDs=false
        )
        + root.applyCommon(
          std.setUnion(
            this.signals.fleetInterface.getVariablesMultiChoice(),
            this.signals.system.getVariablesSingleChoice(),
            keyF=function(x) x.name
          ),
          uid + '-snmp-fleet',
          tags,
          links { backToFleet+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
      'snmp-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + 'SNMP overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.system,
                this.grafana.rows.interface,
                this.grafana.rows.fru,
                this.grafana.rows.fiber,
                this.grafana.rows.sensors,
              ]
            )
          ), setPanelIDs=false
        )
        + root.applyCommon(
          std.setUnion(
            this.signals.system.getVariablesSingleChoice(),
            this.signals.interface.getVariablesMultiChoice(),
            keyF=function(x) x.name
          ),
          uid + '-snmp-overview',
          tags,
          links,
          annotations,
          timezone,
          refresh,
          period
        ),
    },
  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),
}
