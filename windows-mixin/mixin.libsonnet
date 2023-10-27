local g = import './g.libsonnet';
local var = g.dashboard.variable;
local winlib = import 'windows-observ-lib/main.libsonnet';
local config = (import 'config.libsonnet')._config;
{
  local windows =
    winlib.new(
      dashboardNamePrefix=config.dashboardNamePrefix,
      uid=config.uid,
      filteringSelector=config.filteringSelector,
    )
    +
    {
      config+: config,
    },
  prometheusAlerts+:: windows.prometheus.alerts,
  grafanaDashboards+::
    (windows {
       grafana+: {
         variables+: {
           datasources+: {
             loki+: var.datasource.withRegex('Loki|.+logs'),
             prometheus+: var.datasource.withRegex('Prometheus|Cortex|Mimir|grafanacloud-.+-prom'),
           },
         },
       },
     })
    .grafana.dashboards,
}
