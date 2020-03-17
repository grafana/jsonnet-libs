{
  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,
  local roleRef = clusterRoleBinding.roleRefType,
  local subjects = clusterRoleBinding.subjectsType,
  local clusterRole = $.rbac.v1.clusterRole,
  local rules = clusterRole.rulesType,

  webhook_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-webhook:auth-delegator')
    .withLabels({}/* TODO: labels */) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('system:auth-delegator') +
    clusterRoleBinding.withSubjects(
      subjects.new() +
      subjects
      .withApiGroup('')
      .withKind('ServiceAccount')
      .withName('cert-manager-webhook')
      .withNamespace($._config.namespace)
    ),

  local roleBinding = $.rbac.v1beta1.roleBinding,

  webhook_rolebinding:
    roleBinding.new() +
    roleBinding.mixin.metadata
    .withName('cert-manager-webhook:webhook-authentication-reader')
    .withNamespace('kube-system')
    .withLabels({}/* TODO: labels */) +
    roleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('Role')
    .withName('extension-apiserver-authentication-reader') +
    roleBinding.withSubjects(
      subjects.new() +
      subjects
      .withApiGroup('')
      .withKind('ServiceAccount')
      .withName('cert-manager-webhook')
      .withNamespace($._config.namespace)
    ),

  webhook_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-webhook:webhook-requester')
    .withLabels({}/* TODO: labels */) +
    clusterRole.withRules(
      rules.new() +
      rules
      .withApiGroups('admission.cert-manager.io')
      .withResources(['certificates', 'certificaterequests', 'issuers', 'clusterissuers'])
      .withVerbs(['create'])
    ),

}
