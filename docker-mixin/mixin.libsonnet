local package = import 'polly.libsonnet';
{
  grafanaDashboards+:: {
    ['%s.json' % package.dashboards[name].metadata.name]: package.dashboards[name].spec
    for name in std.objectFields(package.dashboards)
  }
}