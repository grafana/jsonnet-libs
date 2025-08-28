local activemqlib = import './main.libsonnet';
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local activemq =
  activemqlib.new()
  + activemqlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/apache-activemq"',
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
