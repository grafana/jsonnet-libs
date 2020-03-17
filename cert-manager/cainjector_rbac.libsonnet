{
  local clusterRole = $.rbac.v1beta1.clusterRole,
  local rules = clusterRole.rulesType,

  cainjector_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-cainjector')
    .withNamespace('kube-system')
    .withLabels({}/* TODO:labels */) +
    clusterRole.withRules(
      [
        rules.withApiGroups('cert-manager.io')
        .withResources(['certificates'])
        .withVerbs(['get', 'list', 'watch']),
        rules.withApiGroups('')
        .withResources(['secrets'])
        .withVerbs(['get', 'list', 'watch']),
        rules.withApiGroups('')
        .withResources(['events'],)
        .withVerbs(['get', 'create', 'update', 'patch']),
        rules.withApiGroups('admissionregistration.k8s.io')
        .withResources(['validatingwebhookconfigurations', 'mutatingwebhookconfigurations'],)
        .withVerbs(['get', 'list', 'watch', 'update']),
        rules.withApiGroups(['apiregistration.k8s.io'])
        .withResources(['apiservices'])
        .withVerbs(['get', 'list', 'watch', 'update']),
        rules.withApiGroups(['apiextensions.k8s.io'])
        .withResources(['customresourcedefinitions'],)
        .withVerbs(['get', 'list', 'watch', 'update'],),
      ]
    ),

  local clusterRoleBinding = $.rbac.v1beta1.clusterRoleBinding,
  local roleRef = clusterRoleBinding.roleRefType,
  local subjects = clusterRoleBinding.subjectsType,

  cainjector_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-cainjector')
    .withNamespace('kube-system')
    .withLabels({}/* TODO: labels */) +
    clusterRoleBinding.mixin.roleRef
    .withName('cert-manager-cainjector')
    .withKind('ClusterRole')
    .withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.withSubjects(
      subjects.withKind('ServiceAccount')
      .withName('cert-manager-cainjector')
      .withNamespace($._config.namespace)
    ),

  local role = $.rbac.v1beta1.role,

  cainjector_leaderelection_role:
    role.new() +
    role.mixin.metadata
    .withName('cert-manager-cainjector:leaderelection')
    .withNamespace('kube-system')
    .withLabels({}/* TODO: labels */) +
    role.withRules(
      [
        role.rulesType.new() +
        role.rulesType
        .withApiGroups('')
        .withResources(['configmaps'],)
        .withVerbs(['get', 'create', 'update', 'patch']),
      ],
    ),

  local roleBinding = $.rbac.v1beta1.roleBinding,

  cainjector_leaderelection_rolebinding:
    roleBinding.new() +
    roleBinding.mixin.metadata
    .withName('cert-manager-cainjector:leaderelection')
    .withNamespace('kube-system')
    .withLabels({}/* TODO: labels */) +
    roleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('Role')
    .withName('cert-manager-cainjector:leaderelection') +
    roleBinding.withSubjects(
      subjects
      .withKind('ServiceAccount')
      .withName('cert-manager-cainjector')
      .withNamespace($._config.namespace)
    ),

}
