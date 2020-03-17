{
  local clusterRole = $.rbac.v1beta1.clusterRole,
  local clusterRoleBinding = $.rbac.v1beta1.clusterRoleBinding,


  local role = $.rbac.v1beta1.role,
  local roleBinding = $.rbac.v1beta1.roleBinding,

  leaderelection_role:
    role.new() +
    role.mixin.metadata
    .withName('cert-manager:leaderelection')
    .withNamespace('kube-system')
    .withLabels({}/* TODO: labels */) +
    role.withRules([
      role.rulesType.new() +
      role.rulesType
      .withApiGroups('')
      .withResources(['configmaps'])
      .withVerbs(['get', 'create', 'update', 'patch'],),
    ],),
  leaderelection_rolebinding:
    roleBinding.new() +
    roleBinding.mixin.metadata
    .withName('cert-manager:leaderelection')
    .withNamespace('kube-system')
    .withLabels({}/* TODO: labels */) +
    roleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('Role')
    .withName('cert-manager:leaderelection') +
    roleBinding.withSubjects([
      roleBinding.subjectsType.new() +
      roleBinding.subjectsType
      .withApiGroup('')
      .withKind('ServiceAccount')
      .withName('cert-manager')
      .withNamespace($._config.namespace),

    ],),

  cert_manager_controller_issuers_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-controller-issuers')
    .withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['issuers', 'issuers/status'])
      .withVerbs(['update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['issuers'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['secrets'])
      .withVerbs(['get', 'list', 'watch', 'create', 'update', 'delete']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['events'])
      .withVerbs(['create', 'patch']),
    ],),

  cert_manager_controller_clusterissuers_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-controller-clusterissuers')
    .withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['clusterissuers', 'clusterissuers/status'])
      .withVerbs(['update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['clusterissuers'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['secrets'])
      .withVerbs(['get', 'list', 'watch', 'create', 'update', 'delete']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['events'])
      .withVerbs(['create', 'patch']),
    ],),
  cert_manager_controller_certificates_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-controller-certificates')
    .withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['certificates', 'certificates/status', 'certificaterequests', 'certificaterequests/status'])
      .withVerbs(['update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['certificates', 'certificaterequests', 'clusterissuers', 'issuers'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['certificates/finalizers', 'certificaterequests/finalizers'])
      .withVerbs(['update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('acme.cert-manager.io')
      .withResources(['orders'])
      .withVerbs(['create', 'delete', 'get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['secrets'])
      .withVerbs(['get', 'list', 'watch', 'create', 'update', 'delete']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['events'])
      .withVerbs(['create', 'patch']),
    ],),
  cert_manager_controller_orders_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-controller-orders')
    .withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('acme.cert-manager.io')
      .withResources(['orders', 'orders/status'])
      .withVerbs(['update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('acme.cert-manager.io')
      .withResources(['orders', 'challenges'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['clusterissuers', 'issuers'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('acme.cert-manager.io')
      .withResources(['challenges'])
      .withVerbs(['create', 'delete']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('acme.cert-manager.io')
      .withResources(['orders/finalizers'])
      .withVerbs(['update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['secrets'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['events'])
      .withVerbs(['create', 'patch']),
    ],),

  cert_manager_controller_challenges_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-controller-challenges')
    .withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('acme.cert-manager.io')
      .withResources(['challenges', 'challenges/status'])
      .withVerbs(['update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('acme.cert-manager.io')
      .withResources(['challenges'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['issuers', 'clusterissuers'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['secrets'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['events'])
      .withVerbs(['create', 'patch']),
      // HTTP01 rules
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['pods', 'services'])
      .withVerbs(['get', 'list', 'watch', 'create', 'delete']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('extensions')
      .withResources(['ingresses'])
      .withVerbs(['get', 'list', 'watch', 'create', 'delete', 'update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups(['acme.cert-manager.io'])
      .withResources(['challenges/finalizers'])
      .withVerbs(['update']),
      // DNS01 rules (duplicated above)
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['secrets'])
      .withVerbs(['get', 'list', 'watch']),

    ],),
  cert_manager_controller_ingress_shim_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-controller-ingress-shim')
    .withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['certificates', 'certificaterequests'])
      .withVerbs(['create', 'update', 'delete']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['certificates', 'certificaterequests', 'issuers', 'clusterissuers'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('extensions')
      .withResources(['ingresses'])
      .withVerbs(['get', 'list', 'watch']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('extensions')
      .withResources(['ingresses/finalizers'])
      .withVerbs(['update']),
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('')
      .withResources(['events'])
      .withVerbs(['create', 'patch']),
    ],),

  cert_manager_controller_issuers_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-controller-issuers')
    .withLabels({}/* TODO: labels */) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-controller-issuers') +
    clusterRoleBinding.withSubjects(
      clusterRoleBinding.subjectsType.new() +
      clusterRoleBinding.subjectsType
      .withKind('ServiceAccount')
      .withName('cert-manager')
      .withNamespace($._config.namespace)
    ),

  cert_manager_controller_clusterissuers_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-controller-clusterissuers')
    .withLabels({}/* TODO: labels */) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-controller-clusterissuers') +
    clusterRoleBinding.withSubjects(
      clusterRoleBinding.subjectsType.new() +
      clusterRoleBinding.subjectsType
      .withKind('ServiceAccount')
      .withName('cert-manager')
      .withNamespace($._config.namespace)
    ),

  cert_manager_controller_certificates_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-controller-certificates')
    .withLabels({}/* TODO: labels */) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-controller-certificates') +
    clusterRoleBinding.withSubjects(
      clusterRoleBinding.subjectsType.new() +
      clusterRoleBinding.subjectsType
      .withKind('ServiceAccount')
      .withName('cert-manager')
      .withNamespace($._config.namespace)
    ),

  cert_manager_controller_orders_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-controller-orders')
    .withLabels({}/* TODO: labels */) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-controller-orders') +
    clusterRoleBinding.withSubjects(
      clusterRoleBinding.subjectsType.new() +
      clusterRoleBinding.subjectsType
      .withKind('ServiceAccount')
      .withName('cert-manager')
      .withNamespace($._config.namespace)
    ),

  cert_manager_controller_challenges_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-controller-challenges')
    .withLabels({}/* TODO: labels */) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-controller-challenges') +
    clusterRoleBinding.withSubjects(
      clusterRoleBinding.subjectsType.new() +
      clusterRoleBinding.subjectsType
      .withKind('ServiceAccount')
      .withName('cert-manager')
      .withNamespace($._config.namespace)
    ),

  cert_manager_controller_ingress_shim_clusterrolebinding:
    clusterRoleBinding.new() +
    clusterRoleBinding.mixin.metadata
    .withName('cert-manager-controller-ingress-shim')
    .withLabels({}/* TODO: labels */) +
    clusterRoleBinding.mixin.roleRef
    .withApiGroup('rbac.authorization.k8s.io')
    .withKind('ClusterRole')
    .withName('cert-manager-controller-ingress-shim') +
    clusterRoleBinding.withSubjects(
      clusterRoleBinding.subjectsType.new() +
      clusterRoleBinding.subjectsType
      .withKind('ServiceAccount')
      .withName('cert-manager')
      .withNamespace($._config.namespace)
    ),

  cert_manager_view_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-view')
    .withLabels({
      'rbac.authorization.k8s.io/aggregate-to-view': 'true',
      'rbac.authorization.k8s.io/aggregate-to-edit': 'true',
      'rbac.authorization.k8s.io/aggregate-to-admin': 'true',
    })
    .withLabelsMixin({}/* TODO labels */) +
    clusterRole.withRules([
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['certificates', 'certificaterequests', 'issuers'])
      .withVerbs(['get', 'list', 'watch']),
    ],),

  cert_manager_edit_clusterrole:
    clusterRole.new() +
    clusterRole.mixin.metadata
    .withName('cert-manager-edit')
    .withLabels({
      'rbac.authorization.k8s.io/aggregate-to-edit': 'true',
      'rbac.authorization.k8s.io/aggregate-to-admin': 'true',
    })
    .withLabelsMixin({}/* TODO labels */) +
    clusterRole.withRules([
      clusterRole.rulesType.new() +
      clusterRole.rulesType
      .withApiGroups('cert-manager.io')
      .withResources(['certificates', 'certificaterequests', 'issuers'])
      .withVerbs(['create', 'delete', 'deletecollection', 'patch', 'update']),
    ],),

}
