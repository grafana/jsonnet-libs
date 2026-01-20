local redisEnterpriseMixin = import './main.libsonnet';
local config = (import './config.libsonnet');
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local redisEnterprise = redisEnterpriseMixin.new()
                        + redisEnterpriseMixin.withConfigMixin(
                          {
                            filteringSelector: config.filteringSelector,
                            uid: config.uid,
                            enableLokiLogs: config.enableLokiLogs,
                          },
                        );

local optional_labels = {
  redis_cluster+: {
    label: 'Redis cluster',
    allValue: '.*',
  },
  node+: {
    label: 'Node',
  },
  bdb+: {
    label: 'Database',
  },
};

{
  grafanaDashboards+:: {
    [fname]:
      local dashboard = redisEnterprise.grafana.dashboards[fname];
      dashboard + util.patch_variables(dashboard, optional_labels)

    for fname in std.objectFields(redisEnterprise.grafana.dashboards)
  },
  prometheusAlerts+:: redisEnterprise.prometheus.alerts,
  prometheusRules+:: redisEnterprise.prometheus.recordingRules,
}
