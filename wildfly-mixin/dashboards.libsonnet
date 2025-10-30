local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this)::

    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local extraLogLabels = this.config.extraLogLabels;
    {

      'wildfly-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' Overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.requestsRow,
              this.grafana.rows.networkRow,
              this.grafana.rows.sessionsRow,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('server')
            + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='server', metric='wildfly_undertow_request_count_total{%(queriesSelectorGroupOnly)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus),
            g.dashboard.variable.query.new('deployment')
            + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='deployment', metric='wildfly_undertow_active_sessions{%(queriesSelectorGroupOnly)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus),
          ],
          uid + '-overview',
          tags,
          links { wildflyOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
      'wildfly-datasource.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' Datasource')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.connectionsRow,
              this.grafana.rows.transactionsRow,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('datasource')
            + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='data_source', metric='wildfly_datasources_pool_in_use_count{%(queriesSelectorGroupOnly)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus),
          ],
          uid + '-datasource',
          tags,
          links { wildflyDatasource+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

    } + if this.config.enableLokiLogs then {
      'wildfly-logs.json':
        logslib.new(
          this.config.dashboardNamePrefix + ' Logs',
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
