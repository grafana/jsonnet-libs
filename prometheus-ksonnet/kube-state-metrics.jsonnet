local k = import "ksonnet.beta.2/k8s.libsonnet",
  util = import "ksonnet.beta.1/util.libsonnet";

local configMap = k.core.v1.configMap,
  deployment = k.apps.v1beta1.deployment,
  container = deployment.mixin.spec.template.spec.containersType,
  volume = deployment.mixin.spec.template.spec.volumesType,
  clusterRole = k.rbac.v1beta1.clusterRole,
  policyRule = k.rbac.v1beta1.clusterRole.rulesType,
  clusterRoleBinding = k.rbac.v1beta1.clusterRoleBinding,
  subject = k.rbac.v1beta1.clusterRoleBinding.subjectsType,
  serviceAccount = k.core.v1.serviceAccount;

{
  kube_state_metrics_service_account:
    serviceAccount.new() +
    serviceAccount.mixin.metadata.name("kube-state-metrics"),

  kube_state_metrics_cluster_role:
    clusterRole.new() +
    clusterRole.mixin.metadata.name("kube-state-metrics") +
    clusterRole.rules([
      policyRule.new() +
      policyRule.apiGroups([""]) +
      policyRule.resources(["nodes", "pods", "services", "resourcequotas", "replicationcontrollers", "limitranges"]) +
      policyRule.verbs(["list", "watch"]),

      policyRule.new() +
      policyRule.apiGroups(["extensions"]) +
      policyRule.resources(["daemonsets", "deployments", "replicasets"]) +
      policyRule.verbs(["list", "watch"]),
    ]),

  kube_state_metrics_cluster_role_binding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata.name("kube-state-metrics") +

    clusterRoleBinding.mixin.roleRef.apiGroup("rbac.authorization.k8s.io") +
    { roleRef+: { kind: "ClusterRole" } } +
    clusterRoleBinding.mixin.roleRef.name("kube-state-metrics") +

    clusterRoleBinding.subjects([
      subject.new() +
      { kind: "ServiceAccount" } +
      subject.name("kube-state-metrics") +
      subject.namespace("default"),
    ]),

  kube_state_metrics_container::
    $.util.container("kube-state-metrics", $._images.kubeStateMetrics) +
    $.util.containerPort("http", 80) +
    container.args([
      "--port=80",
    ]) +
    $.util.containerResourcesRequests("30Mi", "100m") +
    $.util.containerResourcesLimits("50Mi", "200m"),

  kube_state_metrics_deployment:
    $.util.deployment("kube-state-metrics", [$.kube_state_metrics_container]) +
    deployment.mixin.spec.template.spec.serviceAccount("kube-state-metrics"),

  kube_state_metrics_service:
    $.util.serviceFor($.kube_state_metrics_deployment),
}
