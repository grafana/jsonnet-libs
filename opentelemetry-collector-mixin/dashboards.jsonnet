local dashboards = (import 'mixin.libsonnet').grafanaDashboards;
local cfg = import 'config.libsonnet';

{
  [name]: dashboards[name] {
    uid: std.get(cfg._config.grafanaDashboardIDs, name, default=std.md5(name)),
    timezone: cfg._config.grafana.grafanaTimezone,
    refresh: cfg._config.grafana.refresh,
    tags: cfg._config.grafana.dashboardTags,
  }
  for name in std.objectFields(dashboards)
}
