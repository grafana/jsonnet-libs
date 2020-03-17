{
  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,
  local roleRef = clusterRoleBinding.roleRefType,
  local subjects = clusterRoleBinding.subjectsType,

  cainjector_psp_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-cainjector-psp')
    .withLabels({}/* TODO: labels */,) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-cainjector-psp') +
    clusterRoleBinding.withSubjects(
      subjects.new() + subjects
                       .withKind('ServiceAccount')
                       .withName('cert-manager-cainjector')
                       .withNamespace($._config.namespace)
    ),

}
