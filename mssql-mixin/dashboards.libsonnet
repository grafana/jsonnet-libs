local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this)::
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
      mssql_overview:
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.connectionsPanel { gridPos+: { w: 12 } },
              panels.batchRequestsPanel { gridPos+: { w: 12 } },
              panels.severeErrorsPanel { gridPos+: { w: 12 } },
              panels.deadlocksPanel { gridPos+: { w: 12 } },
              panels.osMemoryUsagePanel { gridPos+: { w: 24 } },
              panels.memoryManagerPanel { gridPos+: { w: 16 } },
              panels.committedMemoryUtilizationPanel { gridPos+: { w: 8 } },
            ] + this.grafana.rows.database,
          )
        )
        + root.applyCommon(
          vars.singleInstance,
          uid + '_mssql_overview',
          tags,
          links { mssqlOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      mssql_pages:
        g.dashboard.new(prefix + ' pages')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.pageFileMemoryPanel { gridPos+: { w: 12 } },
              panels.bufferCacheHitPercentagePanel { gridPos+: { w: 12 } },
              panels.pageCheckpointsPanel { gridPos+: { w: 12 } },
              panels.pageFaultsPanel { gridPos+: { w: 12 } },
            ]
          )
        )
        + root.applyCommon(
          vars.singleInstance,
          uid + '_mssql_pages',
          tags,
          links { mssqlPages+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

    }
    +
    if this.config.enableLokiLogs then
      {
        logs:
          logslib.new(
            prefix + ' logs',
            datasourceName=this.grafana.variables.datasources.loki.name,
            datasourceRegex=this.grafana.variables.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.groupLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
          )
          {
            dashboards+:
              {
                logs+:
                  root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { logs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
              },
            panels+:
              {
                logs+:
                  g.panel.logs.options.withEnableLogDetails(true)
                  + g.panel.logs.options.withShowTime(false)
                  + g.panel.logs.options.withWrapLogMessage(false),
              },
            variables+: {
              toArray+: [
                this.grafana.variables.datasources.prometheus { hide: 2 },
              ],
            },
          }.dashboards.logs,
      }
    else {},

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
