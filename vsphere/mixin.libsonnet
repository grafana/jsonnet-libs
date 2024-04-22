local vspherelib = import './main.libsonnet';

local vsphere =
  vspherelib.new()
  + vspherelib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/vsphere"',
      uid: 'vsphere',
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: vsphere.grafana.dashboards,
}
