local mixinlib = import './main.libsonnet';

local mixin =
  mixinlib.new()
  + mixinlib.withConfigMixin(
    {
      filteringSelector: 'job=~"$job"',
      uid: 'mixin',
      enableLokiLogs: true,
    }
  );

{
  grafanaDashboards+:: mixin.grafana.dashboards,
  prometheusAlerts+:: mixin.prometheus.alerts,
  prometheusRules+:: mixin.prometheus.recordingRules,
}
