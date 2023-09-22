local g = import './g.libsonnet';
local var = g.dashboard.variable;
local winlib = import 'github.com/grafana/jsonnet-libs/windows-observ-lib/main.libsonnet';

{
  local windows =
    winlib.new(
      dashboardNamePrefix=$._config.dashboardNamePrefix,
      uid=$._config.uid,
      filteringSelector=$._config.filteringSelector,
    )
    +
    {
      config+: (import 'config.libsonnet')._config,
    },
  prometheusAlerts+:: windows.alerts,
  grafanaDashboards+::
    (windows {
       variables+: {
         datasources+: {
           loki+: var.datasource.withRegex('Loki|.+logs'),
           prometheus+: var.datasource.withRegex('Victoria|Prometheus|Cortex|Mimir|grafanacloud-.+-prom'),
         },
       },
     })
    .dashboards,
}
