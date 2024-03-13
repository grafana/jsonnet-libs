local pgbouncerlib = import './main.libsonnet';
local config = (import 'config.libsonnet')._config;

local pgbouncer =
  pgbouncerlib.new()
  +
  {
    config+: config,
  };

// populate monitoring-mixin:
{
  grafanaDashboards+:: pgbouncer.grafana.dashboards,
  prometheusAlerts+:: pgbouncer.prometheus.alerts,
  prometheusRules+:: pgbouncer.prometheus.recordingRules,
}
