local openldaplib = import './main.libsonnet';

local openldap =
  openldaplib.new()
  + openldaplib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/openldap"',
      uid: 'openldap',
      instanceLabels: ['instance'],
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: openldap.grafana.dashboards,
  prometheusAlerts+:: openldap.prometheus.alerts,
  prometheusRules+:: openldap.prometheus.recordingRules,
}
