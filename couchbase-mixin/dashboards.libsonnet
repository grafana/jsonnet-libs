local g = import './g.libsonnet';
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
    local panels = this.grafana.panels;

    {
      'couchbase-bucket-overview.json':
        g.dashboard.new(prefix + ' bucket overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.bucket_topBucketsByMemoryUsedPanel { gridPos+: { w: 12 } },
              panels.bucket_topBucketsByDiskUsedPanel { gridPos+: { w: 12 } },
              panels.bucket_topBucketsByCurrentItemsPanel { gridPos+: { w: 8 } },
              panels.bucket_topBucketsByOperationsPanel { gridPos+: { w: 8 } },
              panels.bucket_topBucketsByOperationsFailedPanel { gridPos+: { w: 8 } },
              panels.bucket_topBucketsByHighPriorityRequestsPanel { gridPos+: { w: 12 } },
              panels.bucket_bottomBucketsByCacheHitRatioPanel { gridPos+: { w: 12 } },
              panels.bucket_topBucketsByVBucketsCountPanel { gridPos+: { w: 12 } },
              panels.bucket_topBucketsByVBucketQueueMemoryPanel { gridPos+: { w: 12 } },
            ],
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_couchbase_bucket_overview',
          tags,
          links { couchbaseBucketOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'couchbase-node-overview.json':
        g.dashboard.new(prefix + ' node overview')
        + g.dashboard.withPanels(
          g.util.grid.wrapPanels(
            [
              panels.node_memoryUtilizationPanel { gridPos+: { w: 12 } },
              panels.node_cpuUtilizationPanel { gridPos+: { w: 12 } },
              panels.node_totalMemoryUsedByServicePanel { gridPos+: { w: 8 } },
              panels.node_backupSizePanel { gridPos+: { w: 8 } },
              panels.node_currentConnectionsPanel { gridPos+: { w: 8 } },
              panels.node_httpResponseCodesPanel { gridPos+: { w: 12 } },
              panels.node_httpRequestMethodsPanel { gridPos+: { w: 12 } },
              panels.node_queryServiceRequestsPanel { gridPos+: { w: 12 } },
              panels.node_queryServiceRequestProcessingTimePanel { gridPos+: { w: 12 } },
              panels.node_indexServiceRequestsPanel { gridPos+: { w: 8 } },
              panels.node_indexCacheHitRatioPanel { gridPos+: { w: 8 } },
              panels.node_averageScanLatencyPanel { gridPos+: { w: 8 } },
            ]
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_couchbase_node_overview',
          tags,
          links { couchbaseNodeOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

      'couchbase-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels(
              [
                panels.cluster_topNodesByMemoryUsagePanel { gridPos+: { w: 12 } },
                panels.cluster_topNodesByHTTPRequestsPanel { gridPos+: { w: 12 } },
                panels.cluster_topNodesByQueryServiceRequestsPanel { gridPos+: { w: 12 } },
                panels.cluster_topNodesByIndexAverageScanLatencyPanel { gridPos+: { w: 12 } },
                panels.cluster_xdcrReplicationRatePanel { gridPos+: { w: 8 } },
                panels.cluster_xdcrDocsReceivedPanel { gridPos+: { w: 8 } },
                panels.cluster_localBackupSizePanel { gridPos+: { w: 8 } },
              ] + this.grafana.rows.clusterOverviewBucket,
            )
          )
        )
        + root.applyCommon(
          vars.multiInstance,
          uid + '_couchbase_cluster_overview',
          tags,
          links { couchbaseClusterOverview+:: {} },
          annotations,
          timezone,
          refresh,
          period
        ),

    }
    +
    if this.config.enableLokiLogs then
      {
        'logs.json':
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
                  // reference to self, already generated variables, to keep them, but apply other common data in applyCommon
                  root.applyCommon(super.logs.templating.list, uid=uid + '-logs', tags=tags, links=links { logs+:: {} }, annotations=annotations, timezone=timezone, refresh=refresh, period=period),
              },
            panels+:
              {
                // modify log panel
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
