local mixin = import 'mixin.libsonnet';
{
  grafanaDashboards: {
    [key]: mixin.grafanaDashboards[key]
    for key in std.objectFields(mixin.grafanaDashboards)
  }
}
