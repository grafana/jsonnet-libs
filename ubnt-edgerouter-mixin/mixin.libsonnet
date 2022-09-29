(import 'dashboards/overview.jsonnet') +
{
  grafanaDashboards+:: {
    'influxubntdash.json': import 'dashboards/overview.jsonnet',
  },
}
