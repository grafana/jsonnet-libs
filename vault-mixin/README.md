# Hashicorp Vault mixin

Hashicorp Vault mixin is a single Grafana dashboard using Vault internal metrics.

To collect metrics from vault, please follow https://developer.hashicorp.com/vault/tutorials/monitoring/monitor-telemetry-grafana-prometheus guide.

## Generate config files

You can manually generate dashboards, but first you should install some tools:

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/google/go-jsonnet/cmd/jsonnet@latest
# or in brew: brew install go-jsonnet
```

For linting and formatting, you would also need `mixtool` and `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
