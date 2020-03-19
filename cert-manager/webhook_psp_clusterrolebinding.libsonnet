{
  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,
  local roleRef = clusterRoleBinding.roleRefType,
  local subjects = clusterRoleBinding.subjectsType,

  webhook_psp_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-webhook-psp')
    .withLabels({}/* TODO: labels */,) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-webhook-psp') +
    clusterRoleBinding.withSubjects(
      subjects.new() + subjects
                       .withKind('ServiceAccount')
                       .withName('cert-manager-webhook')
                       .withNamespace($._config.namespace)
    ),

}
