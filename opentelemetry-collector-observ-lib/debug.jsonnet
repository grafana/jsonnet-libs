// debug file to use with grafanactl

local otelcollib = import 'main.libsonnet';
local otelcol =
  otelcollib.new()
  + otelcollib.withConfigMixin({});
local mixin = otelcol.asMonitoringMixin();

local d = mixin.grafanaDashboards['otelcol-overview.json'];
{
  apiVersion: 'dashboard.grafana.app/v1beta1',
  kind: 'Dashboard',
  metadata: {
    name: d.uid,
    annotations: {
      'grafana.app/folder': '',
    },
  },
  spec: d,
}
