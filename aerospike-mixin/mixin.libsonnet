local mixinlib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local mixin =
  mixinlib.new()
  + mixinlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/aerospike"',
      uid: 'aerospike',
      enableLokiLogs: true,
    }
  );

local k8s_patch = {
  aerospike_cluster+: {
    label: 'Aerospike cluster',
  },
  cluster+: {
    allValue: '.*',
  },
  ns+: {
    allValue: '.*',
    label: 'Namespace',
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
