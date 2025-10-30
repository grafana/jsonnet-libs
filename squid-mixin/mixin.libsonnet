local lib = import './main.libsonnet';

local squid =
  lib.new()
  + lib.withConfigMixin({
    // Override defaults if needed
  });

{
  grafanaDashboards+:: squid.grafana.dashboards,
  prometheusAlerts+:: squid.prometheus.alerts,
  prometheusRules+:: {
    groups+: [],
  },
}
