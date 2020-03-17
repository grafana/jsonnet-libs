{
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,

  webhook_container::
    container.new('webhook', $._images.cert_manager_webhook)
    .withImagePullPolicy('IfNotPresent')
    .withArgs([
      '--v=2',  // loglevel
      '--secure-port=10250',  // optionally customizable
      '--tls-cert-file=/certs/tls.crt',
      '--tls-private-key-file=/certs/tls.key',
    ],)
    .withEnv([
      container.envType.fromFieldPath('POD_NAMESPACE', 'metadata.namespace'),
    ])
    .withVolumeMounts([
      container.volumeMountsType.new(name='certs', mountPath='/certs'),
    ]) +
    container.mixin.livenessProbe.httpGet
    .withPath('/livez')
    .withPort(6080)
    .withScheme('HTTP') +
    container.mixin.readinessProbe.httpGet
    .withPath('/healthz')
    .withPort(6080)
    .withScheme('HTTP'),


  webhook_deployment:
    deployment.new(name='cert-manager-webhook', replicas=1, containers=[$.webhook_container], podLabels={
      app: 'webhook',
      /* TODO: labels */
    },) +
    deployment.mixin.spec.template.spec
    .withServiceAccountName('cert-manager-webhook') +
    deployment.mixin.spec.template.spec.withVolumes([
      deployment.mixin.spec.template.spec.volumesType.fromSecret(name='certs', secretName='cert-manager-webhook-tls'),
    ],) +
    deployment.mixin.metadata.withLabelsMixin({ app: 'webhook' },),

}
