{
  local deployment = $.apps.v1.deployment,
  local container = $.core.v1.container,
  local containerPort = $.core.v1.containerPort,

  webhook_container::
    container.new('webhook', $._images.cert_manager_webhook) +
    container.withImagePullPolicy('IfNotPresent') +
    container.withArgs([
      '--v=2',  // loglevel
      '--secure-port=10250',  // optionally customizable
      '--tls-cert-file=/certs/tls.crt',
      '--tls-private-key-file=/certs/tls.key',
    ],) +
    container.withEnv([
      $.core.v1.envVar.fromFieldPath('POD_NAMESPACE', 'metadata.namespace'),
    ]) +
    container.withVolumeMounts([
      $.core.v1.Volume.new(name='certs', mountPath='/certs'),
    ]) +
    container.livenessProbe.httpGet.withPath('/livez') +
    container.livenessProbe.httpGet.withPort(6080) +
    container.livenessProbe.httpGet.withScheme('HTTP') +
    container.readinessProbe.httpGet.withPath('/healthz') +
    container.readinessProbe.httpGet.withPort(6080) +
    container.readinessProbe.httpGet.withScheme('HTTP'),


  webhook_deployment:
    deployment.new(name='cert-manager-webhook', replicas=1, containers=[$.webhook_container], podLabels={
      app: 'webhook',
      /* TODO: labels */
    },) +
    deployment.spec.template.spec.withServiceAccountName('cert-manager-webhook') +
    deployment.spec.template.spec.withVolumes([
      $.core.v1.volume.fromSecret(name='certs', secretName='cert-manager-webhook-tls'),
    ],) +
    deployment.metadata.withLabelsMixin({ app: 'webhook' },),

}
