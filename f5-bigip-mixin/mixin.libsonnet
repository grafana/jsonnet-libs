local main = import './main.libsonnet';

// Create the mixin with default configuration
local mixin = main.new();

// Export in the standard mixin format
{
  grafanaDashboards+:: mixin.grafana.dashboards,
  prometheusAlerts+:: {
    groups+: mixin.prometheus.alerts.groups,
  },
  prometheusRules+:: mixin.prometheus.recordingRules,
}
