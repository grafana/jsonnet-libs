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
      openldapOverview: 
        g.dashboard.new(prefix + 'OpenLDAP Overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.uptimePanel { gridPos+: { w: 8, x: 0, y: 0 } },
              panels.referralsPanel { gridPos+: { w: 8, x: 8, y: 0 } },
              panels.alertsPanel { gridPos+: { w: 8, x: 16, y: 0 } },
              panels.connections__intervalPanel { gridPos+: { w: 8, x: 0, y: 8 } },
              panels.waitersPanel { gridPos+: { w: 8, x: 8, y: 8 } },
              panels.directoryEntries__intervalPanel { gridPos+: { w: 8, x: 16, y: 8 } },
              panels.networkConnectivity__intervalPanel { gridPos+: { w: 8, x: 0, y: 16 } },
              panels.pduProcessed__intervalPanel { gridPos+: { w: 8, x: 8, y: 16 } },
              panels.authenticationAttempts__intervalPanel { gridPos+: { w: 8, x: 16, y: 16 } },
              panels.coreOperations__intervalPanel { gridPos+: { w: 12, x: 0, y: 24 } },
              panels.auxiliaryOperations__intervalPanel { gridPos+: { w: 12, x: 12, y: 24 } },
              panels.primaryThreadActivityPanel { gridPos+: { w: 12, x: 0, y: 32 } },
              panels.threadQueueManagementPanel { gridPos+: { w: 12, x: 12, y: 32 } },
            ], 12, 7
          )
        )
        + root.applyCommon(vars.multiInstance, uid + '-overview', tags, links, annotations, timezone, refresh, period),
    }
    +

    (if this.config.enableLokiLogs then
       {
         logs:
           logslib.new(
             prefix + 'OpenLDAP logs',
             datasourceName=this.grafana.variables.datasources.loki.name,
             datasourceRegex=this.grafana.variables.datasources.loki.regex,
             filterSelector=this.config.filteringSelector,
             labels=this.config.groupLabels + this.config.instanceLabels + this.config.extraLogLabels,
             formatParser='json',
             showLogsVolume=this.config.showLogsVolume,
             logsVolumeGroupBy=this.config.logsVolumeGroupBy,
             extraFilters=this.config.logsExtraFilters
           )
           {
             dashboards+:
               {
                 logs+:
                   // reference to self, already generated variables, to keep them, but apply other common data in applyCommon
                   root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
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
