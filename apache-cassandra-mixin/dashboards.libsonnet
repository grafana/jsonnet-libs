local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
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
      'apache-cassandra-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.overviewRow,
                this.grafana.rows.overviewClientRequestsRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_overview',
          tags,
          links { apacheCassandraOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
      'apache-cassandra-nodes.json':
        g.dashboard.new(prefix + ' nodes')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.nodesRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_nodes',
          tags,
          links { apacheCassandraNodes:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
      'apache-cassandra-keyspaces.json':
        g.dashboard.new(prefix + ' keyspaces')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.keyspacesRow,
              ]
            ),
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_keyspaces',
          tags,
          links { apacheCassandraKeyspaces:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
    } + if this.config.enableLokiLogs then {
      'apache-cassandra-logs.json':
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
                root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { apacheCassandraLogs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
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
