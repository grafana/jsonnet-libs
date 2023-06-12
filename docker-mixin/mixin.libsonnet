local package = import 'package.libsonnet';
{
  grafanaDashboards+:: {
    ['%s.json' % dashboard.metadata.name]: dashboard.spec
    for dashboard in package.dashboards
  }
}