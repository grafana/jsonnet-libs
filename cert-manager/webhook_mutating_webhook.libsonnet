{
  local mutatingWebhookConfiguration = $.admissionregistration.v1beta1.mutatingWebhookConfiguration,
  local webhookType = mutatingWebhookConfiguration.webhooksType,
  local rules = webhookType.rulesType,
  local clientConfigType = webhookType.mixin.clientConfigType,
  local serviceType = clientConfigType.mixin.serviceType,

  webhook_mutating_webhook:
    mutatingWebhookConfiguration.new() +
    mutatingWebhookConfiguration.mixin.metadata
    .withName('cert-manager-webhook')
    .withLabels({},/* TODO: labels */)
    .withAnnotations({
      'cert-manager.io/inject-ca-from-secret': $._config.namespace + '/cert-manager-webhook-tls',
    },) +
    mutatingWebhookConfiguration.withWebhooks(
      webhookType.new() + webhookType
                          .withName('webhook.cert-manager.io')
                          .withRules(
        rules.new() + rules
                      .withApiGroups(['cert-manager.io', 'acme.cert-manager.io'])
                      .withApiVersions('v1alpha2')
                      .withOperations(['CREATE', 'UPDATE'],)
                      .withResources('*/*')
      )
                          .withFailurePolicy('Fail')
                          .withSideEffects('None') +
      webhookType.mixin.clientConfig.service
      .withName('cert-manager-webhook')
      .withNamespace($._config.namespace)
      .withPath('/mutate')
    ),
}
