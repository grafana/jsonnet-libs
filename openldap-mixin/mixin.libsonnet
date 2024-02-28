local openldaplib = import './main.libsonnet';

local openldap =
  openldaplib.new()
  + openldaplib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/openldap"',
      uid: 'openldap',
      groupLabels: ['job', 'cluster'],
      instanceLabels: ['instance'],
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: openldap.grafana.dashboards,
  prometheusAlerts+:: openldap.prometheus.alerts,
  prometheusRules+:: openldap.prometheus.recordingRules,
}
