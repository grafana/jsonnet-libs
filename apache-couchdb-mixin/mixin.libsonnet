local prestolib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local presto =
  prestolib.new()
  + prestolib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

local optional_labels = {
  cluster+: {
    allValue: '.*',
  },
  couchb_cluster+: {
    label: 'CouchDB cluster',
    allValue: '.*',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = presto.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_labels)

    for fname in std.objectFields(presto.grafana.dashboards)
  },
  prometheusAlerts+:: presto.prometheus.alerts,
  prometheusRules+:: presto.prometheus.recordingRules,
}
