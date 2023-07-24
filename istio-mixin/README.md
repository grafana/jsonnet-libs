# Istio Mixin

The [Istio](https://istio.io/) mixin is a set of configurable Grafana dashboards and alerts.

The Istio mixin contains the following dashboards:

- Istio

and the following alerts:

- IstioComponentDown
- IstioHighGlobalRequestRate
- IstioGlobalRequestRateLow
- IstioHigh5xxResponseRatio
- IstioHigh4xxResponseRatio
- IstioPilotDuplicateEntry

The Istio Mixin is a collection of Grafana dashboards for operating an [Istio](https://istio.io/) service mesh.

The dashboards are heavily inspired from [official ones maintained](https://istio.io/latest/docs/tasks/observability/metrics/using-istio-dashboard/) by the Istio community. In addition, [alerting rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/) to operate Istio in production.


## Istio Dashboard Overview
Istio dashbaord provides details on the overall status of the Istio Service Mesh including the overall requests taking place in your environment. The dashboard includes visualizations for Istio Requests and response table, Pilot activity and overall cluster stats.

## Alerts Overview
- IstioComponentDown: An Istio Component is down.
- IstioHighGlobalRequestRate: Istio Global Request Rate is High.
- IstioGlobalRequestRateLow: Istio Global Request Rate is Low.
- IstioHigh5xxResponseRatio: High Percentage of 5xx reponses in Istio.
- IstioHigh4xxResponseRatio: High Percentage of 4xx reponses in Istio.
- IstioPilotDuplicateEntry: Istio Pilot Duplicate Entry.

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
