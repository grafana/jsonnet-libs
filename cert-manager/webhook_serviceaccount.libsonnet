{
  local serviceAccount = $.core.v1.serviceAccount,
  webhook_serviceaccount:
    serviceAccount.new('cert-manager-webhook') +
    serviceAccount.metadata.withNamespace($._config.namespace),
}
