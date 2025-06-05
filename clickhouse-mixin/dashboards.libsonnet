local g = import "./g.libsonnet";
local logslib = import "logs-lib/logs/main.libsonnet";
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
    local panels = this.grafana.panels;

    {
      "clickhouse-replica":
        g.dashboard.new(prefix + " replica")
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.interserverConnectionsPanel,
              panels.replicaQueueSizePanel,
              panels.replicaOperationsPanel,
              panels.replicaReadOnlyPanel,
              panels.zooKeeperWatchesPanel,
              panels.zooKeeperSessionsPanel,
              panels.zooKeeperRequestsPanel,
            ]
          )
        )
        + root.applyCommon(
          vars.singleInstance,
          uid + "_clickhouse_replica",
          tags,
          links { clickhouseReplica+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      "clickhouse-overview":
        g.dashboard.new(prefix + " overview")
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.successfulQueriesPanel,
              panels.failedQueriesPanel,
              panels.rejectedInsertsPanel,
              panels.memoryUsagePanel,
              panels.memoryUsageGaugePanel,
              panels.activeConnectionsPanel,
              panels.networkReceivedPanel,
              panels.networkTransmittedPanel,
            ]
          )
        )
        + root.applyCommon(
          vars.singleInstance,
          uid + "_clickhouse_overview",
          tags,
          links { clickhouseOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      "clickhouse-latency":
        g.dashboard.new(prefix + " latency")
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.diskReadLatencyPanel,
              panels.diskWriteLatencyPanel,
              panels.networkTransmitLatencyInboundPanel,
              panels.networkTransmitLatencyOutboundPanel,
                panels.zooKeeperWaitTimePanel,
            ]
          )
        )
        + root.applyCommon(
          vars.singleInstance,
          uid + "_clickhouse_latency",
          tags,
          links { clickhouseLatency+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

    }
    +
    if this.config.enableLokiLogs then
      {
        "clickhouse-logs":
          logslib.new(
            prefix + " logs",
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
                  // reference to self, already generated variables, to keep them, but apply other common data in applyCommon
                  root.applyCommon(super.logs.templating.list, uid=uid + "-logs", tags=tags, links=links { logs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
              },
            panels+:
              {
                logs+:
                  g.panel.logs.options.withEnableLogDetails(true)
                  + g.panel.logs.options.withShowTime(false)
                  + g.panel.logs.options.withWrapLogMessage(false),
              },
            variables+: {
              // add prometheus datasource for annotations processing
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
