local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{
  grafanaDashboards+::
    if $._config.enableLokiLogs then {
      local influxdbLogs =
        logsDashboard.new(
          'InfluxDB logs overview',
          datasourceName='loki_datasource',
          datasourceRegex='',
          filterSelector=$._config.filterSelector,
          labels=['job', 'influxdb_cluster', 'instance', 'level', 'service', 'engine'],
          formatParser=null,
          showLogsVolume=true
        )
        {
          panels+:
            {
              logs+:
                // InfluxDB logs already have timestamp
                g.panel.logs.options.withShowTime(false),
            },
          dashboards+:
            {
              logs+: g.dashboard.withLinksMixin($.grafanaDashboards['influxdb-cluster-overview.json'].links)
                     + g.dashboard.withTags($._config.dashboardTags)
                     + g.dashboard.withRefresh($._config.dashboardRefresh),
            },
        },
      'influxdb-logs.json': influxdbLogs.dashboards.logs,
    } else {},
}
