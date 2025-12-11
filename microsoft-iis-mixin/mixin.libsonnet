local iislib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local iis =
  iislib.new()
  + iislib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

local optional_labels = {
  site+: {
    label: 'Site',
    allValue: '.*',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = iis.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_labels)

    for fname in std.objectFields(iis.grafana.dashboards)
  },

  prometheusAlerts+:: iis.prometheus.alerts,
  prometheusRules+:: iis.prometheus.recordingRules,
}
