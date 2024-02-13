local istiolib = import './main.libsonnet';

local istio =
  istiolib.new()
  + istiolib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/istio"',
      uid: 'istio',
      groupLabels: ['job', 'cluster'],
      // disable loki logs
      enableLokiLogs: false,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: istio.grafana.dashboards,
  prometheusAlerts+:: istio.prometheus.alerts,
  prometheusRules+:: istio.prometheus.recordingRules,
}
