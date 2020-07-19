{
  local clusterRole = $.rbac.v1.clusterRole,
  local clusterRoleBinding = $.rbac.v1.clusterRoleBinding,

  local role = $.rbac.v1.role,
  local roleBinding = $.rbac.v1.roleBinding,

  local policyRule = $.rbac.v1.policyRule,
  local subject = $.rbac.v1.subject,

  leaderelection_role:
    role.new('cert-manager:leaderelection') +
    role.metadata.withNamespace('kube-system') +
    role.metadata.withLabels({}/* TODO: labels */) +
    role.withRules([
      policyRule.withApiGroups('') +
      policyRule.withResources(['configmaps']) +
      policyRule.withVerbs(['get', 'create', 'update', 'patch']),
    ]),
  leaderelection_rolebinding:
    roleBinding.new('cert-manager:leaderelection') +
    roleBinding.metadata.withNamespace('kube-system') +
    roleBinding.metadata.withLabels({}/* TODO: labels */) +
    roleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    roleBinding.roleRef.withKind('Role') +
    roleBinding.roleRef.withName('cert-manager:leaderelection') +
    roleBinding.withSubjects([
      subject.withApiGroup('') +
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager') +
      subject.withNamespace($._config.namespace),
    ]),

  cert_manager_controller_issuers_clusterrole:
    clusterRole.new('cert-manager-controller-issuers') +
    clusterRole.metadata.withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['issuers', 'issuers/status']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['issuers']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['secrets']) +
      policyRule.withVerbs(['get', 'list', 'watch', 'create', 'update', 'delete']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['events']) +
      policyRule.withVerbs(['create', 'patch']),
    ]),

  cert_manager_controller_clusterissuers_clusterrole:
    clusterRole.new('cert-manager-controller-clusterissuers') +
    clusterRole.metadata.withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['clusterissuers', 'clusterissuers/status']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['clusterissuers']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['secrets']) +
      policyRule.withVerbs(['get', 'list', 'watch', 'create', 'update', 'delete']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['events']) +
      policyRule.withVerbs(['create', 'patch']),
    ]),
  cert_manager_controller_certificates_clusterrole:
    clusterRole.new('cert-manager-controller-certificates') +
    clusterRole.metadata.withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['certificates', 'certificates/status', 'certificaterequests', 'certificaterequests/status']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['certificates', 'certificaterequests', 'clusterissuers', 'issuers']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['certificates/finalizers', 'certificaterequests/finalizers']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups('acme.cert-manager.io') +
      policyRule.withResources(['orders']) +
      policyRule.withVerbs(['create', 'delete', 'get', 'list', 'watch']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['secrets']) +
      policyRule.withVerbs(['get', 'list', 'watch', 'create', 'update', 'delete']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['events']) +
      policyRule.withVerbs(['create', 'patch']),
    ]),
  cert_manager_controller_orders_clusterrole:
    clusterRole.new('cert-manager-controller-orders') +
    clusterRole.metadata.withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      policyRule.withApiGroups('acme.cert-manager.io') +
      policyRule.withResources(['orders', 'orders/status']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups('acme.cert-manager.io') +
      policyRule.withResources(['orders', 'challenges']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['clusterissuers', 'issuers']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('acme.cert-manager.io') +
      policyRule.withResources(['challenges']) +
      policyRule.withVerbs(['create', 'delete']),
      policyRule.withApiGroups('acme.cert-manager.io') +
      policyRule.withResources(['orders/finalizers']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['secrets']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['events']) +
      policyRule.withVerbs(['create', 'patch']),
    ]),

  cert_manager_controller_challenges_clusterrole:
    clusterRole.new('cert-manager-controller-challenges') +
    clusterRole.metadata.withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      policyRule.withApiGroups('acme.cert-manager.io') +
      policyRule.withResources(['challenges', 'challenges/status']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups('acme.cert-manager.io') +
      policyRule.withResources(['challenges']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['issuers', 'clusterissuers']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['secrets']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['events']) +
      policyRule.withVerbs(['create', 'patch']),
      // HTTP01 rules
      policyRule.withApiGroups('') +
      policyRule.withResources(['pods', 'services']) +
      policyRule.withVerbs(['get', 'list', 'watch', 'create', 'delete']),
      policyRule.withApiGroups('extensions') +
      policyRule.withResources(['ingresses']) +
      policyRule.withVerbs(['get', 'list', 'watch', 'create', 'delete', 'update']),
      policyRule.withApiGroups(['acme.cert-manager.io']) +
      policyRule.withResources(['challenges/finalizers']) +
      policyRule.withVerbs(['update']),
      // DNS01 rules (duplicated above)+
      policyRule.withApiGroups('') +
      policyRule.withResources(['secrets']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
    ]),
  cert_manager_controller_ingress_shim_clusterrole:
    clusterRole.new('cert-manager-controller-ingress-shim') +
    clusterRole.metadata.withLabels({}/* TODO namespace */) +
    clusterRole.withRules([
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['certificates', 'certificaterequests']) +
      policyRule.withVerbs(['create', 'update', 'delete']),
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['certificates', 'certificaterequests', 'issuers', 'clusterissuers']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('extensions') +
      policyRule.withResources(['ingresses']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
      policyRule.withApiGroups('extensions') +
      policyRule.withResources(['ingresses/finalizers']) +
      policyRule.withVerbs(['update']),
      policyRule.withApiGroups('') +
      policyRule.withResources(['events']) +
      policyRule.withVerbs(['create', 'patch']),
    ]),

  cert_manager_controller_issuers_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-controller-issuers') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName('cert-manager-controller-issuers') +
    clusterRoleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager') +
      subject.withNamespace($._config.namespace),
    ]),

  cert_manager_controller_clusterissuers_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-controller-clusterissuers') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName('cert-manager-controller-clusterissuers') +
    clusterRoleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager') +
      subject.withNamespace($._config.namespace),
    ]),

  cert_manager_controller_certificates_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-controller-certificates') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName('cert-manager-controller-certificates') +
    clusterRoleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager') +
      subject.withNamespace($._config.namespace),
    ]),

  cert_manager_controller_orders_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-controller-orders') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName('cert-manager-controller-orders') +
    clusterRoleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager') +
      subject.withNamespace($._config.namespace),
    ]),

  cert_manager_controller_challenges_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-controller-challenges') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName('cert-manager-controller-challenges') +
    clusterRoleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager') +
      subject.withNamespace($._config.namespace),
    ]),

  cert_manager_controller_ingress_shim_clusterrolebinding:
    clusterRoleBinding.new('cert-manager-controller-ingress-shim') +
    clusterRoleBinding.metadata.withLabels({}/* TODO: labels */) +
    clusterRoleBinding.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    clusterRoleBinding.roleRef.withKind('ClusterRole') +
    clusterRoleBinding.roleRef.withName('cert-manager-controller-ingress-shim') +
    clusterRoleBinding.withSubjects([
      subject.withKind('ServiceAccount') +
      subject.withName('cert-manager') +
      subject.withNamespace($._config.namespace),
    ]),

  cert_manager_view_clusterrole:
    clusterRole.new('cert-manager-view') +
    clusterRole.metadata.withLabels({
      'rbac.authorization.k8s.io/aggregate-to-view': 'true',
      'rbac.authorization.k8s.io/aggregate-to-edit': 'true',
      'rbac.authorization.k8s.io/aggregate-to-admin': 'true',
    }) +
    clusterRole.metadata.withLabelsMixin({}/* TODO labels */) +
    clusterRole.withRules([
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['certificates', 'certificaterequests', 'issuers']) +
      policyRule.withVerbs(['get', 'list', 'watch']),
    ]),

  cert_manager_edit_clusterrole:
    clusterRole.new('cert-manager-edit') +
    clusterRole.metadata.withLabels({
      'rbac.authorization.k8s.io/aggregate-to-edit': 'true',
      'rbac.authorization.k8s.io/aggregate-to-admin': 'true',
    }) +
    clusterRole.metadata.withLabelsMixin({}/* TODO labels */) +
    clusterRole.withRules([
      policyRule.withApiGroups('cert-manager.io') +
      policyRule.withResources(['certificates', 'certificaterequests', 'issuers']) +
      policyRule.withVerbs(['create', 'delete', 'deletecollection', 'patch', 'update']),
    ]),

}
