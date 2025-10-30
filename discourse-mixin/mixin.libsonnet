local lib = import './main.libsonnet';

local discourse =
  lib.new()
  + lib.withConfigMixin({
    // Override defaults if needed
  });

{
  grafanaDashboards+:: discourse.grafana.dashboards,
  prometheusAlerts+:: discourse.prometheus.alerts,
  prometheusRules+:: {
    groups+: [],
  },
}
