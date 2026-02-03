local config = import './config.libsonnet';
local lib = import './main.libsonnet';

local discourse =
  lib.new()
  + lib.withConfigMixin({
    filteringSelector: config.filteringSelector,
    uid: config.uid,
    enableLokiLogs: config.enableLokiLogs,
  });

{
  grafanaDashboards+:: discourse.grafana.dashboards,
  prometheusAlerts+:: discourse.prometheus.alerts,
  prometheusRules+:: discourse.prometheus.recordingRules,
}
