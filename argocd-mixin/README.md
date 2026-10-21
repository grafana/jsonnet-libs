# ArgoCD Mixin

The ArgoCD mixin is a set of configurable Grafana dashboards and alerts.

The ArgoCD mixin contains the following dashboards:

- ArgoCD

and the following alerts:

- ArgoAppOutOfSync
- ArgoAppSyncFailed
- ArgoAppMissing

## ArgoCD Dashboard Overview
ArgoCD dashbaord provides details on the overall status of the ArgoCD applications including the health status and sync status. The dashboard includes visualizations for git requests, K8s API activity and overall cluster stats. Th dashbaord also has visualization for individual components of ArgoCD like RepoServer and Server 

#TODO screenshots

## Alerts Overview
- ArgoAppOutOfSync: An ArgoCD application has status OutOfSync.
- ArgoAppSyncFailed: An increase in unsuccessful syncs was observed in the last five minutes, with a one-minute pending period. This is a recent-event alert, not the application's current operation phase. A later successful sync does not erase failures still in that window.
- ArgoAppMissing: An ArgoCD application has status missing.

## Sync failure alert limitations
`argocd_app_sync_total` is cumulative and its phase-labeled series can first appear at a nonzero value. The alert only counts changes between observed samples: it cannot detect the first failure if the series was not previously scraped at zero, or failures hidden by a scrape gap or counter reset. It deliberately does not treat a newly discovered nonzero series as a new event, since that value may be old history after Prometheus starts or relabeling changes. Detecting every first failure requires producer-side zero initialization or a current-operation-state signal; this rule does not provide that guarantee.

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