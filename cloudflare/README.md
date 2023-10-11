# Cloudflare Mixin
The Cloudflare mixin is a set of configurable Grafana dashboards and alerts.

The Cloudflare mixin contains the following dashboards:

- 

and the following alerts:

- 

## Cloudflare zone overview
TODO

## Cloudflare GeoMap overview
TODO 

## Cloudflare worker overview
TODO

## Alerts overview

- 

Default thresholds can be configured in `config.libsonnet`.
```js
{
  _config+:: {
    
  },
}
```

## Install tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
```

For linting and formatting, you would also need `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

`prometheus_alerts.yaml` needs to be imported into Prometheus.

## Generate dashboards and alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.