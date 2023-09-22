local g = import 'github.com/grafana/grafonnet/gen/grafonnet-latest/main.libsonnet';
local logsDashboard = import 'github.com/grafana/jsonnet-libs/logs-lib/logs/main.libsonnet';

{
  grafanaDashboards+::
    if $._config.enableLokiLogs then
      {
        local bigIPLogsPanel =
          logsDashboard.new(
            'BIG-IP logs',
            datasourceName='loki_datasource',
            datasourceRegex='(?!grafanacloud.+usage-insights|grafanacloud.+alert-state-history).+',
            filterSelector=$._config.filterSelector,
            labels=['job', 'host', 'syslog_facility', 'level'],
            formatParser=null,
            showLogsVolume=true
          )
          {
            panels+:
              {
                logs+:
                  // BIG-IP logs already have timestamp
                  g.panel.logs.options.withShowTime(false),
              },
            dashboards+:
              {
                logs+: g.dashboard.withLinksMixin($.grafanaDashboards['bigip-cluster-overview.json'].links)
                       + g.dashboard.withUid('bigip-logs-overview')
                       + g.dashboard.withTags($._config.dashboardTags)
                       + g.dashboard.withRefresh($._config.dashboardRefresh),
              },
          },
        'bigip-logs-overview.json': bigIPLogsPanel.dashboards.logs,
      } else {},
}
