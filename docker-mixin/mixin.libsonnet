local package = import 'polly.libsonnet';
{
  grafanaDashboards+:: {
    ['%s.json' % dashboard.metadata.name]: dashboard.spec
    for dashboard in package.dashboards
  }
}