{
  local validatingWebhookCfg = $.admissionregistration.v1beta1.validatingWebhookConfiguration,
  local webhookType = validatingWebhookCfg.webhooksType,
  local matchExpressionsType = webhookType.mixin.namespaceSelector.matchExpressionsType,
  local rulesType = webhookType.rulesType,
  local clientConfigType = webhookType.mixin.clientConfigType,
  local serviceType = clientConfigType.mixin.serviceType,

  validating_webhook: validatingWebhookCfg.new() +
                      validatingWebhookCfg.mixin.metadata.withName('cert-manager-webhook') +
                      validatingWebhookCfg.mixin.metadata.withAnnotations(
                        { 'cert-manager.io/inject-ca-from-secret': $._config.namespace + '/cert-manager-webhook-tls' },
                      ) +
                      validatingWebhookCfg.withWebhooks(
                        webhookType.new() +
                        webhookType
                        .withName('webhook.cert-manager.io')
                        .withFailurePolicy('Fail')
                        .withSideEffects('None')
                        .withRules(
                          rulesType.new() +
                          rulesType
                          .withApiGroups(['cert-manager.io', 'acme.cert-manager.io'])
                          .withApiVersions('v1alpha2')
                          .withOperations(['CREATE', 'UPDATE'],)
                          .withResources('*/*')
                        ) +
                        webhookType.mixin.namespaceSelector.withMatchExpressions([
                          matchExpressionsType.new() +
                          matchExpressionsType
                          .withKey('cert-manager.io/disable-validation')
                          .withOperator('NotIn')
                          .withValues('true'),
                          matchExpressionsType.new() +
                          matchExpressionsType
                          .withKey('name')
                          .withOperator('NotIn')
                          .withValues($._config.namespace),
                        ],) +
                        webhookType.mixin.clientConfig.mixinInstance(
                          clientConfigType.new() +
                          clientConfigType.mixin.service
                          .withName('cert-manager-webhook')
                          .withNamespace($._config.namespace)
                          .withPath('/mutate')
                        )
                      ),
}
