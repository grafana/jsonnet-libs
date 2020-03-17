{
  local service = $.core.v1.service,
  local servicePort = $.core.v1.service.mixin.spec.portsType,

  webhook_service:
    service.new(
      'cert-manager-webhook',
      {
        app: 'webhook',  // TODO:selector
      },
      [
        servicePort.new(port=443, targetPort=10250).withName('https'),
      ],
    ).withType('ClusterIP')
    .withNamespace($._config.namespace)
    + service.mixin.metadata.withLabelsMixin({ app: 'webhook' }),
}
