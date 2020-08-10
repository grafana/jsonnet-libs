{
  _config+:: {
    name: 'cert-manager',
    namespace: error '$._config.namesapce needs to be configured.',
    default_issuer: null,
    default_issuer_group: 'cert-manager.io',
    issuer_email: error '$._config.issuer_email needs to be configured.',
  },
}
