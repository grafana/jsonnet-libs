local g = import './g.libsonnet';
local logslib = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';

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

    {
      overview:
        g.dashboard.new(prefix + 'OpenLDAP Overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.uptime { gridPos+: { w: 8 } },
              panels.referrals { gridPos+: { w: 8 } },
              panels.alerts { gridPos+: { w: 8 } },
              panels.connections { gridPos+: { w: 8 } },
              panels.waiters { gridPos+: { w: 8 } },
              panels.directoryEntries { gridPos+: { w: 8 } },
              panels.networkConnectivity { gridPos+: { w: 8 } },
              panels.pduProcessed { gridPos+: { w: 8 } },
              panels.authenticationAttempts { gridPos+: { w: 8 } },
              panels.coreOperations { gridPos+: { w: 12 } },
              panels.auxiliaryOperations { gridPos+: { w: 12 } },
              panels.primaryThreadActivity { gridPos+: { w: 12 } },
              panels.threadQueueManagement { gridPos+: { w: 12 } },
            ], 12, 7
          )
        )
        + root.applyCommon(vars.multiInstance, uid + '-overview', tags, links, annotations, timezone, refresh, period),
    }
    +
    (if this.config.enableLokiLogs then
       {
         logs:
           logslib.new(prefix + 'OpenLDAP logs',
                       datasourceName=this.grafana.variables.datasources.loki.name,
                       datasourceRegex=this.grafana.variables.datasources.loki.regex,
                       filterSelector=this.config.filteringSelector,
                       labels=this.config.groupLabels + this.config.instanceLabels,
                       formatParser=null,
                       showLogsVolume=this.config.showLogsVolume,
                       logsVolumeGroupBy=null)
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
       } else {}),
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
