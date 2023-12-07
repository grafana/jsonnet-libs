# Nginx Mixin

This mixin is a thin veneer over the dashboard designed and published by [Ward Bekker](https://grafana.com/orgs/wardbekker1) in the [Grafana dashboards library](https://grafana.com/grafana/dashboards/12559).

Specifically this mixin adds a configurable `cluster` variable to the dashboard in order to support it's use in one or many kubernetes clusters.

The mixin uses revision 14 of the dashboard currently. Change `DASHBOARD_REV` in the Makefile to fetch a different revision of the dashboard.

The Nginx mixin contains the following dashboard:

- Nginx...

# Nginx overview

...

## Install tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
# or in brew: brew install go-jsonnet
```

For linting and formatting, you would also need `mixtool` and `jsonnetfmt` installed. If you
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
