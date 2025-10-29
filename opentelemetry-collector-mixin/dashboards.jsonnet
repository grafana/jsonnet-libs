local dashboards = (import 'mixin.libsonnet').grafanaDashboards;
local cfg = import 'config.libsonnet';

{
  [name]: dashboards[name]
  for name in std.objectFields(dashboards)
}
