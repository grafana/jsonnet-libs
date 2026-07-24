local g = import './g.libsonnet';
local logslib = import 'logs-lib/logs/main.libsonnet';

{
  local root = self,
  new(this)::
    local prefix = this.config.dashboardNamePrefix;
    local links = this.grafana.links;
    local tags = this.config.dashboardTags;
    // use config.uid verbatim (slugify would strip the hyphen from 'apache-solr'
    // and change the stable dashboard UIDs)
    local uid = this.config.uid;
    local vars = this.grafana.variables;
    local annotations = this.grafana.annotations;
    local refresh = this.config.dashboardRefresh;
    local period = this.config.dashboardPeriod;
    local timezone = this.config.dashboardTimezone;
    local panels = this.grafana.panels;

    // Custom variables not derivable from group/instance labels.
    local collectionVar =
      g.dashboard.variable.query.new('solr_collection')
      + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
      + g.dashboard.variable.query.queryTypes.withLabelValues('collection', 'solr_metrics_core_errors_total{%(queriesSelectorGroupOnly)s}' % vars)
      + g.dashboard.variable.query.generalOptions.withLabel('Collection')
      + g.dashboard.variable.query.selectionOptions.withMulti(true)
      + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, this.config.customAllValue)
      + g.dashboard.variable.query.refresh.onTime();
    local coreVar =
      g.dashboard.variable.query.new('solr_core')
      + g.dashboard.variable.query.withDatasourceFromVariable(vars.datasources.prometheus)
      + g.dashboard.variable.query.queryTypes.withLabelValues('core', 'solr_metrics_core_errors_total{%(queriesSelectorGroupOnly)s}' % vars)
      + g.dashboard.variable.query.generalOptions.withLabel('Core')
      + g.dashboard.variable.query.selectionOptions.withMulti(true)
      + g.dashboard.variable.query.selectionOptions.withIncludeAll(true, this.config.customAllValue)
      + g.dashboard.variable.query.refresh.onTime();
    local topKVar =
      g.dashboard.variable.custom.new('k', values=['5', '10', '20', '50'])
      + g.dashboard.variable.custom.generalOptions.withCurrent('5')
      + g.dashboard.variable.custom.generalOptions.withLabel('Top node count')
      + g.dashboard.variable.custom.selectionOptions.withMulti(false)
      + g.dashboard.variable.custom.selectionOptions.withIncludeAll(false);

    // commonlib derives variable labels from the label name (first-letter
    // upper only), giving 'Solr_cluster'/'Base_url'; restore friendlier labels.
    local niceLabels = { solr_cluster: 'Solr cluster', base_url: 'Instance' };
    local relabel(variables) = std.map(
      function(v)
        if std.objectHas(niceLabels, v.name)
        then v + g.dashboard.variable.query.generalOptions.withLabel(niceLabels[v.name])
        else v,
      variables
    );

    // Inline row separator (no rows.libsonnet abstraction).
    local row(title) = g.panel.row.new(title);
    // withPanels + sequential panel ids, preserving explicit gridPos.
    local withPanels(arr) =
      g.dashboard.withPanels(std.mapWithIndex(function(i, p) p { id: i + 2 }, arr));

    {
      'apache-solr-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + withPanels([
          panels.liveNodes { gridPos: { h: 6, w: 6, x: 0, y: 0 } },
          panels.zookeeperStatus { gridPos: { h: 6, w: 6, x: 6, y: 0 } },
          panels.zookeeperEnsembleSize { gridPos: { h: 6, w: 6, x: 12, y: 0 } },
          panels.alerts { gridPos: { h: 6, w: 6, x: 18, y: 0 } },
          panels.shardState { gridPos: { h: 6, w: 4, x: 0, y: 6 } },
          panels.shardStatus { gridPos: { h: 6, w: 8, x: 4, y: 6 } },
          panels.replicaState { gridPos: { h: 6, w: 4, x: 12, y: 6 } },
          panels.replicaStatus { gridPos: { h: 6, w: 8, x: 16, y: 6 } },
          row('Top metrics') { gridPos: { h: 1, w: 24, x: 0, y: 12 } },
          panels.topCPULoadByNode { gridPos: { h: 6, w: 12, x: 0, y: 13 } },
          panels.topHeapMemoryUsageByNode { gridPos: { h: 6, w: 12, x: 12, y: 13 } },
          panels.topMeanQueriesByNode { gridPos: { h: 6, w: 12, x: 0, y: 19 } },
          panels.topUpdateHandlersByNode { gridPos: { h: 6, w: 12, x: 12, y: 19 } },
          panels.topIndexSizeByNode { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
          panels.topCacheHitRatioByNode { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
          row('Errors') { gridPos: { h: 1, w: 24, x: 0, y: 31 } },
          panels.topCoreErrorsByNode { gridPos: { h: 6, w: 12, x: 0, y: 32 } },
          panels.topNodeErrors { gridPos: { h: 6, w: 12, x: 12, y: 32 } },
        ])
        + root.applyCommon(
          relabel(std.filter(function(v) v.name != 'base_url', vars.multiInstance))
          + [topKVar, collectionVar, coreVar],
          uid + '-cluster-overview',
          tags,
          links,
          annotations,
          timezone,
          refresh,
          period,
        ),

      'apache-solr-query-performance.json':
        g.dashboard.new(prefix + ' query performance')
        + withPanels([
          panels.updateHandlers { gridPos: { h: 6, w: 24, x: 0, y: 0 } },
          panels.coreSearchAndRetrievalQueryLoad { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          panels.specializedQueryLoad { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          panels.coreSearchAndRetrieval95pQueryLatency { gridPos: { h: 6, w: 12, x: 0, y: 12 } },
          panels.specialized95pQueryLatency { gridPos: { h: 6, w: 12, x: 12, y: 12 } },
          panels.coreSearchAndRetrieval99pQueryLatency { gridPos: { h: 6, w: 12, x: 0, y: 18 } },
          panels.specialized99pQueryLatency { gridPos: { h: 6, w: 12, x: 12, y: 18 } },
          row('Local queries') { gridPos: { h: 1, w: 24, x: 0, y: 24 } },
          panels.coreSearchAndRetrievalLocalQueryLoad { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
          panels.specializedLocalQueryLoad { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
          panels.coreSearchAndRetrievalLocal95pQueryLatency { gridPos: { h: 6, w: 12, x: 0, y: 31 } },
          panels.specializedLocal95pQueryLatency { gridPos: { h: 6, w: 12, x: 12, y: 31 } },
          panels.coreSearchAndRetrievalLocal99pQueryLatency { gridPos: { h: 6, w: 12, x: 0, y: 37 } },
          panels.specializedLocal99pQueryLatency { gridPos: { h: 6, w: 12, x: 12, y: 37 } },
          row('Cache metrics') { gridPos: { h: 1, w: 24, x: 0, y: 43 } },
          panels.cacheEvictions { gridPos: { h: 6, w: 12, x: 0, y: 49 } },
          panels.cacheHitRatio { gridPos: { h: 6, w: 12, x: 12, y: 49 } },
          row('Timeouts') { gridPos: { h: 1, w: 24, x: 0, y: 55 } },
          panels.coreTimeouts { gridPos: { h: 6, w: 12, x: 0, y: 61 } },
          panels.nodeTimeouts { gridPos: { h: 6, w: 12, x: 12, y: 61 } },
          row('Errors') { gridPos: { h: 1, w: 24, x: 0, y: 66 } },
          panels.queryErrorRate { gridPos: { h: 6, w: 12, x: 0, y: 72 } },
          panels.queryClientErrors { gridPos: { h: 6, w: 12, x: 12, y: 72 } },
        ])
        + root.applyCommon(
          relabel(vars.multiInstance) + [collectionVar, coreVar],
          uid + '-query-performance',
          tags,
          links,
          annotations,
          timezone,
          refresh,
          period,
        ),

      'apache-solr-resource-monitoring.json':
        g.dashboard.new(prefix + ' resource monitoring')
        + withPanels([
          panels.connections { gridPos: { h: 6, w: 12, x: 0, y: 0 } },
          panels.threads { gridPos: { h: 6, w: 12, x: 12, y: 0 } },
          panels.nodeCoreFSUsage { gridPos: { h: 6, w: 12, x: 0, y: 6 } },
          panels.numberOfFileDescriptors { gridPos: { h: 6, w: 12, x: 12, y: 6 } },
          row('JVM metrics') { gridPos: { h: 1, w: 24, x: 0, y: 12 } },
          panels.garbageCollections { gridPos: { h: 6, w: 12, x: 0, y: 13 } },
          panels.garbageCollectionTime { gridPos: { h: 6, w: 12, x: 12, y: 13 } },
          panels.cpuAverageLoad { gridPos: { h: 6, w: 12, x: 0, y: 19 } },
          panels.osMemory { gridPos: { h: 6, w: 12, x: 12, y: 19 } },
          panels.memoryUsed { gridPos: { h: 6, w: 12, x: 0, y: 25 } },
          panels.memoryCommitted { gridPos: { h: 6, w: 12, x: 12, y: 25 } },
          row('Jetty metrics') { gridPos: { h: 1, w: 24, x: 0, y: 31 } },
          panels.requests { gridPos: { h: 6, w: 12, x: 0, y: 37 } },
          panels.responses { gridPos: { h: 6, w: 12, x: 12, y: 37 } },
          panels.dispatches { gridPos: { h: 6, w: 24, x: 0, y: 43 } },
        ])
        + root.applyCommon(
          relabel(vars.multiInstance),
          uid + '-resource-monitoring',
          tags,
          links,
          annotations,
          timezone,
          refresh,
          period,
        ),
    }
    +
    (
      if this.config.enableLokiLogs then
        {
          'apache-solr-logs-overview.json':
            logslib.new(
              prefix + ' logs',
              datasourceName=vars.datasources.loki.name,
              datasourceRegex=vars.datasources.loki.regex,
              filterSelector=this.config.filterSelector,
              labels=this.config.logLabels + this.config.extraLogLabels,
              formatParser=null,
              showLogsVolume=this.config.showLogsVolume,
              logsVolumeGroupBy=this.config.logsVolumeGroupBy,
            )
            {
              dashboards+: {
                logs+:
                  root.applyCommon(
                    super.logs.templating.list,
                    uid + '-logs-overview',
                    tags,
                    links,
                    annotations,
                    timezone,
                    refresh,
                    period,
                  ),
              },
              panels+: {
                logs+:
                  g.panel.logs.options.withShowTime(false),
              },
            }.dashboards.logs,
        } else {}
    ),

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
