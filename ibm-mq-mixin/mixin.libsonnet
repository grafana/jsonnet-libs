local ibmmqlib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local ibmmq =
  ibmmqlib.new()
  + ibmmqlib.withConfigMixin(
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
  mq_cluster+: {
    label: 'MQ cluster',
    allValue: '.*',
    multi: false,
  },
  qmgr+: {
    label: 'Queue manager',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = ibmmq.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, label_patch)
    for fname in std.objectFields(ibmmq.grafana.dashboards)
  },
  prometheusAlerts+:: ibmmq.prometheus.alerts,
  prometheusRules+:: ibmmq.prometheus.recordingRules,
}
