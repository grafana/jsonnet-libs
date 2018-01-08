local k = import "ksonnet.beta.2/k8s.libsonnet";

local clusterRoleBinding = k.rbac.v1beta1.clusterRoleBinding,
  subject = k.rbac.v1beta1.clusterRoleBinding.subjectsType,
  serviceAccount = k.core.v1.serviceAccount;

{
  // Service account for continuous deployment.
  deploy_service_account:
    serviceAccount.new() +
    serviceAccount.mixin.metadata.name("deploy"),

  deploy_cluster_role_binding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata.name("deploy") +
    clusterRoleBinding.mixin.roleRef.apiGroup("rbac.authorization.k8s.io") +
    { roleRef+: { kind: "ClusterRole" } } +
    clusterRoleBinding.mixin.roleRef.name("admin") +
    clusterRoleBinding.subjects([
      subject.new() +
      { kind: "ServiceAccount" } +
      subject.name("deploy") +
      subject.namespace("default"),
    ]),
}
