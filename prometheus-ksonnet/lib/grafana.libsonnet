local k = import "kausal.libsonnet";

k {
  _config+:: {
    grafana_root_url: "http://grafana.%s.svc.cluster.local" % $._config.namespace,
  },

  # Extension point for you to add your own dashboards.
  dashboards:: {},

  grafana_config:: @"
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

[users]
default_theme = light
" % $._config.grafana_root_url,

  local configMap = $.core.v1.configMap,

  grafana_config_map:
    configMap.new("grafana-config") +
    configMap.withData({ "grafana.ini": $.grafana_config }),

  dashboards_config_map:
    configMap.new("dashboards") +
    configMap.withData({[name]: std.toString($.dashboards[name])
      for name in std.objectFields($.dashboards)}),

  local container = $.core.v1.container,

  grafana_container::
    container.new("grafana", $._images.grafana) +
    container.withPorts($.core.v1.containerPort.new("grafana", 80)) +
    container.withCommand([
      "/usr/sbin/grafana-server",
      "--homepath=/usr/share/grafana",
      "--config=/etc/grafana/grafana.ini",
    ]) +
    $.util.resourcesRequests("10m", "40Mi"),

  local deployment = $.extensions.v1beta1.deployment,

  grafana_add_datasource(name, url)::
    deployment.mixin.spec.template.spec.withContainersMixin(
      container.new("gfdatasource-%s" % name, $._images.gfdatasource) +
      container.withArgs([
        "--grafana-url=http://admin:admin@127.0.0.1:80/api",
        "--data-source-url=%s" % url,
        "--name=%s" % name,
        "--type=prometheus",
      ]) +
      $.util.resourcesRequests("10m", "20Mi"),
    ),

  grafana_deployment:
    deployment.new("grafana", 1, [$.grafana_container]) +
    $.grafana_add_datasource("prometheus", "http://prometheus.%s.svc.cluster.local%s" % [$._config.namespace, $._config.prometheus_path]) +
    $.util.configVolumeMount("grafana-config", "/etc/grafana") +
    $.util.configVolumeMount("dashboards",  "/grafana/dashboards"),

  grafana_service:
    $.util.serviceFor($.grafana_deployment),
}
