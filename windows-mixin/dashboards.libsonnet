local g = import './g.libsonnet';
local var = g.dashboard.variable;
local winlib = import './lib/windows-lib/main.libsonnet';
{
  local windows = winlib.new(
    dashboardNamePrefix='My ',
    uid='windows',
    filteringSelector='job!=""',
  ),
  prometheusAlerts+:: windows.alerts,
  grafanaDashboards+::
    (windows {
       variables+: {
         datasources+: {
           loki+: var.datasource.withRegex('Loki|.+logs'),
           prometheus+: var.datasource.withRegex('Victoria|grafanacloud-vzhuravlevlabs-prom'),
         },
       },
     })
    .dashboards,
}
