{
  local clusterRole = $.rbac.v1.clusterRole,
  local rules = clusterRole.rulesType,

  cainjector_psp_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-cainjector-psp')
    .withLabels({},/* TODO: labels */) +
    clusterRole.withRules(
      rules.new() +
      rules
      .withApiGroups('policy')
      .withResources(['podsecuritypolicies'])
      .withVerbs(['use'])
      .withResourceNames(['cert-manager-cainjector'])
    ),
}
