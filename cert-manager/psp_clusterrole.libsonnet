{
  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  psp_clusterrole:
    clusterRole.new('cert-manager-psp') +
    clusterRule.metadata.withLabels({},/* TODO: labels */) +
    clusterRole.withRules([
      polictyRule.withApiGroups('policy') +
      polictyRule.withResources(['podsecuritypolicies']) +
      polictyRule.withVerbs(['use']) +
      polictyRule.withResourceNames(['cert-manager']),
    ]),
}
