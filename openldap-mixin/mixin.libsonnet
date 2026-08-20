local config = import './config.libsonnet';
local openldaplib = import './main.libsonnet';

local openldap =
  openldaplib.new()
  + openldaplib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
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
