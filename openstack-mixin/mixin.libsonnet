local openstacklib = import './main.libsonnet';

local openstack =
  openstacklib.new()
  + openstacklib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/openstack"',
      uid: 'openstack',
      groupLabels: ['job'],
      enableLokiLogs: true,
    }
  );

{
  grafanaDashboards+:: openstack.grafana.dashboards,
  prometheusAlerts+:: openstack.prometheus.alerts,
  prometheusRules+:: openstack.prometheus.recordingRules,
}
