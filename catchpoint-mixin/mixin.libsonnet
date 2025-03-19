local catchpointlib = import './main.libsonnet';

local catchpoint =
  catchpointlib.new()
  + catchpointlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/catchpoint"',
      uid: 'catchpoint',
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: catchpoint.grafana.dashboards,
  prometheusAlerts+:: catchpoint.prometheus.alerts,
  prometheusRules+:: catchpoint.prometheus.recordingRules,
}
