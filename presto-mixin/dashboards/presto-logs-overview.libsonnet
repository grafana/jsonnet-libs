local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{
  grafanaDashboards+::
    if $._config.enableLokiLogs then {
      local prestoLogs =
        logsDashboard.new(
          'Presto logs overview',
          datasourceName='loki_datasource',
          datasourceRegex='',
          filterSelector=$._config.filterSelector,
          labels=['job', 'presto_cluster', 'instance', 'level'],
          formatParser=null,
          showLogsVolume=true
        )
        {
          panels+:
            {
              logs+:
                // presto logs already have timestamp
                g.panel.logs.options.withShowTime(false),
            },
          dashboards+:
            {
              logs+: g.dashboard.withLinksMixin($.grafanaDashboards['presto-overview.json'].links)
                     + g.dashboard.withTags($._config.dashboardTags)
                     + g.dashboard.withRefresh($._config.dashboardRefresh),
            },
        },
      'presto-logs.json': prestoLogs.dashboards.logs,
    } else {},
}
