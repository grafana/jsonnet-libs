local couchdblib = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local couchdb =
  couchdblib.new()
  + couchdblib.withConfigMixin(
    {
      filteringSelector: config.filteringSelector,
      uid: config.uid,
      enableLokiLogs: config.enableLokiLogs,
    }
  );

local optional_labels = {
  cluster+: {
    allValue: '.*',
  },
  couchdb_cluster+: {
    label: 'CouchDB cluster',
    allValue: '.*',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = couchdb.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_labels)

    for fname in std.objectFields(couchdb.grafana.dashboards)
  },
  prometheusAlerts+:: couchdb.prometheus.alerts,
  prometheusRules+:: couchdb.prometheus.recordingRules,
}
