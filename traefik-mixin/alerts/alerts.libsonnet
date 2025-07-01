{
  groups+: [
    {
      name: 'traefik',
      rules: [
        // TraefikConfigReloadFailuresIncreasing
        {
          alert: 'TraefikConfigReloadFailuresIncreasing',
          expr: "sum(rate(traefik_config_reloads_failure_total[5m])) > 0",
          'for': '5m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            description: 'Traefik is failing to reload its config',
          },
        },
        // TraefikTLSCertificatesExpiring
        {
          alert: 'TraefikTLSCertificatesExpiring',
          expr: "max by (sans) ((last_over_time(traefik_tls_certs_not_after[5m]) - time()) / 86400) < 7",
          'for': '5m',
          labels: {
            severity: 'critical',
          },
          annotations: {
            description: 'Traefik is serving certificates that will expire soon',
          },
        },
      ],
    },
  ],
}
