local apacheAirflowlib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local apacheAirflow =
  apacheAirflowlib.new()
  + apacheAirflowlib.withConfigMixin(
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
  dag_id+: {
    label: 'DAG',
  },
  dag_file+: {
    label: 'DAG',
  },
};

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]: apacheAirflow.grafana.dashboards[fname] + util.patch_variables(apacheAirflow.grafana.dashboards[fname], label_patch)
    for fname in std.objectFields(apacheAirflow.grafana.dashboards)
  },
  prometheusAlerts+:: apacheAirflow.prometheus.alerts,
  prometheusRules+:: apacheAirflow.prometheus.recordingRules,
}
