local influxdblib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';


local influxdb =
  influxdblib.new()
  + influxdblib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

local label_patch = {
  influxdb_cluster+: {
    allValue: '.*',
    label: 'InfluxDB cluster',
  },
};

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = influxdb.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, label_patch)

    for fname in std.objectFields(influxdb.grafana.dashboards)
  },
  prometheusAlerts+:: influxdb.prometheus.alerts,
  prometheusRules+:: influxdb.prometheus.recordingRules,
}
