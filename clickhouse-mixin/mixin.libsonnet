local mixinlib = import './main.libsonnet';

local mixin =
  mixinlib.new()
  + mixinlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/mixin"',
      uid: 'mixin',
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: mixin.grafana.dashboards,
  prometheusAlerts+:: mixin.prometheus.alerts,
  prometheusRules+:: mixin.prometheus.recordingRules,
}
