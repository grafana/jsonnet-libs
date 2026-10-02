// Legacy surface: `(import 'mixin.libsonnet') { _config+:: {...} }` keeps working.
local lib = import './main.libsonnet';

{
  _config:: {},
  local l = lib.new() + lib.withConfigMixin(self._config),
  grafanaDashboards+:: l.grafana.dashboards,
  prometheusAlerts+:: l.prometheus.alerts,
  prometheusRules+:: l.prometheus.recordingRules,
  grafanaDashboardFolder:: 'MinIO',
}
