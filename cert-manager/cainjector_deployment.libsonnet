{
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,

  cainjector_container:: container.new('cainjector', $._images.cert_manager_cainjector)
                         .withImagePullPolicy('IfNotPresent')
                         .withArgs([
    '--v=2',  // loglevel
    '--leader-election-namespace=kube-system',  // optionally customizable
  ])
                         .withEnv([
    container.envType.fromFieldPath('POD_NAMESPACE', 'metadata.namespace'),
  ]),

  cainjector_deployment: deployment.new(name='cert-manager-cainjector', replicas=1, containers=[$.cainjector_container], podLabels={
                           /* TODO: labels */
                           app: 'cainjector',
                         },) +
                         deployment.mixin.spec.template.spec
                         .withServiceAccountName('cert-manager-cainjector') +
                         deployment.mixin.metadata.withLabels({ app: 'cainjector' },),
}
