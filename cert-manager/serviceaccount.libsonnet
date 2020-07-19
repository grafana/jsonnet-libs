{
  local serviceAccount = $.core.v1.serviceAccount,
  serviceaccount:
    serviceAccount.new('cert-manager') +
    serviceAccount.metadata.withNamespace($._config.namespace),
}
