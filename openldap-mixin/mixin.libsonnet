// openldap-mixin/mixin.libsonnet
local openldapobservlib = import './main.libsonnet';
local alerts = import './alerts.libsonnet';
local g = import './g.libsonnet';
local var = g.dashboard.variable;

local openldapmixin =
  openldapobservlib.new(
    filteringSelector='job=~"integration/openldap"',
    uid='openldap',
    groupLabels=['job'],
    instanceLabels=['instance'],
  ) {
    config+: {
    },
  } {
    grafana+: {
      local link = g.dashboard.link,
      links: {
        otherDashboards:
          link.dashboards.new('All OpenLDAP dashboards', openldapmixin.config.dashboardTags)
          + link.dashboards.options.withIncludeVars(true)
          + link.dashboards.options.withKeepTime(true)
          + link.dashboards.options.withAsDropdown(true),
      },
      variables+: {
        datasources+: {
          loki+: var.datasource.withRegex('Loki|.+logs'),
          prometheus+: var.datasource.withRegex('Prometheus|Cortex|Mimir|grafanacloud-.+-prom'),
        },
      },
    },
  };

local openldapdashboards = ['openldap-overview', 'logs'];
local selectedDashboards = {
  [key]: openldapmixin.grafana.dashboards[key]
  for key in openldapdashboards
  if key in openldapmixin.grafana.dashboards
};

{
  grafanaDashboards+:: openldapmixin.grafana.dashboards,
  prometheusAlerts+:: openldapmixin.prometheus.alerts,
  prometheusRules+:: openldapmixin.prometheus.recordingRules,
}
