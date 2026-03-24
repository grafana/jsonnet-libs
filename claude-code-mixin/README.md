# Claude Code mixin

The Claude Code mixin is a Grafana dashboard for monitoring Claude Code usage and costs, powered by OpenTelemetry. It includes visualizations for token usage, cost breakdown by model and team member, session activity, coding activity (commits, pull requests, edits), and environment details (OS type, architecture, terminal).

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
