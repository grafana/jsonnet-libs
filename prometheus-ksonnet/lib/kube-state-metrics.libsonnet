local kube_state_metrics = 'kube-state-metrics/main.libsonnet';
local ksm_scrape_config = 'kube-state-metrics/scrape_config.libsonnet';

{
  local ksm = kube_state_metrics(
    $._config.namespace,
    $._images.kubeStateMetrics,
    $._config.enable_pod_priorities,
  ),

  kube_state_metrics_rbac: ksm.rbac,

  kube_state_metrics_container:: ksm.container,

  kube_state_metrics_deployment:
    ksm.deployment
    + deployment.spec.template.spec.withContainers([$.kube_state_metrics_container])
    + deployment.mixin.spec.template.spec.securityContext.withFsGroup(0),  // TODO: remove after kube-state-metrics binary in docker image is not owned by root

  kube_state_metrics_service:
    $.util.serviceFor($.kube_state_metrics_deployment),

  prometheus_config+:: {
    scrape_configs+: [
      ksm_scrape_config($._config.namespace),
    ],
  },
}
