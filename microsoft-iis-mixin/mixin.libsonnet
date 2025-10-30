local lib = import './main.libsonnet';
local config = (import './config.libsonnet');

local microsoftIIS =
  lib.new()
  + lib.withConfigMixin({
    filteringSelector: config.filteringSelector,
    uid: config.uid,
    enableLokiLogs: config.enableLokiLogs,
  });

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]: microsoftIIS.grafana.dashboards[fname]
    for fname in std.objectFields(microsoftIIS.grafana.dashboards)
  },
  prometheusAlerts+:: microsoftIIS.prometheus.alerts,
  prometheusRules+:: microsoftIIS.prometheus.recordingRules,
}
