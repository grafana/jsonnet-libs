{
  local serviceAccount = $.core.v1.serviceAccount,
  serviceaccount:
    serviceAccount.new('cert-manager') +
    serviceAccount.mixin.metadata.withNamespace($._config.namespace),
}
