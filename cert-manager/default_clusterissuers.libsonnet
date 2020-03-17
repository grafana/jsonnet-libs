{
  cluster_issuer_staging: {
    apiVersion: 'cert-manager.io/v1alpha2',
    kind: 'ClusterIssuer',
    metadata: {
      name: 'letsencrypt-staging',
    },
    spec: {
      acme: {
        // You must replace this email address with your own.
        // Let's Encrypt will use this to contact you about expiring
        // certificates, and issues related to your account.
        email: $._config.issuer_email,
        server: 'https://acme-staging-v02.api.letsencrypt.org/directory',
        privateKeySecretRef: {
          // Secret resource used to store the account's private key.
          name: 'letsencrypt-staging-account',
        },
        // Add a single challenge solver, HTTP01 using nginx
        solvers: [
          {
            http01: {
              ingress: {
                class: 'nginx',
              },
            },
          },
        ],
      },
    },
  },

  cluster_issuer_prod: {
    apiVersion: 'cert-manager.io/v1alpha2',
    kind: 'ClusterIssuer',
    metadata: {
      name: 'letsencrypt-prod',
    },
    spec: {
      acme: {
        // You must replace this email address with your own.
        // Let's Encrypt will use this to contact you about expiring
        // certificates, and issues related to your account.
        email: $._config.issuer_email,
        server: 'https://acme-v02.api.letsencrypt.org/directory',
        privateKeySecretRef: {
          // Secret resource used to store the account's private key.
          name: 'letsencrypt-prod-account',
        },
        // Add a single challenge solver, HTTP01 using nginx
        solvers: [
          {
            http01: {
              ingress: {
                class: 'nginx',
              },
            },
          },
        ],
      },
    },
  },
}
