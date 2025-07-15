local mssqllib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local mssql =
  mssqllib.new()
  + mssqllib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/mssql"',
      uid: 'mssql',
      enableLokiLogs: true,
    }
  );

local optional_labels = {
  cluster+: {
    allValue: '.*',
  },
  db+: {
    label: 'Database',
    allValue: '.*',
  },
};

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    local tags = config.dashboardTags,
    [fname]:
      local dashboard = util.decorate_dashboard(mssql.grafana.dashboards[fname], tags=tags);
      dashboard + util.patch_variables(dashboard, optional_labels)

    for fname in std.objectFields(mssql.grafana.dashboards)
  },

  prometheusAlerts+:: mssql.prometheus.alerts,
  prometheusRules+:: mssql.prometheus.recordingRules,
}
