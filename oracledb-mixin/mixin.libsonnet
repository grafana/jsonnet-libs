local oracledblib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local oracledb =
  oracledblib.new()
  + oracledblib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: 'oracledb',
      enableLokiLogs: true,
    }
  );

local optional_labels = {
  cluster+: {
    allValue: '.*',
  },
  tablespace+: {
    label: 'Tablespace',
    allValue: '.*',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = oracledb.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_labels)

    for fname in std.objectFields(oracledb.grafana.dashboards)
  },

  prometheusAlerts+:: oracledb.prometheus.alerts,
  prometheusRules+:: oracledb.prometheus.recordingRules,
}
