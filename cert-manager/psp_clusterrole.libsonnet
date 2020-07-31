{
  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  psp_clusterrole:
    clusterRole.new('cert-manager-psp') +
    clusterRole.metadata.withLabels({},/* TODO: labels */) +
    clusterRole.withRules([
      policyRule.withApiGroups('policy') +
      policyRule.withResources(['podsecuritypolicies']) +
      policyRule.withVerbs(['use']) +
      policyRule.withResourceNames(['cert-manager']),
    ]),
}
