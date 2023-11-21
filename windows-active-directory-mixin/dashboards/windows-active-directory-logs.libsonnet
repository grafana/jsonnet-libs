local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';
{
  grafanaDashboards+::
    if $._config.enableLokiLogs then {
      local windowsActiveDirectoryLogs =
        logsDashboard.new(
          'Windows Active Directory logs overview',
          datasourceName='loki_datasource',
          datasourceRegex='',
          filterSelector=$._config.filterSelector,
          labels=['job', 'instance', 'source', 'level'],
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
              logs+: g.dashboard.withLinksMixin($.grafanaDashboards['windows-active-directory-overview.json'].links)
                     + g.dashboard.withTags($._config.dashboardTags)
                     + g.dashboard.withRefresh($._config.dashboardRefresh),
            },
        },
      'windows-active-directory-logs.json': windowsActiveDirectoryLogs.dashboards.logs,
    } else {},
}
