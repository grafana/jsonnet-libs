local g = import '../g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';
{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local tags = this.config.dashboardTags;
    local uid = g.util.string.slugify(this.config.uid);
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local rows = this.grafana.rows;
    local links = this.grafana.links;

    {
      'tensorflow-overview.json':
        g.dashboard.new(prefix + ' overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              rows.tensorflowOverview +
              rows.tensorflowServingOverview,
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new(
              'model_name',
              query='label_values(:tensorflow:serving:request_count{%(queriesSelector)s}, model_name)' % vars,
            ) + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='model_name', metric=':tensorflow:serving:request_count{%(queriesSelector)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus),
          ],
          uid + '_tensorflow_overview',
          tags,
          links { tensorflowOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    }
    + if this.config.enableLokiLogs then {
      'tensorflow-logs.json':
        logslib.new(
          prefix + ' logs',
          datasourceName=this.grafana.variables.datasources.loki.name,
          datasourceRegex=this.grafana.variables.datasources.loki.regex,
          filterSelector=this.config.filteringSelector,
          labels=this.config.groupLabels + this.config.extraLogLabels,
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
