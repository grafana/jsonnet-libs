{
  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  cainjector_clusterrole:
    clusterRole.new('cert-manager-cainjector') +
    clusterRole.metadata.withNamespace('kube-system') +
    clusterRole.metadata.withLabels({}/* TODO:labels */) +
    clusterRole.withRules(
      [
        policyRule.withApiGroups('cert-manager.io') +
        policyRule.withResources(['certificates']) +
        policyRule.withVerbs(['get', 'list', 'watch']),

        policyRule.withApiGroups('') +
        policyRule.withResources(['secrets']) +
        policyRule.withVerbs(['get', 'list', 'watch']),

        policyRule.withApiGroups('') +
        policyRule.withResources(['events']) +
        policyRule.withVerbs(['get', 'create', 'update', 'patch']),

        policyRule.withApiGroups('admissionregistration.k8s.io') +
        policyRule.withResources(['validatingwebhookconfigurations', 'mutatingwebhookconfigurations']) +
        policyRule.withVerbs(['get', 'list', 'watch', 'update']),

        policyRule.withApiGroups(['apiregistration.k8s.io']) +
        policyRule.withResources(['apiservices']) +
        policyRule.withVerbs(['get', 'list', 'watch', 'update']),

        policyRule.withApiGroups(['apiextensions.k8s.io']) +
        policyRule.withResources(['customresourcedefinitions']) +
        policyRule.withVerbs(['get', 'list', 'watch', 'update']),
      ]
    ),

  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,
  local subject = $.rbac.v1.subject,

  cainjector_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-cainjector') +
    clusterRoleBinding.metadata.withNamespace('kube-system') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */) +
    clusterRoleBinding.roleRef.withName('cert-manager-cainjector') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager-cainjector') +
      subject.withNamespace($._config.namespace),
    ]),

  local role = $.rbac.v1.role,

  cainjector_leaderelection_role:
    role.new('cert-manager-cainjector:leaderelection') +
    role.metadata.withNamespace('kube-system') +
    role.metadata.withLabels({}/* TODO: labels */) +
    role.withRules(
      [
        policyRule.withApiGroups('') +
        policyRule.withResources(['configmaps']) +
        policyRule.withVerbs(['get', 'create', 'update', 'patch']),
      ],
    ),

  local roleBinding = $.rbac.v1.roleBinding,

  cainjector_leaderelection_rolebinding:
    roleBinding.new('cert-manager-cainjector:leaderelection') +
    roleBinding.metadata.withNamespace('kube-system') +
    roleBinding.metadata.withLabels({}/* TODO: labels */) +
    roleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    roleBinding.roleRef.withKind('Role') +
    roleBinding.roleRef.withName('cert-manager-cainjector:leaderelection') +
    roleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager-cainjector') +
      subject.withNamespace($._config.namespace),
    ]),

}
