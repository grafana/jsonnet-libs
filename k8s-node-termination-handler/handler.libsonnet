{
  new(config):: {
    local k = import 'ksonnet-util/kausal.libsonnet',

    local _config = {
      namespace: 'kube-system',
      slack_webhook: '',
    } + config,


    _images+:: {
      node_termination_handler: 'k8s.gcr.io/gke-node-termination-handler@sha256:aca12d17b222dfed755e28a44d92721e477915fb73211d0a0f8925a1fa847cca',
    },


    local container = k.core.v1.container,
    container::
      container.new('node-termination-handler', self._images.node_termination_handler) +
      container.withCommand(['./node-termination-handler']) +
      container.withArgsMixin([
        '--logtostderr',
        '--exclude-pods=$(POD_NAME):$(POD_NAMESPACE)',
        '-v=10',
        '--taint=cloud.google.com/impending-node-termination::NoSchedule',
      ]) +
      container.withEnv([
        container.envType.fromFieldPath('POD_NAME', 'metadata.name'),
        container.envType.fromFieldPath('POD_NAMESPACE', 'metadata.namespace'),
        container.envType.new('SLACK_WEBHOOK_URL', _config.slack_webhook),
      ]) +
      container.mixin.securityContext.capabilities.withAdd(['SYS_BOOT']) +
      k.util.resourcesLimits('150m', '30Mi'),

    local daemonSet = k.apps.v1.daemonSet,
    local tolerations = daemonSet.mixin.spec.template.spec.tolerationsType,
    local nodeAffinity = daemonSet.mixin.spec.template.spec.affinity.nodeAffinity,
    local nodeSelector = nodeAffinity.requiredDuringSchedulingIgnoredDuringExecutionType,
    daemonset:
      daemonSet.new('node-termination-handler', [self.container]) +
      daemonSet.mixin.spec.template.spec.affinity.nodeAffinity.requiredDuringSchedulingIgnoredDuringExecution.mixinInstance(
        nodeSelector.withNodeSelectorTerms([
          nodeSelector.nodeSelectorTermsType.new() +
          nodeSelector.nodeSelectorTermsType.withMatchExpressions([
            nodeSelector.nodeSelectorTermsType.matchFieldsType
            .withKey('cloud.google.com/gke-accelerator')
            .withOperator('Exists'),
            nodeSelector.nodeSelectorTermsType.matchFieldsType
            .withKey('cloud.google.com/gke-preemptible')
            .withOperator('Exists'),
          ]),
        ])
      ) +
      daemonSet.mixin.metadata.withNamespace(_config.namespace) +
      daemonSet.mixin.spec.template.spec.withHostPid(true) +
      daemonSet.mixin.spec.template.spec.withTolerations([
        tolerations.new() +
        tolerations
        .withOperator('Exists')
        .withEffect('NoSchedule'),
        tolerations.new() +
        tolerations
        .withOperator('Exists')
        .withEffect('NoExecute'),
      ]),

    local serviceAccount = k.core.v1.serviceAccount,
    service_account:
      serviceAccount.new('node-termination-handler') +
      serviceAccount.mixin.metadata.withNamespace(_config.namespace),

    local clusterRole = k.rbac.v1.clusterRole,
    local clusterRoleRule = k.rbac.v1.clusterRole.rulesType,
    cluster_role:
      clusterRole.new() +
      clusterRole.mixin.metadata.withName('node-termination-handler-role') +
      clusterRole.withRulesMixin([
        clusterRoleRule.new() +
        clusterRoleRule.withApiGroups('') +
        clusterRoleRule.withResources(['nodes']) +
        clusterRoleRule.withVerbs(['get', 'update']),
        clusterRoleRule.new() +
        clusterRoleRule.withApiGroups('') +
        clusterRoleRule.withResources(['events']) +
        clusterRoleRule.withVerbs(['create']),
        clusterRoleRule.new() +
        clusterRoleRule.withApiGroups('') +
        clusterRoleRule.withResources(['pods']) +
        clusterRoleRule.withVerbs(['get', 'list', 'delete']),
      ]),

    local clusterRoleBinding = k.rbac.v1.clusterRoleBinding,
    cluster_role_binding:
      clusterRoleBinding.new() +
      clusterRoleBinding.mixin.metadata.withName('node-termination-handler-role-binding') +
      clusterRoleBinding.mixin.roleRef.withApiGroup('rbac.authorization.k8s.io') +
      clusterRoleBinding.mixin.roleRef.withKind('ClusterRole') +
      clusterRoleBinding.mixin.roleRef.withName('node-termination-handler-role') +
      clusterRoleBinding.withSubjectsMixin({
        kind: 'ServiceAccount',
        name: 'node-termination-handler',
        namespace: _config.namespace,
      }),
  },
}
