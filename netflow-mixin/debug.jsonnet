// debug file to use with grafanactl

local mixin = (import 'mixin.libsonnet');
local d = mixin.grafanaDashboards['netflow-overview.json'];
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
