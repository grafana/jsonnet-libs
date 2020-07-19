{
  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,
  local subject = $.rbac.v1.subject,

  psp_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-psp') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */,) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName('cert-manager-psp') +
    clusterRoleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager') +
      subject.withNamespace($._config.namespace),
    ]),

}
