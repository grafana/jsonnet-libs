{
  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,
  local subject = $.rbac.v1.subject,
  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  webhook_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-webhook:auth-delegator') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName('system:auth-delegator') +
    clusterRoleBinding.withSubjects([
      subject.withApiGroup('') +
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager-webhook') +
      subject.withNamespace($._config.namespace),
    ]),

  local roleBinding = $.rbac.v1.roleBinding,

  webhook_rolebinding:
    roleBinding.new('cert-manager-webhook:webhook-authentication-reader') +
    roleBinding.metadata.withNamespace('kube-system') +
    roleBinding.metadata.withLabels({}/* TODO: labels */) +
    roleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    roleBinding.roleRef.withKind('Role') +
    roleBinding.roleRef.withName('extension-apiserver-authentication-reader') +
    roleBinding.withSubjects([
      subject.withApiGroup('') +
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager-webhook') +
      subject.withNamespace($._config.namespace),
    ]),

  webhook_clusterrole:
    clusterRole.new('cert-manager-webhook:webhook-requester') +
    clusterRole.metadata.withLabels({}/* TODO: labels */) +
    clusterRole.withRules([
      policyRule.withApiGroups('admission.cert-manager.io') +
      policyRule.withResources(['certificates', 'certificaterequests', 'issuers', 'clusterissuers']) +
      policyRule.withVerbs(['create']),
    ]),

}
