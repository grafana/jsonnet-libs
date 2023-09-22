local g = import './g.libsonnet';
local var = g.dashboard.variable;
local winlib = import './windows-observ-lib/main.libsonnet';
{
  local windows = winlib.new(
    dashboardNamePrefix='',
    uid='windows',
    filteringSelector='job="integrations/windows"',
  ) + {
    config+: $._config,
  },
  prometheusAlerts+:: windows.alerts,
  grafanaDashboards+::
    (windows {
       variables+: {
         datasources+: {
           loki+: var.datasource.withRegex('Loki|.+logs'),
           prometheus+: var.datasource.withRegex('Prometheus|Cortex|Mimir|grafanacloud-.+-prom'),
         },
       },
     })
    .dashboards,
}
+
(import 'config.libsonnet')
