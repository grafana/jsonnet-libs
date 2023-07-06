# ArgoCD Mixin

The ArgoCD mixin is a set of configurable Grafana dashboards and alerts.

The ArgoCD mixin contains the following dashboards:

- ArgoCD

and the following alerts:

- ArgoAppOutOfSync
- ArgoAppSyncFailed
- ArgoAppMissing
- ArgoSyncLatency
- ArgoKubectlPendingOperations

## ArgoCD Dashboard Overview
ArgoCD dashbaord provides details on the overall status of the ArgoCD applications including the health status and sync status. The dashboard includes visualizations for git requests, K8s API activity and overall cluster stats. Th dashbaord also has visualization for individual components of ArgoCD like RepoServer and Server

#TODO screenshots

## Alerts Overview
- ArgoAppOutOfSync: An ArgoCD application has status OutOfSync.
- ArgoAppSyncFailed: Sync Operation has failed for an ArgoCD Application.
- ArgoAppMissing: An ArgoCD application has status missing.
- ArgoSyncLatency: Latency is increasing between Git and ArgoCD
- ArgoKubectlPendingOperations: Sync Operations are delayed

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
