# Gemini CLI Mixin

The Gemini CLI mixin is a set of configurable Grafana dashboards.

The Gemini CLI mixin contains the following dashboards:

- Gemini CLI Overview

## Gemini CLI Overview Dashboard

The Gemini CLI Overview dashboard provides details on usage and performance analytics for Gemini CLI, powered by OpenTelemetry. The dashboard includes visualizations for session activity, token usage by model and type, API request rates and latency, tool call rates and latency, agent run activity, file operations, and lines of code changed.

## Tools

To use them, you need to have `mixtool` and `jsonnetfmt` installed. If you have a working Go development environment, it's easiest to run the following:

```bash
$ go get github.com/monitoring-mixins/mixtool/cmd/mixtool
$ go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

You can then build a directory `dashboard_out` with the JSON dashboard files for Grafana:

```bash
$ make build
```

For more advanced uses of mixins, see [Prometheus Monitoring Mixins docs](https://github.com/monitoring-mixins/docs).
