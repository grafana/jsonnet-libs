local pgbouncerlib = import './main.libsonnet';

local pgbouncer =
  pgbouncerlib.new()
  + pgbouncerlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/pgbouncer"',
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
