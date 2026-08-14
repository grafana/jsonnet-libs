local config = import './config.libsonnet';
local openstacklib = import './main.libsonnet';

local openstack =
  openstacklib.new()
  + openstacklib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      groupLabels: config.groupLabels,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

{
  grafanaDashboards+:: openstack.grafana.dashboards,
  prometheusAlerts+:: openstack.prometheus.alerts,
  prometheusRules+:: openstack.prometheus.recordingRules,
}
