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

    {
      // Microsoft IIS overview dashboard
      'microsoft-iis-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withDescription('Dashboard providing an overview of Microsoft IIS performance.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.overviewRequests,
                this.grafana.rows.overviewAsyncIO,
                this.grafana.rows.overviewTraffic,
                this.grafana.rows.overviewConnections,
              ]
              +
              if this.config.enableLokiLogs then
                [this.grafana.rows.overviewLogs] else []
                                                      +
                                                      [
                                                        this.grafana.rows.overviewCache,
                                                      ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('site')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('site', 'windows_iis_requests_total{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('Site')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '_overview',
          tags,
          links { microsoftIISOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      // Microsoft IIS applications dashboard
      'microsoft-iis-applications.json':
        g.dashboard.new(prefix + ' applications')
        + g.dashboard.withDescription('Dashboard providing detailed application performance metrics for Microsoft IIS.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.applicationsRequests,
                this.grafana.rows.applicationsWebsocket,
                this.grafana.rows.applicationsWorkerProcesses,
                this.grafana.rows.applicationsCache,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('application')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('app', 'windows_iis_current_application_pool_state{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('Application')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '_applications',
          tags,
          links { microsoftIISApplications+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    }
    +
    if this.config.enableLokiLogs then
      {
        'microsoft-iis-logs.json':
          logslib.new(
            prefix + ' logs',
            datasourceName=vars.datasources.loki.name,
            datasourceRegex=vars.datasources.loki.regex,
            filterSelector=this.config.filteringSelector,
            labels=this.config.logLabels + this.config.extraLogLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
            logsVolumeGroupBy=this.config.logsVolumeGroupBy,
            extraFilters=[]
          )
          {
            dashboards+:
              {
                logs+:
                  root.applyCommon(
                    [],
                    uid + '_logs',
                    tags,
                    links { logs+:: {} },
                    annotations,
                    timezone,
                    refresh,
                    period
                  ),
              },
          }.dashboards.logs,
      } else {},

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
