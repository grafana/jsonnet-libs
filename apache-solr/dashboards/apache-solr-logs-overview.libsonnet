local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';

{
  grafanaDashboards+::
    if $._config.enableLokiLogs then
      {
        local apacheSolrLogsPanel =
          logsDashboard.new(
            'Apache Solr logs',
            datasourceName='loki_datasource',
            datasourceRegex='(?!grafanacloud.+usage-insights|grafanacloud.+alert-state-history).+',
            filterSelector=$._config.filterSelector,
            labels=['job', 'instance', 'solr_cluster', 'filename'],
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
                       + g.dashboard.withTags($._config.dashboardTags)
                       + g.dashboard.withRefresh($._config.dashboardRefresh),
              },
          },
        'apache-solr-logs-overview.json': apacheSolrLogsPanel.dashboards.logs,
      } else {},
}
