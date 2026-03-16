# OpenAI Codex Mixin

The OpenAI Codex mixin is a set of configurable Grafana dashboards.

The OpenAI Codex mixin contains the following dashboards:

- OpenAI Codex Overview

## OpenAI Codex Overview Dashboard

The OpenAI Codex Overview dashboard provides details on usage analytics for OpenAI Codex, powered by OpenTelemetry. The dashboard includes visualizations for API request rates by model and auth mode, request duration (p50/p95/p99), SSE event activity and duration, tool call rates and duration by tool, and WebSocket request and event activity.

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
