local g = import 'grafonnet-latest/main.libsonnet';
local logsDashboard = import 'logs-lib/logs/main.libsonnet';
{
  grafanaDashboards+::
    if $._config.enableLokiLogs then {
      local clickhouseLogs =
        logsDashboard.new(
          'ClickHouse logs',
          datasourceName='loki_datasource',
          datasourceRegex='',
          filterSelector=$._config.filterSelector,
          labels=$._config.logLabels,
          formatParser=null,
          showLogsVolume=true
        )
        {
          panels+:
            {
              logs+:
                // clickhouse logs already have timestamp
                g.panel.logs.options.withShowTime(false),
            },
          dashboards+:
            {
              logs+:
                // copy links from another dashboard
                g.dashboard.withLinksMixin($.grafanaDashboards['clickhouse-overview.json'].links)
                + g.dashboard.withTags($._config.dashboardTags),
            },
        },
      'clickhouse-logs.json': clickhouseLogs.dashboards.logs,
    },
}
