local k = import "kausal.libsonnet";

k {
  _config+:: {
    slack_url: "http://slack",
    slack_channel: "general",

    alertmanager_external_hostname: "http://alertmanager.%s.svc.cluster.local" % $._config.namespace,
    alertmanager_path: "/alertmanager/",
    alertmanager_port: 80,
  },

  alertmanager_config:: {
    templates: ["/etc/alertmanager/*.tmpl"],
    route: {
      group_by: ["alertname"],
      receiver: "slack",
    },

    receivers: [{
      name: "slack",
      slack_configs: [{
        api_url: $._config.slack_url,
        channel: $._config.slack_channel,
      }],
    }],
  },

  local configMap = $.core.v1.configMap,

  aletrmanager_config_map:
    configMap.new("alertmanager-config") +
    configMap.withData({
      "alertmanager.yml": $.util.manifestYaml($.alertmanager_config),
    }),

  local container = $.core.v1.container,

  alertmanager_container::
    container.new("alertmanager", $._images.alertmanager) +
    container.withPorts($.core.v1.containerPort.new("http-metrics", $._config.alertmanager_port)) +
    container.withArgs([
      "--log.level=info",
      "--config.file=/etc/alertmanager/alertmanager.yml",
      "--web.listen-address=:%s" % $._config.alertmanager_port,
      "--web.external-url=%s%s" % [$._config.alertmanager_external_hostname, $._config.alertmanager_path],
    ]) +
    container.mixin.resources.withRequests({
      cpu: "10m",
      memory: "40Mi",
    }),

  alertmanager_watch_container::
    container.new("watch", $._images.watch) +
    container.withArgs([
      "-v", "-t", "-p=/etc/alertmanager",
      "curl", "-X", "POST", "--fail", "-o", "-", "-sS",
      "http://localhost:%s%s-/reload" % [$._config.alertmanager_port, $._config.alertmanager_path],
    ]) +
    container.mixin.resources.withRequests({
      cpu: "10m",
      memory: "20Mi",
    }),

  local deployment = $.apps.v1beta1.deployment,

  alertmanager_deployment:
    deployment.new("alertmanager", 1, [
      $.alertmanager_container,
      $.alertmanager_watch_container,
    ]) +
    deployment.mixin.spec.template.metadata.withAnnotations({ "prometheus.io.path": "%smetrics" % $._config.alertmanager_path }) +
    $.util.configVolumeMount("alertmanager-config", "/etc/alertmanager"),

  alertmanager_service:
    $.util.serviceFor($.alertmanager_deployment),
}
