{
  local clusterRole = $.rbac.v1.clusterRole,
  local policyRule = $.rbac.v1.policyRule,

  webhook_psp_clusterrole:
    clusterRole.new('cert-manager-webhook-psp') +
    clusterRole.metadat.withLabels({},/* TODO: labels */) +
    clusterRole.withRules([
      policyRule.withApiGroups('policy') +
      policyRule.withResourceNames(['cert-manager-webhook']) +
      policyRule.withResources(['podsecuritypolicies']) +
      policyRule.withVerbs(['use']),
    ]),
}
