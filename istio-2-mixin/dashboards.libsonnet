local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
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
      overview:
        g.dashboard.new(prefix + 'Istio overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.proxies { gridPos+: { w: 4, h: 4 } },
              panels.gateways { gridPos+: { w: 4, h: 4 } },
              panels.virtualServices { gridPos+: { w: 4, h: 4 } },
              panels.alertsPanel { gridPos+: { w: 12, h: 8 } },
              panels.destinationRules { gridPos+: { w: 4, h: 4 } },
              panels.serviceEntries { gridPos+: { w: 4, h: 4 } },
              panels.workloadEntries { gridPos+: { w: 4, h: 4 } },
              panels.openFileDescriptors { gridPos+: { w: 12 } },
              panels.vCPUUsage { gridPos+: { w: 12 } },
              panels.heapMemory { gridPos+: { w: 12 } },
              panels.virtualAndResidentMemory { gridPos+: { w: 12 } },
              panels.httpGRPCRequests { gridPos+: { w: 16 } },
              panels.httpResponseOverview { gridPos+: { w: 8 } },
              g.panel.row.new('Control plane'),
              panels.xDSPushes { gridPos+: { w: 8 } },
              panels.xDSPushDelay { gridPos+: { w: 8 } },
              panels.galleyValidations { gridPos+: { w: 8 } },
              panels.xDSEnvoyThroughput { gridPos+: { w: 8 } },
              panels.xDSErrors { gridPos+: { w: 8 } },
              panels.sidecarInjections { gridPos+: { w: 8 } },
              g.panel.row.new('Services'),
              panels.services { gridPos+: { w: 24, h: 8 } },
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.overviewVariables, uid + '-overview', tags, links, annotations, timezone, refresh, period),
    },
  //Apply common options(uids, tags, annotations etc..) to all dashboards above
  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars),
}
