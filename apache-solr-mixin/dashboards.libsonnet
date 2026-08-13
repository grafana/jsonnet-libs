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
    local rows = this.grafana.rows;

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

    {
      'apache-solr-cluster-overview.json':
        g.dashboard.new(prefix + ' cluster overview')
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              rows.clusterOverviewStatus,
              rows.clusterOverviewTopMetrics,
              rows.clusterOverviewErrors,
            ])
          )
        )
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
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              rows.queryPerformanceQueryLoad,
              rows.queryPerformanceLocalQueries,
              rows.queryPerformanceCacheMetrics,
              rows.queryPerformanceTimeouts,
              rows.queryPerformanceErrors,
            ])
          )
        )
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
        + g.dashboard.withPanels(
          g.util.panel.resolveCollapsedFlagOnRows(
            g.util.grid.wrapPanels([
              rows.resourceMonitoringOverview,
              rows.resourceMonitoringJVM,
              rows.resourceMonitoringJetty,
            ])
          )
        )
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
