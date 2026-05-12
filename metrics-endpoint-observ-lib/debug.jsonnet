// debug file to use with grafanactl
// grafanactl resources serve --script 'jsonnet -J vendor ./debug.jsonnet' --watch ./

local observlib = import 'main.libsonnet';
local mixin =
  (observlib.new()
   + observlib.withConfigMixin({
     filteringSelector: 'job=~"integrations/supabase/.+"',
     parentIntegration: {
       name: 'Supabase',
       id: 'supabase',
       logoURL: 'https://storage.googleapis.com/grafanalabs-integration-logos/supabase.svg',
     },
   })).asMonitoringMixin();

local d = mixin.grafanaDashboards['metrics-endpoint-overview.json'];
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
