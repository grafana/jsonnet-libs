local k = import "ksonnet.beta.2/k8s.libsonnet",
  dashboards = import "dashboards.jsonnet";

local configMap = k.core.v1.configMap,
  deployment = k.apps.v1beta1.deployment,
  container = deployment.mixin.spec.template.spec.containersType;

local grafanaConfig(url) = @"
[auth.anonymous]
enabled = true
org_role = Admin

[dashboards.json]
enabled = true
path = /grafana/dashboards

[server]
http_port = 80
root_url = %s

[analytics]
reporting_enabled = false
" % url;

{
  grafana_config_map:
    $.util.configMap("grafana-config") +
    configMap.data({ "grafana.ini": grafanaConfig("https://localhost/admin/grafana") }),

  dashboards_config_map:
    $.util.configMap("dashboards") +
    configMap.data(dashboards),

  grafana_container::
    $.util.container("grafana", $._images.grafana) +
    $.util.containerPort("grafana", 80) +
    container.command([
      "/usr/sbin/grafana-server",
      "--homepath=/usr/share/grafana",
      "--config=/etc/grafana/grafana.ini",
    ]),

  gfdatasource_container::
    $.util.container("gfdatasource", $._images.gfdatasource) +
    container.args([
      "--grafana-url=http://admin:admin@127.0.0.1:80/api",
      "--data-source-url=http://prometheus.default.svc.cluster.local/admin/prometheus/",
      "--name=Prometheus",
      "--type=prometheus",
    ]),

  grafana_deployment:
    $.util.deployment("grafana", [
      $.grafana_container,
      $.gfdatasource_container,
    ]) +
    $.util.configVolumeMount(
      "grafana-config",
      "/etc/grafana",
    ) +
    $.util.configVolumeMount(
      "dashboards",
      "/grafana/dashboards"
    ),

  grafana_service:
    $.util.serviceFor($.grafana_deployment),
}
