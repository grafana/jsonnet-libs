local windowsobservlib = import '../windows-observ-lib/main.libsonnet';
local g = import './g.libsonnet';

local activedirectorymixin =
  windowsobservlib.new(
    filteringSelector='job=~"integrations/windows_exporter"',
    uid='active-directory',
    groupLabels=['job'],
    instanceLabels=['instance'],
  )

  {
    config+: {
      enableLokiLogs: true,
      enableADDashboard: true,
    },
  }

  {
    grafana+: {
      local link = g.dashboard.link,
      links: {
        backToLogs:
          link.link.new('Windows logs', '/d/activedirectory-logs')
          + link.link.options.withKeepTime(true),
        backToActiveDirectoryOverview:
          link.link.new('Active Directory overview', '/d/activedirectory')
          + link.link.options.withKeepTime(true),
      },
    },
  };

local activedirectorydashboards = ['activedirectory', 'logs'];
local selectedDashboards = {
  [key]: activedirectorymixin.grafana.dashboards[key]
  for key in activedirectorydashboards
  if key in activedirectorymixin.grafana.dashboards
};

{
  grafanaDashboards+:: selectedDashboards,
  prometheusAlerts+:: activedirectorymixin.prometheus.alerts,
  prometheusRules+:: activedirectorymixin.prometheus.recordingRules,
}
