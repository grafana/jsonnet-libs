local tomcatLib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local mixin =
  tomcatLib.new()
  + tomcatLib.withConfigMixin({
    filteringSelector: config.filteringSelector,
    uid: config.uid,
    enableLokiLogs: config.enableLokiLogs,
  });

local k8s_patch = {
  cluster+: {
    allValue: '.*',
  },
  host+: {
    allValue: '.*',
  },
};

{
  grafanaDashboards+:: {
    local tags = config.dashboardTags,
    [fname]:
      local dashboard = util.decorate_dashboard(mixin.grafana.dashboards[fname], tags=tags);
      dashboard + util.patch_variables(dashboard, k8s_patch)

    for fname in std.objectFields(mixin.grafana.dashboards)
  },
  prometheusAlerts+:: mixin.prometheus.alerts,
  prometheusRules+:: mixin.prometheus.recordingRules,
}
