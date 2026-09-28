local vspherelib = import './main.libsonnet';

local vsphere = vspherelib.new();

// populate monitoring-mixin:
{
  grafanaDashboards+:: vsphere.grafana.dashboards,
  prometheusAlerts+:: vsphere.prometheus.alerts,
  prometheusRules+:: vsphere.prometheus.recordingRules,
}
