local solrlib = import './main.libsonnet';
local config = (import './config.libsonnet');

local solr =
  solrlib.new()
  + solrlib.withConfigMixin({
    filteringSelector: config.filteringSelector,
    uid: config.uid,
    enableLokiLogs: config.enableLokiLogs,
  });

// populate monitoring-mixin:
{
  grafanaDashboards+:: {
    [fname]: solr.grafana.dashboards[fname]
    for fname in std.objectFields(solr.grafana.dashboards)
  },
  prometheusAlerts+:: solr.prometheus.alerts,
  prometheusRules+:: solr.prometheus.recordingRules,
}
