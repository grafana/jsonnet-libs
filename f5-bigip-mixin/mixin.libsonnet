local lib = import './main.libsonnet';

local f5BigIP =
  lib.new()
  + lib.withConfigMixin({
    // Override defaults if needed
  });

{
  grafanaDashboards+:: f5BigIP.grafana.dashboards,
  prometheusAlerts+:: f5BigIP.prometheus.alerts,
  prometheusRules+:: {
    groups+: [],
  },
}
