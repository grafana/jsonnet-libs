local activemqlib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local activemq =
  activemqlib.new()
  + activemqlib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: 'apache-activemq',
      enableLokiLogs: true,
    }
  );


local var_patch = {
  activemq_cluster+: {
    label: 'ActiveMQ cluster',
  },
};


{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = activemq.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, var_patch)

    for fname in std.objectFields(activemq.grafana.dashboards)
  },

  prometheusAlerts+:: activemq.prometheus.alerts,
  prometheusRules+:: activemq.prometheus.recordingRules,
}
