{
  local validatingWebhookCfg = $.admissionregistration.v1beta1.validatingWebhookConfiguration,
  local webhook = $.admissionregistration.v1beta1.webhook,
  local rule = $.admissionregistration.v1beta1.ruleWithOperations,

  validating_webhook:
    validatingWebhookCfg.new('cert-manager-webhook') +
    validatingWebhookCfg.metadata.withAnnotations(
      { 'cert-manager.io/inject-ca-from-secret': $._config.namespace + '/cert-manager-webhook-tls' },
    ) +
    validatingWebhookCfg.withWebhooks(
      webhook.withName('webhook.cert-manager.io') +
      webhook.withFailurePolicy('Fail') +
      webhook.withSideEffects('None') +
      webhook.withRules(
        rule.withApiGroups(['cert-manager.io', 'acme.cert-manager.io']) +
        rule.withApiVersions('v1alpha2') +
        rule.withOperations(['CREATE', 'UPDATE'],) +
        rule.withResources('*/*')
      ) +
      webhook.namespaceSelector.withMatchExpressions([
        {
          key: 'cert-manager.io/disable-validation',
          operator: 'NotIn',
          values: ['true'],
        },
        {
          key: 'name',
          operator: 'NotIn',
          values: [$._config.namespace],
        },
      ]) +
      webhook.clientConfig.service.withName('cert-manager-webhook') +
      webhook.clientConfig.service.withNamespace($._config.namespace) +
      webhook.clientConfig.service.withPath('/mutate')
    ),
}
