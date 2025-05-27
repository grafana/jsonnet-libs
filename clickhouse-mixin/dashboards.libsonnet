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
              panels.interserverConnectionsPanel { gridPos+: { h: 8, w: 12, x: 0, y: 0 } },
              panels.replicaQueueSizePanel { gridPos+: { h: 8, w: 12, x: 12, y: 0 } },
              panels.replicaOperationsPanel { gridPos+: { h: 8, w: 12, x: 0, y: 8 } },
              panels.replicaReadOnlyPanel { gridPos+: { h: 8, w: 12, x: 12, y: 8 } },
              panels.zooKeeperWatchesPanel { gridPos+: { h: 8, w: 12, x: 0, y: 16 } },
              panels.zooKeeperSessionsPanel { gridPos+: { h: 8, w: 12, x: 12, y: 16 } },
              panels.zooKeeperRequestsPanel { gridPos+: { h: 8, w: 24, x: 0, y: 24 } },
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
              panels.successfulQueriesPanel { gridPos+: { h: 8, w: 24, x: 0, y: 0 } },
              panels.failedQueriesPanel { gridPos+: { h: 8, w: 12, x: 0, y: 8 } },
              panels.rejectedInsertsPanel { gridPos+: { h: 8, w: 12, x: 12, y: 8 } },
              panels.memoryUsagePanel { gridPos+: { h: 8, w: 12, x: 0, y: 16 } },
              panels.memoryUsageGaugePanel { gridPos+: { h: 8, w: 12, x: 12, y: 16 } },
              panels.activeConnectionsPanel { gridPos+: { h: 8, w: 24, x: 0, y: 24 } },
              panels.networkReceivedPanel { gridPos+: { h: 8, w: 12, x: 0, y: 32 } },
              panels.networkTransmittedPanel { gridPos+: { h: 8, w: 12, x: 12, y: 32 } },
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
              panels.diskReadLatencyPanel { gridPos+: { h: 8, w: 12, x: 0, y: 0 } },
              panels.diskWriteLatencyPanel { gridPos+: { h: 8, w: 12, x: 12, y: 0 } },
              panels.networkTransmitLatencyInboundPanel { gridPos+: { h: 8, w: 12, x: 0, y: 8 } },
              panels.networkTransmitLatencyOutboundPanel { gridPos+: { h: 8, w: 12, x: 12, y: 8 } },
              panels.zooKeeperWaitTimePanel { gridPos+: { h: 8, w: 24, x: 0, y: 16 } },
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
