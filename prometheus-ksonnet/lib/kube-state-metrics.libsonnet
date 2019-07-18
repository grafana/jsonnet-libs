{
  local policyRule = $.rbac.v1beta1.policyRule,

  kube_state_metrics_rbac:
    $.util.rbac('kube-state-metrics', [
      policyRule.new() +
      policyRule.withApiGroups(['']) +
      policyRule.withResources([
        'configmaps',
        'secrets',
        'nodes',
        'pods',
        'services',
        'resourcequotas',
        'replicationcontrollers',
        'limitranges',
        'persistentvolumeclaims',
        'persistentvolumes',
        'namespaces',
        'endpoints',
      ]) +
      policyRule.withVerbs(['list', 'watch']),

      policyRule.new() +
      policyRule.withApiGroups(['extensions']) +
      policyRule.withResources([
        'daemonsets',
        'deployments',
        'replicasets',
        'ingresses',
      ]) +
      policyRule.withVerbs(['list', 'watch']),

      policyRule.new() +
      policyRule.withApiGroups(['apps']) +
      policyRule.withResources([
        'daemonsets',
        'deployments',
        'replicasets',
        'statefulsets',
      ]) +
      policyRule.withVerbs(['list', 'watch']),

      policyRule.new() +
      policyRule.withApiGroups(['batch']) +
      policyRule.withResources([
        'cronjobs',
        'jobs',
      ]) +
      policyRule.withVerbs(['list', 'watch']),

      policyRule.new() +
      policyRule.withApiGroups(['autoscaling']) +
      policyRule.withResources([
        'horizontalpodautoscalers',
      ]) +
      policyRule.withVerbs(['list', 'watch']),

      policyRule.new() +
      policyRule.withApiGroups(['ingresses']) +
      policyRule.withResources(['ingress']) +
      policyRule.withVerbs(['list', 'watch']),

      policyRule.new() +
      policyRule.withApiGroups(['policy']) +
      policyRule.withResources(['poddisruptionbudgets']) +
      policyRule.withVerbs(['list', 'watch']),

      policyRule.new() +
      policyRule.withApiGroups(['certificates.k8s.io']) +
      policyRule.withResources(['certificatesigningrequests']) +
      policyRule.withVerbs(['list', 'watch']),
    ]),

  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,

  kube_state_metrics_container::
    container.new('kube-state-metrics', $._images.kubeStateMetrics) +
    container.withArgs([
      '--port=80',
      '--telemetry-host=0.0.0.0',
      '--telemetry-port=81',
    ]) +
    container.withPorts([
      containerPort.new('http-metrics', 80),
      containerPort.new('self-metrics', 81),
    ]) +
    $.util.resourcesRequests('50m', '50Mi') +
    $.util.resourcesLimits('250m', '150Mi'),

  local deployment = $.apps.v1beta1.deployment,

  kube_state_metrics_deployment:
    deployment.new('kube-state-metrics', 1, [
      $.kube_state_metrics_container,
    ]) +
    // Stop the default pod discovery scraping this pod - we use a special
    // scrape config to preserve namespace etc labels.
    deployment.mixin.spec.template.metadata.withAnnotationsMixin({ 'prometheus.io.scrape': 'false' }) +
    (if $._config.enable_rbac
     then deployment.mixin.spec.template.spec.withServiceAccount('kube-state-metrics')
     else {}) +
    $.util.podPriority('critical'),

  kube_state_metrics_service:
    $.util.serviceFor($.kube_state_metrics_deployment),
}
