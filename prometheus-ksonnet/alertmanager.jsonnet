local k = import "ksonnet.beta.2/k8s.libsonnet",
  util = import "ksonnet.beta.1/util.libsonnet";

local configMap = k.core.v1.configMap,
  deployment = k.apps.v1beta1.deployment,
  container = deployment.mixin.spec.template.spec.containersType;

{
  alertmanagerConfig:: |||
    templates:
    - '/etc/alertmanager/*.tmpl'

    route:
      group_by: ['namespace', 'alertname']

      # If an alert isn't caught by a route, send it to victorops.
      receiver: victorops

      # Send all dev alerts, and any warning, to slack.
      routes:
        - match:
            namespace: dev
          receiver: slack
        - match:
            severity: warning
          receiver: slack

    receivers:
    - name: slack
      slack_configs:
      - api_url: %(slack_url)s
        channel: 'production'
    - name: victorops
      victorops_configs:
      - api_key: %(victorops_key)s
        routing_key: on-call
  ||| % $._config,

  aletrmanager_config_map:
    $.util.configMap("alertmanager-config") +
    configMap.data({ "alertmanager.yml": $.alertmanagerConfig }),

  alertmanager_container::
    $.util.container("alertmanager", $._images.alertmanager) +
    $.util.containerPort("http", 80) +
    container.args([
      "-log.level=debug",
      "-config.file=/etc/alertmanager/alertmanager.yml",
      "-web.listen-address=:80",
      "-web.external-url=https://localhost/admin/alertmanager/",
    ]),

  alertmanager_watch_container::
    $.util.container("watch", $._images.watch) +
    container.args([
      "-v", "-t", "-p=/etc/alertmanager",
      "curl", "-X", "POST", "--fail", "-o", "-", "-sS", "http://localhost:80/admin/alertmanager/-/reload",
    ]),

  alertmanager_deployment:
    $.util.deployment("alertmanager", [
      $.alertmanager_container,
      $.alertmanager_watch_container,
    ]) +
    $.util.configVolumeMount(
      "alertmanager-config",
      "/etc/alertmanager",
    ) +
    deployment.mixin.spec.template.metadata.annotations({ "prometheus.io.path": "/admin/alertmanager/metrics" }),

  alertmanager_service:
    $.util.serviceFor($.alertmanager_deployment),
}
