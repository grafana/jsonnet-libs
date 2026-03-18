local config = import './config.libsonnet';
local vspherelib = import './main.libsonnet';


local vsphere =
  vspherelib.new()
  + vspherelib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: 'vsphere',
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: vsphere.grafana.dashboards,
  prometheusAlerts+:: vsphere.prometheus.alerts,
  prometheusRules+:: vsphere.prometheus.recordingRules,
}
