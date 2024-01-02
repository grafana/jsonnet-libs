local windowsobservlib = import '../windows-observ-lib/main.libsonnet';
local alerts = import './alerts/alerts.libsonnet';
local g = import './g.libsonnet';
local var = g.dashboard.variable;
local activedirectorymixin =
  windowsobservlib.new(
    filteringSelector='job=~"integrations/windows_exporter"',
    uid='active-directory',
    groupLabels=['job'],
    instanceLabels=['instance'],
  )

  {
    config+: {
      enableADDashboard: true,
    },
  }

  {
    grafana+: {
      local link = g.dashboard.link,
      links: {
        backToLogs:
          link.link.new('Windows logs', '/d/' + activedirectorymixin.grafana.dashboards.logs.uid)
          + link.dashboards.options.withIncludeVars(true)
          + link.link.options.withKeepTime(true),
        backToActiveDirectoryOverview:
          link.link.new('Active Directory overview', '/d/' + activedirectorymixin.grafana.dashboards.activedirectory.uid)
          + link.dashboards.options.withIncludeVars(true)
          + link.link.options.withKeepTime(true),
      },
      variables+: {
        datasources+: {
          loki+: var.datasource.withRegex('Loki|.+logs'),
          prometheus+: var.datasource.withRegex('Prometheus|Cortex|Mimir|grafanacloud-.+-prom'),
        },
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
