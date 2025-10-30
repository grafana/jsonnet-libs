local mongodbAtlaslib = import './main.libsonnet';

local mongodbAtlas =
  mongodbAtlaslib.new()
  + mongodbAtlaslib.withConfigMixin({});

// populate monitoring-mixin:
{
  grafanaDashboards+:: mongodbAtlas.grafana.dashboards,
  prometheusAlerts+:: mongodbAtlas.prometheus.alerts,
  prometheusRules+:: mongodbAtlas.prometheus.recordingRules,
}
