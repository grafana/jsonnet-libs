local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this):
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local panels = this.grafana.panels;
    local stat = g.panel.stat;
    {
      overview:
        g.dashboard.new('OpenStack overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.placementStatus { gridPos+: { w: 4 } },
              panels.keystoneStatus { gridPos+: { w: 4 } },
              panels.novaStatus { gridPos+: { w: 4 } },
              panels.neutronStatus { gridPos+: { w: 4 } },
              panels.cinderStatus { gridPos+: { w: 4 } },
              panels.glanceStatus { gridPos+: { w: 4 } },
              panels.alertsPanel { gridPos+: { w: 8 } },
              panels.totalResources { gridPos+: { w: 16 } },
              panels.vCPUUsedStat { gridPos+: { w: 4, h: 5 } },
              panels.RAMUsedStat { gridPos+: { w: 4, h: 5 } },
              panels.freeIPsStat { gridPos+: { w: 16, h: 5 } },
              g.panel.row.new('Keystone service'),
              panels.domains { gridPos+: { w: 4 } },
              panels.projects { gridPos+: { w: 4 } },
              panels.regions { gridPos+: { w: 4 } },
              panels.users,
              panels.projectDetails { gridPos+: { w: 24 } },
              g.panel.row.new('Glance service'),
              panels.glanceStatus { gridPos+: { w: 6 } },
              panels.imageCount { gridPos+: { w: 18 } },
              panels.images { gridPos+: { w: 24 } },
            ], 12, 8
          )
        )
        // hide link to self
        + root.applyCommon(vars.multiInstance, uid + '-overview', tags, links { overview+:: {} }, timezone, refresh, period),
      nova:
        g.dashboard.new('OpenStack Nova')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.novaStatus { gridPos+: { w: 6 } },
              panels.vms { gridPos+: { w: 18 } },
              panels.instanceUsage,
              panels.vCPUUsage,
              panels.memoryUsage,
              panels.novaAgents,
            ], 12, 8
          )
        )
        // hide link to self
        + root.applyCommon(vars.multiInstance, uid + '-nova', tags, links { nova+:: {} }, timezone, refresh, period),
      neutron:
        g.dashboard.new('OpenStack Neutron')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.neutronStatus { gridPos+: { w: 6 } },
              panels.networks { gridPos+: { w: 9 } },
              panels.subnets { gridPos+: { w: 9 } },
              panels.routers,
              panels.routerDetails,
              panels.ports { gridPos+: { w: 8 } },
              panels.portDetails { gridPos+: { w: 16 } },
              panels.floatingIPs,
              panels.ipsUsed,
              panels.securityGroups,
              panels.neutronAgents,
            ], 12, 8
          )
        )
        // hide link to self
        + root.applyCommon(vars.multiInstance, uid + '-neutron', tags, links { neutron+:: {} }, timezone, refresh, period),
      cinder:
        g.dashboard.new('OpenStack Cinder')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.cinderStatus { gridPos+: { w: 4 } },
              panels.volumes { gridPos+: { w: 10 } },
              panels.volumeStatus { gridPos+: { w: 10 } },
              panels.volumeUsage,
              panels.backupUsage,
              panels.poolUsage,
              panels.snapshots,
              panels.cinderAgents { gridPos+: { w: 24 } },
            ], 12, 8
          )
        )
        // hide link to self
        + root.applyCommon(vars.multiInstance, uid + '-cinder', tags, links { cinder+:: {} }, timezone, refresh, period),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          logslib.new(
            'OpenStack logs',
            datasourceName=this.grafana.variables.datasources.loki.name,
            datasourceRegex=this.grafana.variables.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.groupLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
            logsVolumeGroupBy=this.config.logsVolumeGroupBy,
          )
          {
            dashboards+:
              {
                logs+:
                  // reference to self, already generated variables, to keep them, but apply other common data in applyCommon
                  root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { logs+:: {} }, timezone=timezone, refresh=refresh, period=period),
              },
            panels+:
              {
                // modify log panel
                logs+:
                  g.panel.logs.options.withEnableLogDetails(true)
                  + g.panel.logs.options.withShowTime(false)
                  + g.panel.logs.options.withWrapLogMessage(false),
              },
            variables+: {
              // add prometheus datasource for annotations processing
              toArray+: [
                this.grafana.variables.datasources.prometheus { hide: 2 },
              ],
            },
          }.dashboards.logs,
      }
    else {},

  // Apply common options(uids, tags, annotations etc..) to all dashboards above
  applyCommon(vars, uid, tags, links, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars),
}
