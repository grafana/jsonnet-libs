# Netflow Mixin

The Netflow mixin is a set of configurable Grafana dashboards for visualizing network flows.
It is based on the [OpenTelemetry semantic conventions for networking](https://opentelemetry.io/docs/specs/semconv/registry/attributes/network/).

The Netflow mixin contains the following dashboards:
- Netflow Overview

## Netflow Overview


![First screenshot of the overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/ktranslate-netflow/netflow-overview.png)
![Second screenshot of the overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/ktranslate-netflow/netflow-overview-2.png)


## Install tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
```

For linting and formatting, you would also need and `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

## Generate dashboards

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
