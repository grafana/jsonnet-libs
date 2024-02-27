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
        g.dashboard.new(prefix + 'PgBouncer overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.clientsWaitingConnections { gridPos+: { w: 4, h: 4 } },
              panels.activeClientConnections { gridPos+: { w: 4, h: 4 } },
              panels.activeServerConnections { gridPos+: { w: 4, h: 4 } },
              panels.maxDatabaseConnections { gridPos+: { w: 4, h: 4 } },
              panels.maxUserConnections { gridPos+: { w: 4, h: 4 } },
              panels.maxClientConnections { gridPos+: { w: 4, h: 4 } },
              g.panel.row.new('Queries'),
              panels.queriesPooled { gridPos+: { w: 12 } },
              panels.queryDuration { gridPos+: { w: 12 } },
              g.panel.row.new('Network'),
              panels.networkTraffic { gridPos+: { w: 24 } },
              g.panel.row.new('Transactions'),
              panels.transactionRate { gridPos+: { w: 12 } },
              panels.transactionAverageDuration { gridPos+: { w: 12 } },
              g.panel.row.new('Server'),
              panels.serverConnections { gridPos+: { w: 24 } },
              g.panel.row.new('Client'),
              panels.granularActiveClientConnections { gridPos+: { w: 8 } },
              panels.clientsWaiting { gridPos+: { w: 8 } },
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.singleInstance, uid + '-overview', tags, links { pgbouncerOverview+:: {} }, annotations, timezone, refresh, period),
      clusterOverview:
        g.dashboard.new(prefix + 'PgBouncer cluster overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.topDatabaseActiveConnection { gridPos+: { w: 12 } },
              panels.alertsPanel { gridPos+: { w: 12 } },
              panels.topDatabaseQueryPooled { gridPos+: { w: 12 } },
              panels.topDatabaseQueryDuration { gridPos+: { w: 12 } },
              panels.topDatabaseNetworkTraffic { gridPos+: { w: 24 } },
            ], 12, 6
          )
        )
        // hide link to self
        + root.applyCommon(vars.multiCluster, uid + '-cluster-overview', tags, links { clusterOverview+:: {} }, annotations, timezone, refresh, period),
    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          logslib.new(
            prefix + 'PgBouncer logs',
            datasourceName=this.grafana.variables.datasources.loki.name,
            datasourceRegex=this.grafana.variables.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.logLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
            logsVolumeGroupBy=this.config.logsVolumeGroupBy,
          )
          {
            dashboards+:
              {
                logs+:
                  // reference to self, already generated variables, to keep them, but apply other common data in applyCommon
                  root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { logs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
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
