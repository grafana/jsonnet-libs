{
  dashboards+:: (import 'klumps.libsonnet') + { _config+:: { grafanaPrefix: $._config.grafana_root_url } },
  prometheus_rules+:: (import 'recording_rules.jsonnet'),
  prometheus_alerts+:: (import 'alerts.jsonnet'),
}
