# Velero Mixin

The Veler mixin is a set of configurable Grafana dashboards and alerts.

The Velero mixin contains the following dashboards:

- Velero

and the following alerts:

- VeleroBackupPartialFailure
- VeleroBackupFailed
- RestoreFailed
- NoBackupJob

## Velero Dashboard Overview
Velero dashbaord provides details on the overall status of the Velero Backups and Restores. The dashboard includes visualizations for backup attempts, failed backups and more panels about the restore operatons. 
#TODO screenshots

## Alerts Overview
- VeleroBackupPartialFailure: A Velero backup has Partially Failed.
- VeleroBackupFailed: A Velero backup has Failed.
- NoBackupJob: A Velero restore has Failed.
- NoBackupJob: No Velero Backup attempts in last 24 hours

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