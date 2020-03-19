{
  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,
  local roleRef = clusterRoleBinding.roleRefType,
  local subjects = clusterRoleBinding.subjectsType,

  psp_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-psp')
    .withLabels({}/* TODO: labels */,) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-psp') +
    clusterRoleBinding.withSubjects(
      subjects.new() + subjects
                       .withKind('ServiceAccount')
                       .withName('cert-manager')
                       .withNamespace($._config.namespace)
    ),

}
