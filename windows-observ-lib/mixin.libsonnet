local windowslib = import './main.libsonnet';
{
  _config:: {},
  _windowsib::
    windowslib.new()
    + windowslib.withConfigMixin(self._config),
  grafanaDashboards+:: self._windowsib.grafana.dashboards,
  prometheusAlerts+:: self._windowsib.prometheus.alerts,
  prometheusRules+:: self._windowsib.prometheus.recordingRules,
}
