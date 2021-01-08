{
  _config+:: {
    name: 'cert-manager',
    namespace: error '$._config.namespace needs to be configured.',
    version: 'v1.1.0',
    custom_crds: false,  // newer cert-manager charts can install CRDs
    default_issuer: null,
    default_issuer_group: 'cert-manager.io',
    issuer_email: error '$._config.issuer_email needs to be configured.',
  },
}
