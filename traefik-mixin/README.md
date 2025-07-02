# traefik-mixin

The Traefik mixin is a set of configurable, reusable, and extensible dashboards based on the metrics exported by Traefik itself. It also creates suitable dashboard descriptions for Grafana. Lastly, some alerts are also included.

To use them, you need to have mixtool and jsonnetfmt installed. If you have a working Go development environment, it's easiest to run the following:

```shell
go get github.com/monitoring-mixins/mixtool/cmd/mixtool
go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

You can then build the Prometheus rules files and dashboards for Grafana:

```shell
make build
```

This will generate:

- Prometheus alerts in `prometheus_rules_out/prometheus_alerts.yaml`
- Prometheus rules in `prometheus_rules_out/prometheus_rules.yaml` (if you have rules defined)
- Grafana dashboards in `dashboards_out/`

## Included Alerts

The following Prometheus alerts are included:

- **TraefikConfigReloadFailuresIncreasing**: Fires if Traefik is failing to reload its config.
- **TraefikTLSCertificatesExpiring**: Fires if Traefik is serving certificates that will expire very soon (critical, threshold configurable).
- **TraefikTLSCertificatesExpiringSoon**: Fires if Traefik is serving certificates that will expire soon (warning, threshold configurable, only fires if the expiry is less than the warning threshold but greater than the critical threshold).

## Configuration

You can configure alert thresholds, selectors, and labels in `config.libsonnet`:

```jsonnet
{
  _config+:: {
    traefik_tls_expiry_days_critical: 7,   // critical threshold (days)
    traefik_tls_expiry_days_warning: 14,   // warning threshold (days)
    filteringSelector: '',                 // optional metric label selector for all alerts
    // Example:
    // filteringSelector: "component=\"traefik\",environment=\"production\"",
    groupLabels: 'job, environment',
    instanceLabels: 'instance',

    alertLabels: {},                       // optional alert labels
    // Example:
    // alertLabels: {
    //   environment: 'production',
    //   component: 'traefik',
    // },
    alertAnnotations: {},                  // optional alert annotations
    // Example:
    // alertAnnotations: {
    //   runbook: 'https://runbooks.example.com/traefik-tls',
    //   grafana: 'https://grafana.example.com/d/traefik',
    // },
  },
}
```

For more advanced uses of mixins, see [monitoring-mixins/docs](https://github.com/monitoring-mixins/docs).
