# Velero Mixin

The Velero mixin is a set of configurable Grafana dashboards and alerts.

The Velero mixin contains the following dashboards:

- Velero cluster view
- Velero overview
- Velero logs 

and the following alerts:

- VeleroBackupFailure
- VeleroHighBackupDuration
- VeleroHighRestoreFailureRate
- VeleroUpStatus

## Velero Overview

The Velero overview dashboard provides details on backup sizes, backup success rates, backup status, restore counts, restore success rates, and snapshot data.

![Velero Overview Dashboard]()

## Velero Cluster Overview

The Velero cluster view dashboard provides details on alerts, volume snapshots, backup, and restore counts.

![Velero Cluster Dashboard]()

## Velero Logs View

The Velero logs overview dashboard provides details on the Velero system. 

![Velero Logs Dashboard]()

Velero logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, here is what the agent flow snippet will look like:

```yaml
  discovery.relabel "velero" {
    targets = discovery.kubernetes.pods.targets
    rule {
      action        = "keep"
      source_labels = ["__meta_kubernetes_pod_label_component"]
      regex         = "velero"
    }
    rule {
      source_labels = ["__meta_kubernetes_pod_container_port_number"]
      regex = "8085"
      action = "keep"
   }
    rule {
      source_labels = ["__meta_kubernetes_pod_name"]
      target_label = "instance"
    }
    rule {
      replacement = "integrations/velero"
      target_label = "job"
    }
  }

  prometheus.scrape "velero" {
    targets      = discovery.relabel.velero.output
    metrics_path = "/metrics"
    forward_to   = [prometheus.relabel.metrics_service.receiver]
  }
  
  discovery.relabel "logs_velero" {
      targets = discovery.relabel.pod_logs.output

      rule {
        action        = "keep"
        source_labels = ["__meta_kubernetes_pod_label_component"]
        regex         = "velero"
      }
      rule {
        target_label = "job"
        replacement = "integrations/velero"
      }
      rule {
        action = "replace"
        source_labels = ["__meta_kubernetes_pod_name"]
        target_label  = "pod"
      }
    }

     loki.source.kubernetes "logs_velero" {
      targets    = discovery.relabel.logs_velero.output
      forward_to = [loki.process.logs_velero.receiver]
     }

     loki.process "logs_velero" {
      forward_to = [loki.process.logs_service.receiver]
      stage.cri {}
      stage.multiline {
        firstline = "time=\"(\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z)\""
      }
      stage.regex {
        expression = "time=\"(\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z)\" level=(?P<level>\\w+)"
      }
      stage.labels {
        values = {
          level  = "",
        }
      }
     }
```

## Alerts Overview

| Alert                         | Summary                                                                                                    |
| ------------------------------| -----------------------------------------------------------------------------------------------------------|
| VeleroBackupFailure           | Indicates backup failures, which could lead to data loss or inability to recover in case of a disaster.    |
| VeleroHighBackupDuration      | Backups taking an unusually long time could indicate performance issues or network congestion.             |
| VeleroHighRestoreFailureRate  | A high rate of restore failures could prevent timely data recovery and continuity.                         |
| VeleroUpStatus                | Cannot find any metrics related to Velero.                                                                 |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
  alertsHighBackupFailure: 0,
  alertsHighBackupDuration: 20,
  alertsHighRestoreFailureRate: 0,
  alertsVeleroUpStatus: 0,
  },
}
```

## Install Tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
# or in brew: brew install go-jsonnet
```

For linting and formatting, you would also need `mixtool` and `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

`prometheus_alerts.yaml` needs to be imported into Prometheus.

## Generate Dashboards And Alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
