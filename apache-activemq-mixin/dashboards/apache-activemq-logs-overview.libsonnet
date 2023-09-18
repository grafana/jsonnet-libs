local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';

{
  local activemqLogs =
    logsDashboard.new(
      'Apache ActiveMQ logs',
      datasourceName='loki_datasource',
      datasourceRegex='',
      filterSelector=$._config.filterSelector,
      labels=['job', 'activemq_cluster', 'instance', 'level'],
      formatParser=null,
      showLogsVolume=true
    )
    {
      panels+:
        {
          logs+:
            // ActiveMQ logs already have timestamp
            g.panel.logs.options.withShowTime(false),
        },
      dashboards+:
        {
          logs+: g.dashboard.withLinksMixin($.grafanaDashboards['apache-activemq-cluster-overview.json'].links)
                 + g.dashboard.withUid($._config.grafanaDashboardIDs['apache-activemq-logs-overview.json'])
                 + g.dashboard.withTags($._config.dashboardTags)
                 + g.dashboard.withRefresh($._config.dashboardRefresh),
        },
    },
  grafanaDashboards+:: if $._config.enableLokiLogs then {
    'apache-activemq-logs.json': activemqLogs.dashboards.logs,
  } else {},
}
