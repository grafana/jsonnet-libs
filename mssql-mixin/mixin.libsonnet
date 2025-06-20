local mssqllib = import './main.libsonnet';

local mssql =
  mssqllib.new()
  + mssqllib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/mssql"',
      uid: 'mssql',
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: mssql.grafana.dashboards,
  prometheusAlerts+:: mssql.prometheus.alerts,
  prometheusRules+:: mssql.prometheus.recordingRules,
}
