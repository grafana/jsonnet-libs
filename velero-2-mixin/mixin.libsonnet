local velerolib = import './main.libsonnet';

local velero =
  velerolib.new()
  + velerolib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/velero"',
      uid: 'velero',
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: velero.grafana.dashboards,
  prometheusAlerts+:: velero.prometheus.alerts,
  prometheusRules+:: velero.prometheus.recordingRules,

}
