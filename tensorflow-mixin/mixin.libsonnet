local tensorflowlib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';


local tensorflow =
  tensorflowlib.new()
  + tensorflowlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/tensorflow"',
      uid: 'tensorflow',
      enableLokiLogs: true,
    }
  );

local patch_variables = {
  cluster+: {
    allValue: '.*',
  },
  model_name+: {
    allValue: '.*',
    label: 'Model name',
  },
};

{
  grafanaDashboards+:: {
    local tags = config.dashboardTags,
    [fname]:
      local dashboard = util.decorate_dashboard(tensorflow.grafana.dashboards[fname], tags=tags);
      dashboard + util.patch_variables(dashboard, patch_variables)

    for fname in std.objectFields(tensorflow.grafana.dashboards)
  },
  prometheusAlerts+:: tensorflow.prometheus.alerts,
  prometheusRules+:: tensorflow.prometheus.recordingRules,
}
