local varnishlib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';


local varnish =
  varnishlib.new()
  + varnishlib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

local label_patch = {
  cluster+: {
    allValue: '.*',
  },
};

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = varnish.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, label_patch)

    for fname in std.objectFields(varnish.grafana.dashboards)
  },
  prometheusAlerts+:: varnish.prometheus.alerts,
  prometheusRules+:: varnish.prometheus.recordingRules,
}
