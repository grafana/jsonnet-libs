local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';

{
  grafanaDashboards+::
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
              logs+:
                // copy links from another dashboard
                g.dashboard.withLinksMixin($.grafanaDashboards['apache-activemq-cluster-overview.json'].links),
            },
        },
      'apache-activemq-logs.json': activemqLogs.dashboards.logs,
    },

}
