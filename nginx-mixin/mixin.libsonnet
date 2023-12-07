local mods = (import 'mods.libsonnet');

{
  grafanaDashboards: {
    'nginx-overview.json': mods.patch(import 'dashboards/nginx-overview.json'),
  },
}
