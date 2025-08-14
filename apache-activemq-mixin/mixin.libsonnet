local activemqlib = import './main.libsonnet';
local config = (import './config.libsonnet');

local activemq =
  activemqlib.new()
  + activemqlib.withConfigMixin(
    {
      filteringSelector: 'job=~"integrations/apache-activemq"',
      uid: 'apache-activemq',
      enableLokiLogs: true,
    }
  );

{
  grafanaDashboards+:: {
    [fname]: activemq.grafana.dashboards[fname]
    for fname in std.objectFields(activemq.grafana.dashboards)
  },

  prometheusAlerts+:: activemq.prometheus.alerts,
  prometheusRules+:: activemq.prometheus.recordingRules,
}
