local g = import '../g.libsonnet';
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
    {

      'opensearch-cluster-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' cluster overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.clusterOverviewRow,
              this.grafana.rows.clusterRolesRow,
              this.grafana.rows.resourceUsageRow,
              this.grafana.rows.storageAndTasksRow,
              this.grafana.rows.searchPerformanceRow,
              this.grafana.rows.ingestPerformanceRow,
              this.grafana.rows.indexingPerformanceRow,
            ]),
          )
        ) + root.applyCommon(
          vars.multiInstance,
          uid + '-cluster-overview',
          tags,
          links { opensearchClusterOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
      'opensearch-node-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' node overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
            this.grafana.rows.nodeHealthRow,
            this.grafana.rows.nodeRolesRow,
            this.grafana.rows.nodeJVMRow,
            this.grafana.rows.threadPoolsRow,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('node')
            + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='node', metric='opensearch_os_cpu_percent{%(queriesSelector)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus),

          ],
          uid + '-node-overview',
          tags,
          links { opensearchNodeOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
      'opensearch-search-and-index-overview.json':
        g.dashboard.new(this.config.dashboardNamePrefix + ' search and index overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              this.grafana.rows.searchAndIndexRequestPerformanceRow,
              this.grafana.rows.searchAndIndexIndexingPerformanceRow,
              this.grafana.rows.searchAndIndexCapacityRow,
            ])
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('index')
            + g.dashboard.variable.custom.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.queryTypes.withLabelValues(label='index', metric='opensearch_index_search_fetch_count{%(queriesSelectorGroupOnly)s}' % vars)
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus),
          ],
          uid + '-search-and-index-overview',
          tags,
          links { opensearchSearchAndIndexOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

    } + if this.config.enableLokiLogs then {
      'opensearch-logs.json':
        logslib.new(
          this.config.dashboardNamePrefix + ' logs',
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
