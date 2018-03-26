local k = import "kausal.libsonnet";

k {
  _config+:: {
    prometheus_external_hostname: "http://prometheus.%s.svc.cluster.local" % $._config.namespace,
    prometheus_path: "/prometheus/",
    prometheus_port: 80,
    prometheus_web_route_prefix: $._config.prometheus_path,
    prometheus_resources_requests_cpu: "250m",
    prometheus_resources_requests_memory: "1536Mi",
    prometheus_resources_limits_cpu: "500m",
    prometheus_resources_limits_memory: "2Gi",
  },

  local policyRule = $.rbac.v1beta1.policyRule,

  prometheus_rbac:
    $.util.rbac("prometheus", [
      policyRule.new() +
      policyRule.withApiGroups([""]) +
      policyRule.withResources(["nodes", "nodes/proxy", "services", "endpoints", "pods"]) +
      policyRule.withVerbs(["get", "list", "watch"]),

      policyRule.new() +
      policyRule.withNonResourceUrls("/metrics") +
      policyRule.withVerbs(["get"]),
    ]),

  local container = $.core.v1.container,

  prometheus_container::
    container.new("prometheus", $._images.prometheus) +
    container.withPorts($.core.v1.containerPort.new("http-metrics", 80)) +
    container.withArgs([
      "--config.file=/etc/prometheus/prometheus.yml",
      "--web.listen-address=:%s" % $._config.prometheus_port,
      "--web.external-url=%s%s" % [$._config.prometheus_external_hostname, $._config.prometheus_path],
      "--web.enable-lifecycle",
      "--web.route-prefix=%s" % $._config.prometheus_web_route_prefix,
    ]) +
    $.util.resourcesRequests($._config.prometheus_resources_requests_cpu, $._config.prometheus_resources_requests_memory) +
    $.util.resourcesLimits($._config.prometheus_resources_limits_cpu, $._config.prometheus_resources_limits_memory),

  prometheus_watch_container::
    container.new("watch", $._images.watch) +
    container.withArgs([
      "-v", "-t", "-p=/etc/prometheus",
      "curl", "-X", "POST", "--fail", "-o", "-", "-sS",
      "http://localhost:%s%s-/reload" % [$._config.prometheus_port, $._config.prometheus_web_route_prefix],
    ]),

  local deployment = $.apps.v1beta1.deployment,

  prometheus_deployment:
    deployment.new("prometheus", 1, [
      $.prometheus_container,
      $.prometheus_watch_container,
    ]) +
    $.util.configVolumeMount("prometheus-config", "/etc/prometheus") +
    deployment.mixin.spec.template.metadata.withAnnotations({ "prometheus.io.path": "%smetrics" % $._config.prometheus_web_route_prefix }) +
    deployment.mixin.spec.template.spec.withServiceAccount("prometheus") +
    deployment.mixin.spec.template.spec.securityContext.withRunAsUser(0),

  prometheus_service:
    $.util.serviceFor($.prometheus_deployment),
}
