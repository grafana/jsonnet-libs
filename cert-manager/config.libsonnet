{
  _images+:: {
    cert_manager: 'quay.io/jetstack/cert-manager-controller:v0.13.0',
    cert_manager_cainjector: 'quay.io/jetstack/cert-manager-cainjector:v0.13.0',
    cert_manager_webhook: 'quay.io/jetstack/cert-manager-webhook:v0.13.0',
  },
  // Empty for now, used to keep the structure consistent.
  _config+:: {
    namespace: error '$._config.namespace needs to be configured.',
    // "letsencrypt-staging" and "letsencrypt-prod" ClusterIssuer is generated automatically.
    default_issuer: null,
    default_issuer_group: 'cert-manager.io',
    issuer_email: error '$._config.issuer_email needs to be configured.',
  },
}
