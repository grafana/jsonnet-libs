local vultrlib = import './main.libsonnet';
local config = (import './config.libsonnet');

local vultr =
  vultrlib.new()
  + vultrlib.withConfigMixin({
    filteringSelector: config.filteringSelector,
    uid: config.uid,
    enableLokiLogs: config.enableLokiLogs,
  });

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]: vultr.grafana.dashboards[fname]
    for fname in std.objectFields(vultr.grafana.dashboards)
  },
  prometheusAlerts+:: vultr.prometheus.alerts,
  prometheusRules+:: vultr.prometheus.recordingRules,
}
