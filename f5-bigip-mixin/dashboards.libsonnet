local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';

{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    local uid = this.config.uid;
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;

    {
      // Cluster Overview Dashboard
      'f5-bigip-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withDescription('Overview of F5 BIG-IP cluster health and top metrics.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.clusterOverviewRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            // k (top count) variable
            g.dashboard.variable.custom.new('k', values=['5', '10', '20', '50'])
            + g.dashboard.variable.custom.generalOptions.withLabel('Top node count')
            + g.dashboard.variable.custom.generalOptions.withCurrent('5'),
            // bigip_partition variable
            g.dashboard.variable.query.new('bigip_partition')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('partition', 'bigip_node_status_availability_state{job=~"$job", instance=~"$instance", partition=~"$bigip_partition"}')
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP partition')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '-cluster-overview',
          tags,
          links { clusterOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      // Node Overview Dashboard
      'f5-bigip-node-overview.json':
        g.dashboard.new(prefix + ' node overview')
        + g.dashboard.withDescription('Detailed view of F5 BIG-IP node metrics and status.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.nodeStatusRow,
                this.grafana.rows.nodeMetricsRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            // bigip_node variable
            g.dashboard.variable.query.new('bigip_node')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('node', 'bigip_node_status_availability_state{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP node')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
            // bigip_partition variable
            g.dashboard.variable.query.new('bigip_partition')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('partition', 'bigip_node_status_availability_state{job=~"$job", instance=~"$instance", node=~"$bigip_node"}')
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP partition')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '-node-overview',
          tags,
          links { nodeOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      // Pool Overview Dashboard
      'f5-bigip-pool-overview.json':
        g.dashboard.new(prefix + ' pool overview')
        + g.dashboard.withDescription('Detailed view of F5 BIG-IP pool metrics and status.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.poolStatusRow,
                this.grafana.rows.poolMetricsRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            // bigip_pool variable
            g.dashboard.variable.query.new('bigip_pool')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('pool', 'bigip_pool_status_availability_state{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP pool')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
            // bigip_partition variable
            g.dashboard.variable.query.new('bigip_partition')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('partition', 'bigip_pool_status_availability_state{job=~"$job", instance=~"$instance", pool=~"$bigip_pool"}')
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP partition')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '-pool-overview',
          tags,
          links { poolOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      // Virtual Server Overview Dashboard
      'f5-bigip-virtual-server-overview.json':
        g.dashboard.new(prefix + ' virtual server overview')
        + g.dashboard.withDescription('Detailed view of F5 BIG-IP virtual server metrics and status.')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                this.grafana.rows.virtualServerStatusRow,
                this.grafana.rows.virtualServerClientsideMetricsRow,
                this.grafana.rows.virtualServerEphemeralMetricsRow,
              ]
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance + [
            // bigip_virtual_server variable
            g.dashboard.variable.query.new('bigip_virtual_server')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('virtual_server', 'bigip_vs_status_availability_state{job=~"$job", instance=~"$instance"}')
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP virtual server')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
            // bigip_partition variable
            g.dashboard.variable.query.new('bigip_partition')
            + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
            + g.dashboard.variable.query.queryTypes.withLabelValues('partition', 'bigip_vs_status_availability_state{job=~"$job", instance=~"$instance", virtual_server=~"$bigip_virtual_server"}')
            + g.dashboard.variable.query.generalOptions.withLabel('BIG-IP partition')
            + g.dashboard.variable.query.selectionOptions.withMulti(true)
            + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, '.+')
            + g.dashboard.variable.query.refresh.onLoad()
            + g.dashboard.variable.query.refresh.onTime(),
          ],
          uid + '-virtual-server-overview',
          tags,
          links { virtualServerOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),
    }
    +
    if this.config.enableLokiLogs then
      {
        'f5-bigip-logs.json':
          logslib.new(
            prefix + ' logs',
            datasourceName=vars.datasources.loki.name,
            datasourceRegex=vars.datasources.loki.regex,
            filterSelector=this.config.filterSelector,
            labels=this.config.logLabels,
            formatParser=null,
            showLogsVolume=this.config.showLogsVolume,
            logsVolumeGroupBy=this.config.logsVolumeGroupBy,
          )
          {
            dashboards+:
              {
                logs+:
                  g.dashboard.withUid(uid + '-logs')
                  + g.dashboard.withTags(tags)
                  + g.dashboard.withRefresh(refresh)
                  + g.dashboard.withLinks(std.objectValues(links { logs+:: {} }))
                  + g.panel.logs.options.withShowTime(false),
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
