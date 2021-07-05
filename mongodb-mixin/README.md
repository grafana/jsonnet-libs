# MongoDB Mixin

The MongoDB Mixin is a set of configurable, reusable, and extensible alerts and dashboards based on the metrics exported by [Percona MongoDB Exporter](https://github.com/percona/mongodb_exporter).

The dashboards were based on those made available Percona is [this repository](https://github.com/percona/grafana-dashboards/tree/PMM-2.0/dashboards). This mixin includes 5 of the dashboards suited for MongoDB, namely MongoDB_Cluster_Summary, MongoDB_Instances_Compare, MongoDB_Instances_Overview, MongoDB_Instance_Summary and MongoDB_ReplSet_Summary.

The alerts were based on those published at [https://awesome-prometheus-alerts.grep.to/rules.html#mongodb](https://awesome-prometheus-alerts.grep.to/rules.html#mongodb).

To use them, you need to have `mixtool` and `jsonnetfmt` installed. If you have a working Go development environment, it's easiest to run the following:

```bash
$ go get github.com/monitoring-mixins/mixtool/cmd/mixtool
$ go get github.com/google/go-jsonnet/cmd/jsonnetfmt
```

You can then build the Prometheus rules file `alerts.yaml` and a directory `dashboard_out` with the JSON dashboard files for Grafana:

```bash
$ make build
```

For more advanced uses of mixins, see [Prometheus Monitoring Mixins docs](https://github.com/monitoring-mixins/docs).
