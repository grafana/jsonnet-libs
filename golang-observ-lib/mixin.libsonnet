local golanglib = import './main.libsonnet';

local golang =
  golanglib.new()
  + golanglib.withConfigMixin(
    {
      filteringSelector: 'job!=""',
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: golang.grafana.dashboards,
  prometheusAlerts+:: golang.prometheus.alerts,
  prometheusRules+:: golang.prometheus.recordingRules,
}
