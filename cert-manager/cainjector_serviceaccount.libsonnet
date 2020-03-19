{
  local serviceAccount = $.core.v1.serviceAccount,
  cainjector_serviceaccount:
    serviceAccount.new('cert-manager-cainjector') +
    serviceAccount.mixin.metadata
    .withLabels({}/* TODO: labels */)
    .withNamespace($._config.namespace),
}
