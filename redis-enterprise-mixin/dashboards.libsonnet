local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local util = import 'common-lib/common/util.libsonnet';
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

    local nodeVars = std.map(
      function(label)
        g.dashboard.variable.query.new(label)
        + g.dashboard.variable.custom.selectionOptions.withMulti(true)
        + g.dashboard.variable.query.queryTypes.withLabelValues(label, metric='node_up')
        + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
        + g.dashboard.variable.query.selectionOptions.withIncludeAll(true),
      this.config.nodeLabels
    );

    local databaseVars = std.map(
      function(label)
        g.dashboard.variable.query.new(label)
        + g.dashboard.variable.custom.selectionOptions.withMulti(true)
        + g.dashboard.variable.custom.selectionOptions.withIncludeAll(true)
        + g.dashboard.variable.query.queryTypes.withLabelValues(label, metric='bdb_up')
        + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus), this.config.databaseLabels
    );


    {
      'redis-enterprise-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.overviewRow,
                this.grafana.rows.overviewNodesKPIsRow,
                this.grafana.rows.overviewDatabaseKPIsRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '_overview',
          tags,
          links { redisEnterpriseOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
      'redis-enterprise-node-overview.json':
        g.dashboard.new(prefix + ' nodes')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.nodesOverviewRow,
                this.grafana.rows.nodesMetricsRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance + nodeVars,
          uid + '_nodes',
          tags,
          links { redisEnterpriseNodes:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
      'redis-enterprise-database-overview.json':
        g.dashboard.new(prefix + ' databases')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.databasesOverviewRow,
                this.grafana.rows.databasesMetricsRow,
                this.grafana.rows.databasesCRDBRow,
              ]
            ),
          )
        ) + root.applyCommon(
          vars.multiInstance + nodeVars + databaseVars,
          uid + '_databases',
          tags,
          links { redisEnterpriseDatabases:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
    } + if this.config.enableLokiLogs then {
      'redis-enterprise-logs.json':
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
                root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { redisEnterpriseLogs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
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
