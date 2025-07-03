{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'traefik',
        rules: [
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
              summary: 'Traefik is failing to reload its configuration.',
              description: |||
                Traefik is failing to reload its config in {{ $labels.%(firstGroupLabel)s }}.
              ||| % { firstGroupLabel: std.split($._config.groupLabels, ',')[0] },
            } + std.get($._config, 'alertAnnotations', {}),
          },
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
              summary: 'A Traefik-served TLS certificate will expire very soon.',
              description: |||
                The minimum number of days until a Traefik-served certificate expires is {{ printf "%%.0f" $value }} days on {{ $labels.sans }} which is below the critical threshold of %(traefik_tls_expiry_days_critical)s.
              ||| % $._config,
            } + std.get($._config, 'alertAnnotations', {}),
          },
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
              summary: 'A Traefik-served TLS certificate will expire soon.',
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
