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
    local stat = g.panel.stat;
    {
      fleet:
        g.dashboard.new(prefix + 'Helloworld fleet')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              g.panel.row.new('Row 1'),
              panels.overviewTable1 { gridPos+: { w: 24, h: 16 } },
              panels.timeSeriesPanel1 { gridPos+: { w: 24 } },
              panels.timeSeriesPanel1 { gridPos+: { w: 24 } },
              panels.timeSeriesPanel1 { gridPos+: { w: 12 } },
              panels.timeSeriesPanel1 { gridPos+: { w: 12 } },
              panels.timeSeriesPanel1 { gridPos+: { w: 24 } },
            ], 12, 7
          )
        )
        // hide link to self
        + root.applyCommon(vars.multiInstance, uid + '-fleet', tags, links { backToFleet+:: {}, backToOverview+:: {} }, annotations, timezone, refresh, period),

      overview:
        g.dashboard.new(prefix + 'Helloworld overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              g.panel.row.new('Row 1'),
              panels.statPanel1,
              panels.statPanel1,
              panels.statPanel1,
              panels.statPanel1,
              panels.statPanel1,
              panels.statPanel1,
              panels.statPanel1,
              panels.statPanel1,
              g.panel.row.new('Row 2'),
              panels.timeSeriesPanel1 { gridPos+: { w: 6, h: 6 } },
              panels.timeSeriesPanel1 { gridPos+: { w: 18, h: 6 } },
              g.panel.row.new('Row 3'),
              panels.timeSeriesPanel2 { gridPos+: { w: 6, h: 6 } },
              panels.timeSeriesPanel2 { gridPos+: { w: 18, h: 6 } },
              g.panel.row.new('Row 4'),
              panels.timeSeriesPanel2 { gridPos+: { w: 12, h: 8 } },
              panels.timeSeriesPanel2 { gridPos+: { w: 12, h: 8 } },
              g.panel.row.new('Row 5'),
              panels.timeSeriesPanel2 { gridPos+: { w: 12, h: 8 } },
              panels.timeSeriesPanel2 { gridPos+: { w: 12, h: 8 } },
            ], 6, 2
          )
        )
        + root.applyCommon(vars.singleInstance, uid + '-overview', tags, links { backToOverview+:: {} }, annotations, timezone, refresh, period),

      dashboard3:
        g.dashboard.new(prefix + 'Helloworld dashboard 3')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              g.panel.row.new('Row 1'),
              panels.timeSeriesPanel1,
              panels.timeSeriesPanel1,
              panels.timeSeriesPanel1,
              panels.timeSeriesPanel1,
              panels.timeSeriesPanel1,
              panels.timeSeriesPanel1,
            ], 12, 8
          )
        )
        + root.applyCommon(vars.singleInstance, uid + '-dashboard3', tags, links, annotations, timezone, refresh, period),
    }
    +
    if this.config.enableLokiLogs
    then
      {
        logs:
          logslib.new(prefix + 'Hello world logs',
                      datasourceName=this.grafana.variables.datasources.loki.name,
                      datasourceRegex=this.grafana.variables.datasources.loki.regex,
                      filterSelector=this.config.filteringSelector,
                      labels=this.config.groupLabels + this.config.instanceLabels + this.config.extraLogLabels,
                      formatParser=null,
                      showLogsVolume=this.config.showLogsVolume,
                      logsVolumeGroupBy=this.config.logsVolumeGroupBy,
                      extraFilters=this.config.logsExtraFilters)
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
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(std.objectValues(annotations)),

}
