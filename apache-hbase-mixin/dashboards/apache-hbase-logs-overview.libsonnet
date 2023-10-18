local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{
  grafanaDashboards+::
    if $._config.enableLokiLogs then {
      local apacheHBaseLogs =
        logsDashboard.new(
          'Apache HBase logs overview',
          datasourceName='loki_datasource',
          datasourceRegex='(?!grafanacloud.+usage-insights|grafanacloud.+alert-state-history).+',
          filterSelector=$._config.filterSelector,
          labels=['job', 'hbase_cluster', 'instance', 'context', 'level'],
          formatParser=null,
          showLogsVolume=true
        )
        {
          panels+:
            {
              logs+:
                // Apache HBase logs already have timestamp
                g.panel.logs.options.withShowTime(false),
            },
          dashboards+:
            {
              logs+: g.dashboard.withLinksMixin($.grafanaDashboards['apache-hbase-cluster-overview.json'].links)
                     + g.dashboard.withTags($._config.dashboardTags)
                     + g.dashboard.withRefresh($._config.dashboardRefresh),
            },
        },
      'apache-hbase-logs.json': apacheHBaseLogs.dashboards.logs,
    } else {},
}
