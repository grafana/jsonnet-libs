# opentelemetry-collector-mixin

Prometheus Monitoring Mixin for the OpenTelemetry Collector

This mixin contains a set of Prometheus alert rules and Grafana dashboards
based on the metrics exported by the OpenTelemetry Collector's [internal
telemetry](https://opentelemetry.io/docs/collector/internal-telemetry/).

To use it, you need to have `jsonnet` (any sufficiently modern version should
do, but ideally v0.20+) and `jb` installed.

If you have a working Go development environment, you can run the following to
get started:
```
go install github.com/google/go-jsonnet/cmd/jsonnet@latest
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
```

### Usage

First, install the dependencies by running the following command from the repo
root:
```
$ jb install
```

You can then build the Prometheus alert and recording rules by running:
```
$ make prometheus_alerts.yaml
$ make prometheus_rules.yaml
```

You can also render a JSON dashboard file for Grafana by running the following
command. The results are stored in the `dashboards_out/` directory.
```
$ make dashboards_out
```

### OpenTelemetry Collector configuration

By default, the OpenTelemetry Collector exposes its [internal
telemetry](https://opentelemetry.io/docs/collector/internal-telemetry/) as
prometheus metrics on port 8888.

The following configuration can be used as a starting point for scraping and
sending metrics in a Prometheus-compatible store.

```yaml
extensions:
  basicauth/remote_write:
    client_auth:
      username: "username"
      password: "password"

receivers:
    prometheus:
      config:
        scrape_configs:
          - job_name: 'otel-collector'
            scrape_interval: 15s
            static_configs:
              - targets: ['0.0.0.0:8888']

processors:
  batch:

exporters:
  prometheusremotewrite:
    endpoint: "http://prometheus/api/prom/push"
    auth:
      authenticator: basicauth/remote_write
    resource_to_telemetry_conversion:
      enabled: true # Convert resource attributes to metric labels

service:
  telemetry:
    metrics:
      level: "detailed"
      readers:
        - pull:
            exporter:
              prometheus:
                host: '0.0.0.0'
                port: 8888
  extensions: [basicauth/remote_write]
  pipelines:
    metrics:
      receivers: [prometheus]
      processors: [batch]
      exporters: [prometheusremotewrite]
```

### Other requirements

The Makefile contains commands for formatting, linting and testing the mixin.
For development purposes you may need one or more of the following as well.
```
go install github.com/google/go-jsonnet/cmd/jsonnet-lint@latest
go install github.com/grafana/dashboard-linter@latest
go install github.com/prometheus/prometheus/cmd/promtool@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@main
```

### Contributing

To contribute:

1. Fork the repository
2. Make your changes
3. Run `make all` to verify your changes and test in a Prometheus/Grafana environment. Screenshots are welcome for new panels/dashboards.
4. Submit a pull request

If you want to make some parameter configurable, use `config.libsonnet` as an
entrypoint.

