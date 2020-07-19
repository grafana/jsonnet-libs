{
  local serviceAccount = $.core.v1.serviceAccount,
  cainjector_serviceaccount:
    serviceAccount.new('cert-manager-cainjector') +
    serviceAccount.metadata.withLabels({}/* TODO: labels */) +
    serviceAccount.metadata.withNamespace($._config.namespace),
}
