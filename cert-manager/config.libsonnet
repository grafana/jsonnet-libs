{
  _config+:: {
    name: 'cert-manager',
    namespace: error '$._config.namespace needs to be configured',
    chartPrefix: 'cert-manager',

    // "letsencrypt-staging" and "letsencrypt-prod" ClusterIssuer is generated automatically.
    default_issuer: null,
    default_issuer_group: 'cert-manager.io',
    issuer_email: error '$._config.issuer_email needs to be configured.',
  },
}
