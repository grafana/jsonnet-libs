local config = import './config.libsonnet';
local pgbouncerlib = import './main.libsonnet';

local pgbouncer =
  pgbouncerlib.new()
  + pgbouncerlib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: 'pgbouncer',
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: pgbouncer.grafana.dashboards,
  prometheusAlerts+:: pgbouncer.prometheus.alerts,
  prometheusRules+:: pgbouncer.prometheus.recordingRules,
}
