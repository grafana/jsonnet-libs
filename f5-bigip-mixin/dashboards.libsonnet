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
      'bigip-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.clusterOverviewRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.custom.new('k', values=['5', '10', '20', '50'])
            + g.dashboard.variable.query.selectionOptions.withMulti(false)
            + g.dashboard.variable.custom.generalOptions.withCurrent('5')
            + g.dashboard.variable.custom.generalOptions.withLabel('Top node count')
            + g.dashboard.variable.query.refresh.onTime(),


            g.dashboard.variable.query.new('bigip_partition')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('partition', 'bigip_node_status_availability_state{' + this.config.filteringSelector + '}')
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP partition')
            + g.dashboard.variable.query.refresh.onTime(),


          ],
          uid + '_cluster_overview',
          tags,
          links { f5BigipClusterOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      'bigip-node-overview.json':
        g.dashboard.new(prefix + ' node overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.nodeOverviewRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('bigip_node')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('node', 'bigip_node_status_availability_state{' + this.config.filteringSelector + '}')
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP node')
            + g.dashboard.variable.query.refresh.onTime(),

            g.dashboard.variable.query.new('bigip_partition')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('partition', 'bigip_node_status_availability_state{' + this.config.filteringSelector + ', node=~"$bigip_node"}')
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP partition')
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '_node_overview',
          tags,
          links { f5BigipNodeOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      'bigip-pool-overview.json':
        g.dashboard.new(prefix + ' pool overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.poolOverviewRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('bigip_pool')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('pool', 'bigip_pool_status_availability_state{' + this.config.filteringSelector + '}')
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP pool')
            + g.dashboard.variable.query.refresh.onTime(),


            g.dashboard.variable.query.new('bigip_partition')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('partition', 'bigip_pool_status_availability_state{' + this.config.filteringSelector + ', pool=~"$bigip_pool"}')
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP partition')
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '_pool_overview',
          tags,
          links { f5BigipPoolOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),

      'bigip-virtual-server-overview.json':
        g.dashboard.new(prefix + ' virtual server overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.virtualServerOverviewRow,
              ]
            )
          )
        ) + root.applyCommon(
          vars.multiInstance + [
            g.dashboard.variable.query.new('bigip_vs')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('vs', 'bigip_vs_status_availability_state{' + this.config.filteringSelector + '}')
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP virtual server')
            + g.dashboard.variable.query.refresh.onTime(),


            g.dashboard.variable.query.new('bigip_partition')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('partition', 'bigip_vs_status_availability_state{' + this.config.filteringSelector + ', vs=~"$bigip_vs"}')
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP partition')
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '_virtual_server_overview',
          tags,
          links { f5BigipVirtualServerOverview:: {} },
          annotations,
          timezone,
          refresh,
          period,
        ),
    } + if this.config.enableLokiLogs then {
      'bigip-logs.json':
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
                root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { f5BigipLogs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
            },
          panels+:
            {
              logs+:
                {
                  logsPanel+:
                    g.panel.logs.options.withShowTime(true),
                },
            },
        }.dashboards.logs,
    } else {},

  applyCommon(vars, uid, tags, links, annotations, timezone, refresh, period):
    g.dashboard.withTags(tags)
    + g.dashboard.withUid(uid)
    + g.dashboard.withLinks(links)
    + g.dashboard.withTimezone(timezone)
    + g.dashboard.withRefresh(refresh)
    + g.dashboard.time.withFrom(period)
    + g.dashboard.withVariables(vars)
    + g.dashboard.withAnnotations(annotations),
}
