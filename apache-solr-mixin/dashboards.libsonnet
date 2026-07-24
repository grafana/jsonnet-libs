local grafana = (import 'grafonnet/grafana.libsonnet');
local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
local panelsLib = import './panels.libsonnet';

local dashboard = grafana.dashboard;
local template = grafana.template;

local promDatasourceName = 'prometheus_datasource';
local promDatasource = {
  uid: '${%s}' % promDatasourceName,
};

// simple row separator (kept inline; no rows.libsonnet abstraction)
local row(title) = {
  datasource: promDatasource,
  targets: [],
  type: 'row',
  title: title,
  collapsed: false,
};

{
  grafanaDashboards+::
    local cfg = $._config;
    // Default signal scoping (job/cluster + solr_cluster/base_url instance labels).
    local signals = {
      [sig]: commonlib.signals.unmarshallJsonMulti(cfg.signals[sig], type=cfg.metricsSource)
      for sig in std.objectFields(cfg.signals)
    };
    // Cluster-overview has no base_url variable, so scope signals to solr_cluster only.
    local signalsCluster = {
      [sig]: commonlib.signals.unmarshallJsonMulti(cfg.signals[sig] { instanceLabels: ['solr_cluster'] }, type=cfg.metricsSource)
      for sig in std.objectFields(cfg.signals)
    };
    local panels = panelsLib.new({ config: cfg, signals: signals, signalsCluster: signalsCluster });

    local commonTemplates = [
      template.datasource(
        promDatasourceName,
        'prometheus',
        null,
        label='Data Source',
        refresh='load'
      ),
      template.new(
        'job',
        promDatasource,
        'label_values(solr_metrics_core_errors_total,job)',
        label='Job',
        refresh=2,
        includeAll=true,
        multi=true,
        allValues='.+',
        sort=1
      ),
      template.new(
        'cluster',
        promDatasource,
        'label_values(solr_metrics_core_errors_total{%(multiclusterSelector)s}, cluster)' % cfg,
        label='Cluster',
        refresh=2,
        includeAll=true,
        multi=true,
        allValues='.*',
        hide=if cfg.enableMultiCluster then '' else 'variable',
        sort=0
      ),
    ];

    {
      'apache-solr-cluster-overview.json':
        dashboard.new(
          'Apache Solr cluster overview',
          time_from='%s' % cfg.dashboardPeriod,
          tags=(cfg.dashboardTags),
          timezone='%s' % cfg.dashboardTimezone,
          refresh='%s' % cfg.dashboardRefresh,
          description='',
          uid='apache-solr-cluster-overview',
        )
        .addLink(grafana.link.dashboards(
          asDropdown=false,
          title='Other Apache Solr dashboards',
          includeVars=true,
          keepTime=true,
          tags=(cfg.dashboardTags),
        ))
        .addTemplates(
          commonTemplates
          + [
            template.new(
              'solr_cluster',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, solr_cluster)' % cfg,
              label='Solr cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.custom(
              'k',
              query='5,10,20,50',
              current='5',
              label='Top node count',
              refresh='never',
              includeAll=false,
              multi=false,
              allValues='',
            ),
            template.new(
              'solr_collection',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, collection)' % cfg,
              label='Collection',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.*',
              sort=1
            ),
            template.new(
              'solr_core',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, core)' % cfg,
              label='Core',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
          ]
        )
        .addPanels(
          [
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
          ]
        ),

      'apache-solr-query-performance.json':
        dashboard.new(
          'Apache Solr query performance',
          time_from='%s' % cfg.dashboardPeriod,
          tags=(cfg.dashboardTags),
          timezone='%s' % cfg.dashboardTimezone,
          refresh='%s' % cfg.dashboardRefresh,
          description='',
          uid='apache-solr-query-performance',
        )
        .addLink(grafana.link.dashboards(
          asDropdown=false,
          title='Other Apache Solr dashboards',
          includeVars=true,
          keepTime=true,
          tags=(cfg.dashboardTags),
        ))
        .addTemplates(
          commonTemplates
          + [
            template.new(
              'base_url',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, base_url)' % cfg,
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'solr_cluster',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, solr_cluster)' % cfg,
              label='Solr cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'solr_collection',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, collection)' % cfg,
              label='Collection',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.*',
              sort=1
            ),
            template.new(
              'solr_core',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, core)' % cfg,
              label='Core',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
          ]
        )
        .addPanels(
          [
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
          ]
        ),

      'apache-solr-resource-monitoring.json':
        dashboard.new(
          'Apache Solr resource monitoring',
          time_from='%s' % cfg.dashboardPeriod,
          tags=(cfg.dashboardTags),
          timezone='%s' % cfg.dashboardTimezone,
          refresh='%s' % cfg.dashboardRefresh,
          description='',
          uid='apache-solr-resource-monitoring',
        )
        .addLink(grafana.link.dashboards(
          asDropdown=false,
          title='Other Apache Solr dashboards',
          includeVars=true,
          keepTime=true,
          tags=(cfg.dashboardTags),
        ))
        .addTemplates(
          commonTemplates
          + [
            template.new(
              'base_url',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, base_url)' % cfg,
              label='Instance',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
            template.new(
              'solr_cluster',
              promDatasource,
              'label_values(solr_metrics_core_errors_total{%(solrSelector)s}, solr_cluster)' % cfg,
              label='Solr cluster',
              refresh=2,
              includeAll=true,
              multi=true,
              allValues='.+',
              sort=1
            ),
          ]
        )
        .addPanels(
          [
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
          ]
        ),
    }
    +
    (
      if cfg.enableLokiLogs then
        {
          local apacheSolrLogsPanel =
            logsDashboard.new(
              'Apache Solr logs',
              datasourceName='loki_datasource',
              datasourceRegex='(?!grafanacloud.+usage-insights|grafanacloud.+alert-state-history).+',
              filterSelector=cfg.filterSelector,
              labels=['job', 'solr_cluster', 'instance', 'level', 'filename'],
              formatParser=null,
              showLogsVolume=true
            )
            {
              panels+:
                {
                  logs+:
                    g.panel.logs.options.withShowTime(false),
                },
              dashboards+:
                {
                  logs+: g.dashboard.withLinksMixin($.grafanaDashboards['apache-solr-cluster-overview.json'].links)
                         + g.dashboard.withUid('apache-solr-logs-overview')
                         + g.dashboard.withTags(cfg.dashboardTags)
                         + g.dashboard.withRefresh(cfg.dashboardRefresh),
                },
            },
          'apache-solr-logs-overview.json': apacheSolrLogsPanel.dashboards.logs,
        } else {}
    ),
}
