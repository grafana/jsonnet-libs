local config = import './config.libsonnet';
local pgbouncerlib = import './main.libsonnet';
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local pgbouncer =
  pgbouncerlib.new()
  + pgbouncerlib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

// Scoped per dashboard: the overview is a per-instance drill-down, while the logs
// dashboard keeps its multi-select instance.
local variable_patches = {
  'pgbouncer-overview.json': {
    instance+: {
      multi: false,
      includeAll: false,
    },
  },
};

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = pgbouncer.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, std.get(variable_patches, fname, default={}))
    for fname in std.objectFields(pgbouncer.grafana.dashboards)
  },
  prometheusAlerts+:: pgbouncer.prometheus.alerts,
  prometheusRules+:: pgbouncer.prometheus.recordingRules,
}
