local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';

{
  local root = self,
  new(this)::
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local prefix = this.config.dashboardNamePrefix;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;


    {

      'apache-mesos-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.masterOverview,
              this.grafana.rows.agentOverview,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_overview',
          tags,
          links { mesosOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
    }
    + if this.config.enableLokiLogs then {
      'apache-mesos-logs.json':
        logslib.new(
          prefix + ' logs',
          datasourceName=this.grafana.variables.datasources.loki.name,
          datasourceRegex=this.grafana.variables.datasources.loki.regex,
          filterSelector=this.config.filteringSelector,
          labels=this.config.groupLabels + this.config.extraLogLabels,
          formatParser=null,
          showLogsVolume=this.config.showLogsVolume,
        ) {
          dashboards+: {
            logs+:
              root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { logs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
          },
          panels+: {
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
    } else {},

  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(std.objectValues(links))
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars),
}
