# traefik-mixin

The Traefik mixin is a set of configurable, reusable, and extensible dashboards based on the metrics exported by Traefik itself. It also creates suitable dashboard descriptions for Grafana. Lastly, some alerts are also included.

To use them, you need to have mixtool and jsonnetfmt installed. If you have a working Go development environment, it's easiest to run the following:

```shell
$ go get github.com/monitoring-mixins/mixtool/cmd/mixtool
$ go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

You can then build the Prometheus rules files and dashboards for Grafana:

```shell
$ make build
```

This will generate:

- Prometheus alerts in `prometheus_rules_out/prometheus_alerts.yaml`
- Prometheus rules in `prometheus_rules_out/prometheus_rules.yaml` (if you have rules defined)
- Grafana dashboards in `dashboards_out/`

## Included Alerts

The following Prometheus alerts are included:

- **TraefikConfigReloadFailuresIncreasing**: Fires if Traefik is failing to reload its config.
- **TraefikTLSCertificatesExpiring**: Fires if Traefik is serving certificates that will expire soon.

For more advanced uses of mixins, see https://github.com/monitoring-mixins/docs.
