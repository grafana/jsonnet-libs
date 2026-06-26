local config = import './config.libsonnet';
local f5lib = import './main.libsonnet';
local util = import 'grafana-cloud-integration-utils/util.libsonnet';

local mixin = f5lib.new()
              + f5lib.withConfigMixin(
                config,
              );

{
  grafanaDashboards+:: mixin.grafana.dashboards,
  prometheusAlerts+:: {
    groups+: mixin.prometheus.alerts.groups,
  },
  prometheusRules+:: mixin.prometheus.recordingRules,
}
