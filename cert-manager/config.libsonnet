{
  _config+:: {
    name: 'cert-manager',
    namespace: error '$._config.namesapce needs to be configured.',
    version: 'v0.13.0',
    custom_crds: true,  // newer cert-manager charts can install CRDs
    default_issuer: null,
    default_issuer_group: 'cert-manager.io',
    issuer_email: error '$._config.issuer_email needs to be configured.',
  },
}
