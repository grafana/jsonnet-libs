local lib = import './main.libsonnet';

local sapHana =
  lib.new()
  + lib.withConfigMixin({
    // Override defaults if needed
  });

{
  grafanaDashboards+:: sapHana.grafana.dashboards,
  prometheusAlerts+:: sapHana.prometheus.alerts,
  prometheusRules+:: {
    groups+: [],
  },
}
