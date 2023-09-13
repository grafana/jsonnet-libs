local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{
  grafanaDashboards+::
    if $._config.enableLokiLogs then {
      local aerospikeLogs =
        logsDashboard.new(
          'Aerospike logs',
          datasourceName='loki_datasource',
          datasourceRegex='',
          filterSelector=$._config.filterSelector,
          labels=['job', 'aerospike_cluster', 'instance', 'level'],
          formatParser=null,
          showLogsVolume=true
        )
        {
          panels+:
            {
              logs+:
                // Aerospike logs already have timestamp
                g.panel.logs.options.withShowTime(false),
            },
          dashboards+:
            {
              logs+: g.dashboard.withLinksMixin($.grafanaDashboards['aerospike-overview.json'].links)
                     + g.dashboard.withTags($._config.dashboardTags)
                     + g.dashboard.withRefresh($._config.dashboardRefresh),
            },
        },
      'aerospike-logs.json': aerospikeLogs.dashboards.logs,
    } else {},
}
