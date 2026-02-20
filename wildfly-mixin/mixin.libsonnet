local mixinlib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';


local mixin = mixinlib.new()
              + mixinlib.withConfigMixin(
                {
                  filteringSelector: config.filteringSelector,
                  uid: config.uid,
                  enableLokiLogs: config.enableLokiLogs,
                }
              );

local label_patch = {
  cluster+: {
    allValue: '.*',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = util.decorate_dashboard(mixin.grafana.dashboards[fname], tags=config.dashboardTags);
      dashboard + util.patch_variables(dashboard, label_patch)

    for fname in std.objectFields(mixin.grafana.dashboards)
  },
  prometheusAlerts+:: mixin.prometheus.alerts,
  prometheusRules+:: mixin.prometheus.recordingRules,
}
