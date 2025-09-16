local couchbaselib = import './main.libsonnet';

local couchbase =
  couchbaselib.new()
  + couchbaselib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/couchbase"',
      uid: 'couchbase',
      enableLokiLogs: true,
    }
  );

// populate monitoring-mixin:
{
  grafanaDashboards+:: couchbase.grafana.dashboards,
  prometheusAlerts+:: couchbase.prometheus.alerts,
  prometheusRules+:: couchbase.prometheus.recordingRules,
}
