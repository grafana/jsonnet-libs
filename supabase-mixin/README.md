# Supabase Mixin

The Supabase mixin is a configurable Grafana dashboard.

The Supabase mixin contains the following dashboard:

- Supabase

## Supabase Dashboard Overview
Supabase dashboard provides details on the overall status of the Supabase project including the database related metrics. The dashboard includes visualizations for requests, overall project stats. The dashboard is sourced from https://github.com/supabase/supabase-grafana

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
