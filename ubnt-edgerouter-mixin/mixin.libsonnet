(import 'dashboards/overview.jsonnet') +
{
  grafanaDashboards+:: {
    'influxubntdash.json': import 'dashboards/influxdash.json',
  },
}
