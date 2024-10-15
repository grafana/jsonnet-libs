local mods = (import 'mods.libsonnet');

{
  grafanaDashboards: {
    'nginx-metrics.json': mods.patch(import 'dashboards/nginx-metrics.json'),
    'nginx-logs.json': mods.patch(import 'dashboards/nginx-logs.json'),
  },
}
