local config = import './config.libsonnet';
local lib = import './main.libsonnet';
local util = import 'grafana-cloud-integration-utils/util.libsonnet';


local saphana =
  lib.new()
  + lib.withConfigMixin({
    filteringSelector: config.filteringSelector,
    uid: config.uid,
    enableLokiLogs: config.enableLokiLogs,
  });

local optional_labels = {
  sid+: {
    label: 'SAP HANA system',
  },
  host+: {
    label: 'SAP HANA instance',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = saphana.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_labels)
    for fname in std.objectFields(saphana.grafana.dashboards)
  },
  prometheusAlerts+:: saphana.prometheus.alerts,
  prometheusRules+:: saphana.prometheus.recordingRules,
}
