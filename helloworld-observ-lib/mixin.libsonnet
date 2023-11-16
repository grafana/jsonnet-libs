local helloworldlib = import './main.libsonnet';

local helloworld =
  helloworldlib.new(
    filteringSelector='job=~"integrations/helloworld"',
    uid='myhelloworld',
    groupLabels=['environment', 'cluster', 'job'],
    instanceLabels=['instance'],
  )
  + helloworldlib.withConfigMixin(
    {
      // disable loki logs
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: helloworld.grafana.dashboards,
  prometheusAlerts+:: helloworld.prometheus.alerts,
  prometheusRules+:: helloworld.prometheus.recordingRules,
}
