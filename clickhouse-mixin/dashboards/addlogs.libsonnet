local g = import 'grafonnet-latest/main.libsonnet';
local logsDashboard = import 'logs-lib/logs/main.libsonnet';
{
  grafanaDashboards+::
    if $._config.enableLokiLogs then
      {
        local clickhouseLogs =
          logsDashboard.new(
            'ClickHouse logs',
            datasourceName='loki_datasource',
            datasourceRegex='',
            filterSelector=$._config.filterSelector,
            labels=['job', 'instance', 'level'],
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
                  + g.dashboard.withUid('clickhouse-logs-overview')
                  + g.dashboard.withTags($._config.dashboardTags)
                  + g.dashboard.withRefresh($._config.dashboardRefresh),
              },
          },
        'clickhouse-logs.json': clickhouseLogs.dashboards.logs,
      } else {},
}
