{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'traefik',
        rules: [
          // TraefikConfigReloadFailuresIncreasing
          {
            alert: 'TraefikConfigReloadFailuresIncreasing',
            expr: |||
              sum by (%(groupLabels)s) (rate(traefik_config_reloads_failure_total{%(filteringSelector)s}[5m])) > 0
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            } + std.get($._config, 'alertLabels', {}),
            annotations: {
              description: 'Traefik is failing to reload its config',
            } + std.get($._config, 'alertAnnotations', {}),
          },
          // TraefikTLSCertificatesExpiring (critical)
          {
            alert: 'TraefikTLSCertificatesExpiring',
            expr: |||
              max by (%(instanceLabels)s, sans) ((last_over_time(traefik_tls_certs_not_after{%(filteringSelector)s}[5m]) - time()) / 86400) < %(traefik_tls_expiry_days_critical)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            } + std.get($._config, 'alertLabels', {}),
            annotations: {
              description: |||
                The minimum number of days until a Traefik-served certificate expires is {{ printf "%%.0f" $value }} days on {{ $labels.sans }} which is below the critical threshold of %(traefik_tls_expiry_days_critical)s.
              ||| % $._config,
            } + std.get($._config, 'alertAnnotations', {}),
          },
          // TraefikTLSCertificatesExpiring (warning)
          {
            alert: 'TraefikTLSCertificatesExpiringSoon',
            expr: |||
              max by (%(instanceLabels)s, sans) ((last_over_time(traefik_tls_certs_not_after{%(filteringSelector)s}[5m]) - time()) / 86400) < %(traefik_tls_expiry_days_warning)s > %(traefik_tls_expiry_days_critical)s
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'warning',
            } + std.get($._config, 'alertLabels', {}),
            annotations: {
              description: |||
                The minimum number of days until a Traefik-served certificate expires is {{ printf "%%.0f" $value }} days on {{ $labels.sans }} which is less than %(traefik_tls_expiry_days_warning)s but greater than %(traefik_tls_expiry_days_critical)s.
              ||| % $._config,
            } + std.get($._config, 'alertAnnotations', {}),
          },
        ],
      },
    ],
  },
}
