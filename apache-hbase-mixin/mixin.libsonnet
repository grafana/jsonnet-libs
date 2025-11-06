local hbaselib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local hbase = hbaselib.new()
              + hbaselib.withConfigMixin(
                {
                  filteringSelector: config.filteringSelector,
                  uid: config.uid,
                  enableLokiLogs: config.enableLokiLogs,
                },
              );

local optional_lablels = {
  cluster+: {
    allValue: '.*',
  },
  hbase_cluster+: {
    label: 'Apache HBase cluster',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = hbase.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_lablels)
    for fname in std.objectFields(hbase.grafana.dashboards)
  },
  prometheusAlerts+:: hbase.prometheus.alerts,
  prometheusRules+:: hbase.prometheus.recordingRules,
}
