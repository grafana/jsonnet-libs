local g = import '../g.libsonnet';
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

    {
      // InfluxDB cluster overview dashboard
      'influxdb-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withDescription('Dashboard providing an overview of InfluxDB cluster performance and health.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.influxdbClusterOverview,
                this.grafana.rows.influxdbClusterOverviewQueriesAndOperations,
                this.grafana.rows.influxdbClusterOverviewTaskScheduler,
                this.grafana.rows.influxdbClusterOverviewMemoryAndGC,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.custom.new(
              'k',
              values=['5', '10', '20', '50'],
            ) + g.dashboard.variable.custom.generalOptions.withCurrent('5')
            + g.dashboard.variable.custom.generalOptions.withLabel('Top node count')
            + g.dashboard.variable.custom.selectionOptions.withMulti(false)
            + g.dashboard.variable.custom.selectionOptions.withIncludeAll(false),
          ],
          uid + '_cluster_overview',
          tags,
          links { influxdbClusterOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      // InfluxDB instance overview dashboard
      'influxdb-instance-overview.json':
        g.dashboard.new(prefix + ' instance overview')
        + g.dashboard.withDescription('Dashboard providing detailed overview of InfluxDB instance performance, including configuration stats, Go runtime performance, query/request load, and task scheduler activity.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.influxdbInstanceOverview,
                this.grafana.rows.influxdbInstanceOverviewQueriesAndOperations,
                this.grafana.rows.influxdbInstanceOverviewTaskScheduler,
                this.grafana.rows.influxdbInstanceOverviewGo,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_instance_overview',
          tags,
          links { influxdbInstanceOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    }
    +
    if this.config.enableLokiLogs then
      {
        'influxdb-logs.json':
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
