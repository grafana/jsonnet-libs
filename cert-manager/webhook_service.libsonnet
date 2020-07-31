{
  local service = $.core.v1.service,
  local servicePort = $.core.v1.servicePort,

  webhook_service:
    service.new(
      'cert-manager-webhook',
      { app: 'webhook' /* TODO:selector */ },
      [servicePort.newNamed(name='https', port=443, targetPort=10250)]
    ) +
    service.spec.withType('ClusterIP') +
    service.metadata.withNamespace($._config.namespace) +
    service.metadata.withLabelsMixin({ app: 'webhook' }),
}
