local config = import './config.libsonnet';
local istiolib = import './main.libsonnet';

local istio =
  istiolib.new()
  + istiolib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: istio.grafana.dashboards,
  prometheusAlerts+:: istio.prometheus.alerts,
  prometheusRules+:: istio.prometheus.recordingRules,
}
