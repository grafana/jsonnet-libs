# Kubescape Mixin

The Kubescape mixin is a set of configurable Grafana dashboards and alerts.

The Kubescape mixin contains the following dashboards:

- Kubescape

and the following alerts:

- HighRiskScore
- ScannedHighSeverityResource
- ScannedMediumSeverityResource
- LowComplianceScore

## Kubescape Dashboard Overview
Kubescape dashbaord provides details on the overall status of the compliance score of the cluster along with the risk score. It has panels to showcase the ditribution of Kubescape Controls and Panels along with table view for Severity scans,

#TODO screenshots

## Alerts Overview
- HighRiskScore: Cluster has a high risk score according to Kubescape
- ScannedHighSeverityResource: High Severity Resource Detected by Kubescape
- ScannedMediumSeverityResource: Medium Severity Resource Detected by Kubescape
- LowComplianceScore: Low Compliance score for the cluster in one of the framework(AllControls, MITRE, NSA)

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