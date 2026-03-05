local config = import './config.libsonnet';
local dragonflylib = import './main.libsonnet';

local dragonfly =
  dragonflylib.new()
  + dragonflylib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
    }
  );

{
  grafanaDashboards+:: dragonfly.grafana.dashboards,
  prometheusAlerts+:: dragonfly.prometheus.alerts,
  prometheusRules+:: dragonfly.prometheus.recordingRules,
}
