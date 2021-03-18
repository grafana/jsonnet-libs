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
      '--port=8080',
      '--telemetry-host=0.0.0.0',
      '--telemetry-port=8081',
    ]) +
    container.withPorts([
      containerPort.new('http-metrics', 8080),
      containerPort.new('self-metrics', 8081),
    ]) +
    $.util.resourcesRequests('50m', '50Mi') +
    $.util.resourcesLimits('250m', '150Mi'),

  local deployment = $.apps.v1.deployment,

  kube_state_metrics_deployment:
    deployment.new('kube-state-metrics', 1, [
      $.kube_state_metrics_container,
    ]) +
    // Stop the default pod discovery scraping this pod - we use a special
    // scrape config to preserve namespace etc labels.
    deployment.mixin.spec.template.metadata.withAnnotationsMixin({ 'prometheus.io.scrape': 'false' }) +
    deployment.mixin.spec.template.spec.withServiceAccount('kube-state-metrics') +
    deployment.mixin.spec.template.spec.securityContext.withRunAsUser(65534) +
    deployment.mixin.spec.template.spec.securityContext.withRunAsGroup(65534) +
    deployment.mixin.spec.template.spec.securityContext.withFsGroup(0) +  // TODO: remove after kube-state-metrics binary in docker image is not owned by root
    $.util.podPriority('critical'),

  kube_state_metrics_service:
    $.util.serviceFor($.kube_state_metrics_deployment),

  prometheus_config+:: {
    scrape_configs+: [
      // A separate scrape config for kube-state-metrics which doesn't
      // add namespace, container, and pod labels, instead taking
      // those labels from the exported timeseries. This prevents them
      // being renamed to exported_namespace etc.  and allows us to
      // route alerts based on namespace and join KSM metrics with
      // cAdvisor metrics.
      {
        job_name: '%s/kube-state-metrics' % $._config.namespace,
        kubernetes_sd_configs: [{
          role: 'pod',
          namespaces: {
            names: [$._config.namespace],
          },
        }],

        relabel_configs: [

          // Drop anything whose service is not kube-state-metrics.
          {
            source_labels: ['__meta_kubernetes_pod_label_name'],
            regex: 'kube-state-metrics',
            action: 'keep',
          },

          // Rename instances to the concatenation of pod:container:port.
          // In the specific case of KSM, we could leave out the container
          // name and still have a unique instance label, but we leave it
          // in here for consistency with the normal pod scraping.
          {
            source_labels: [
              '__meta_kubernetes_pod_name',
              '__meta_kubernetes_pod_container_name',
              '__meta_kubernetes_pod_container_port_name',
            ],
            action: 'replace',
            separator: ':',
            target_label: 'instance',
          },
        ],
      },
    ],
  },
}
