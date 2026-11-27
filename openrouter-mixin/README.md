# OpenRouter mixin

The OpenRouter mixin is a Grafana dashboard for monitoring OpenRouter requests, latency, errors, token usage, and costs with OpenTelemetry data. It includes views by model and provider, along with trace-level details for individual requests.

## Tools

To use this mixin, you need to have `mixtool` and `jsonnetfmt` installed. If you have a working Go development environment, it's easiest to run the following:

```bash
$ go get github.com/monitoring-mixins/mixtool/cmd/mixtool
$ go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

You can then build a directory `dashboard_out` with the JSON dashboard files for Grafana:

```bash
$ make build
```

For more advanced uses of mixins, see [Prometheus Monitoring Mixins docs](https://github.com/monitoring-mixins/docs).
