{
  local mutatingWebhookConfiguration = $.admissionregistration.v1beta1.mutatingWebhookConfiguration,
  local webhook = $.admissionregistration.v1beta1.webhook,
  local rule = $.admissionregistration.v1beta1.ruleWithOperations,

  webhook_mutating_webhook:
    mutatingWebhookConfiguration.new('cert-manager-webhook') +
    mutatingWebhookConfiguration.metadata.withLabels({},/* TODO: labels */) +
    mutatingWebhookConfiguration.metadata.withAnnotations({
      'cert-manager.io/inject-ca-from-secret': $._config.namespace + '/cert-manager-webhook-tls',
    },) +
    mutatingWebhookConfiguration.withWebhooks(
      webhook.withName('webhook.cert-manager.io') +
      webhook.withRules([
        rule.withApiGroups(['cert-manager.io', 'acme.cert-manager.io']) +
        rule.withApiVersions('v1alpha2') +
        rule.withOperations(['CREATE', 'UPDATE'],) +
        rule.withResources('*/*'),
      ]) +
      webhook.withFailurePolicy('Fail') +
      webhook.withSideEffects('None') +
      webhook.clientConfig.service.withName('cert-manager-webhook') +
      webhook.clientConfig.service.withNamespace($._config.namespace) +
      webhook.clientConfig.service.withPath('/mutate')
    ),
}
