local apacheAirflowlib = import './main.libsonnet';
local config = (import './config.libsonnet');

local apacheAirflow =
  apacheAirflowlib.new()
  + apacheAirflowlib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]: apacheAirflow.grafana.dashboards[fname]
    for fname in std.objectFields(apacheAirflow.grafana.dashboards)
  },
  prometheusAlerts+:: apacheAirflow.prometheus.alerts,
  prometheusRules+:: apacheAirflow.prometheus.recordingRules,
}
