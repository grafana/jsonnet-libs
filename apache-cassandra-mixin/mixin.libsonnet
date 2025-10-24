local mixinlib = (import './main.libsonnet');
local config = import './config.libsonnet';
local util = import 'grafana-cloud-integration-utils/util.libsonnet';


local mixin =
  mixinlib.new()
  + mixinlib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

local labels_patch = {
  cassandra_cluster+: {
    label: 'Cassandra cluster',
    allValue: '.*',
  },
  datacenter+: {
    label: 'Datacenter',
    allValue: '.*',
  },
  rack+: {
    allValue: '.*',
  },
};

{
  grafanaDashboards+:: {
    local tags = config.dashboardTags,
    [fname]:
      local dashboard = util.decorate_dashboard(mixin.grafana.dashboards[fname], tags=tags);
      dashboard + util.patch_variables(dashboard, labels_patch)

    for fname in std.objectFields(mixin.grafana.dashboards)
  },
  prometheusAlerts+:: mixin.prometheus.alerts,
  prometheusRules+:: mixin.prometheus.recordingRules,
}
