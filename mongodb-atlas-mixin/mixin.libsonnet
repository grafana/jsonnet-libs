local mongodbAtlaslib = import './main.libsonnet';
local util = import 'grafana-cloud-integration-utils/util.libsonnet';


local mongodbAtlas =
  mongodbAtlaslib.new()
  + mongodbAtlaslib.withConfigMixin({
    enableLokiLogs: false,
  });

local optional_labels = {
  rs_nm+: {
    label: 'Replica set',
  },
  cl_name+: {
    label: 'Atlas cluster',
  },
};

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = mongodbAtlas.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_labels)

    for fname in std.objectFields(mongodbAtlas.grafana.dashboards)
  },
  prometheusAlerts+:: mongodbAtlas.prometheus.alerts,
  prometheusRules+:: mongodbAtlas.prometheus.recordingRules,
}
