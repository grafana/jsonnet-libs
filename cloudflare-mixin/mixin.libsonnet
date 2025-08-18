local cloudflarelib = import './main.libsonnet';
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local cloudflare =
  cloudflarelib.new() +
  cloudflarelib.withConfigMixin({
    filteringSelector: 'job=~"integrations/cloudflare"',
    uid: 'cloudflare',
  });

local optional_labels = {
  script_name+: {
    allValue: '.*',
    label: 'Script',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = cloudflare.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_labels)

    for fname in std.objectFields(cloudflare.grafana.dashboards)
  },
  prometheusAlerts+:: cloudflare.prometheus.alerts,
  prometheusRules+:: cloudflare.prometheus.recordingRules,
}
