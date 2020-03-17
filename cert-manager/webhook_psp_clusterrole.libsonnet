{
  local clusterRole = $.rbac.v1.clusterRole,
  local rules = clusterRole.rulesType,

  webhook_psp_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-webhook-psp')
    .withLabels({},/* TODO: labels */) +
    clusterRole.withRules(
      rules.new() +
      rules
      .withApiGroups('policy')
      .withResourceNames(['cert-manager-webhook'])
      .withResources(['podsecuritypolicies'])
      .withVerbs(['use'])
    ),
}
