local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';

{
  grafanaDashboards+::
    if $._config.enableLokiLogs then
      {
        local f5LogsPanel =
          logsDashboard.new(
            'F5 logs',
            datasourceName='loki_datasource',
            datasourceRegex='',
            filterSelector=$._config.filterSelector,
            labels=['job', 'host', 'syslog_facility', 'level'],
            formatParser=null,
            showLogsVolume=true
          ),
        local highAvailabilityLogsPanel =
          logsDashboard.new(
            'F5 high availability logs',
            datasourceName='loki_datasource',
            datasourceRegex='',
            filterSelector=$._config.filterSelector,
            labels=['job'],
            formatParser=null,
            showLogsVolume=true
          )
          {
            panels+:
              {
                logs+:
                  // F5 logs already have timestamp
                  g.panel.logs.options.withShowTime(false),
              },
            dashboards+:
              {
                logs+: g.dashboard.withLinksMixin($.grafanaDashboards['f5-cluster-overview.json'].links)
                       + g.dashboard.withUid($._config.grafanaDashboardIDs['f5-logs-overview.json'])
                       + g.dashboard.withTags($._config.dashboardTags)
                       + g.dashboard.withRefresh($._config.dashboardRefresh),
              },
          },
        'f5-logs-overview.json': f5LogsPanel.dashboards.logs,
      } else {},
}
