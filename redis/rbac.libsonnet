local k = import 'ksonnet-util/kausal.libsonnet';

{
  local clusterRole = k.rbac.v1.clusterRole,
  local clusterRoleBinding = k.rbac.v1.clusterRoleBinding,
  local policyRule = k.rbac.v1.policyRule,
  local roleBinding = k.rbac.v1.roleBinding,
  local role = k.rbac.v1.role,
  local serviceAccount = k.core.v1.serviceAccount,

  redis_service_account:
    serviceAccount.new('redis'),

  redis_role:
    role.new('redis-server-role') +
    role.mixin.metadata.withNamespace($._config.namespace) +
    role.withRulesMixin([
      policyRule.withApiGroups('') +
      policyRule.withResources(['pods']) +
      policyRule.withVerbs(['get', 'list', 'patch']),
    ]),

  redis_rolebinding:
    roleBinding.new('redis-rolebinding') +
    roleBinding.mixin.metadata.withNamespace($._config.namespace) +
    roleBinding.mixin.roleRef.withApiGroup('rbac.authorization.k8s.io') +
    roleBinding.mixin.roleRef.withKind('Role') +
    roleBinding.mixin.roleRef.withName('redis-server-role') +
    roleBinding.withSubjectsMixin({
      kind: 'ServiceAccount',
      name: 'redis',
      namespace: $._config.namespace,
    }),

}
