// debug file to use with grafanactl
// grafanactl resources serve --script 'jsonnet -J vendor ./debug.jsonnet' --watch ./

local mixin = import 'mixin.libsonnet';

local d = mixin.grafanaDashboards['vultr-instances.json'];
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
