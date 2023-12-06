# Windows Active Directory mixin

The Windows Active Directory mixin is a set of configurable Grafana dashboards and alerts.

The Windows Active Directory mixin contains the following dashboards:

- Windows Active Directory overview
- Windows Active Directory logs

and the following alerts:
- WindowsActiveDirectoryHighPendingReplicationOperations
- WindowsActiveDirectoryHighReplicationSyncRequestFailures
- WindowsActiveDirectoryHighPasswordChange
- WindowsActiveDirectoryMetricsDown

## Windows Active Directory overview

The Windows Active Directory overview dashboard provides details on integration status/alerts, workers/coordinators, error failures, data throughput, blocked nodes, and distributed bytes.
![Windows Active Directory overview dashboard (LDAP)](https://storage.googleapis.com/grafanalabs-integration-assets/windows-active-directory/screenshots/windows_active_directory_overview_1.png)
![Windows Active Directory overview dashboard (database)](https://storage.googleapis.com/grafanalabs-integration-assets/windows-active-directory/screenshots/window_active_directory_overview_2.png)

# Windows Active Directory logs

The Windows Active Directory logs dashboard provides details on incoming Windows Active Directory event logs.
![Windows Active Directory logs dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/windows-active-directory/screenshots/windows_active_directory_logs.png)

Windows Active Directory system logs are enabled by default in the `config.libsonnet` and can be disabled by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

For the selectors to properly work with Windows Active Directory event logs ingested into your logs datasource, please also include the matching `instance` and `job` labels in the [scrape configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
    scrape_configs:
      # Add here any snippet that belongs to the `logs.configs.scrape_configs` section.
      # For a correct indentation, paste snippets copied from Grafana Cloud at the beginning of the line.
    - job_name: integrations/windows
      windows_events:
        use_incoming_timestamp: true
        eventlog_name: 'Application'
        bookmark_path: "./bookmarks-app.xml"
        labels:
            job: integrations/windows
            instance: "<your-instance-name>"
      relabel_configs:
        - source_labels: ['computer']
          target_label: 'agent_hostname'
    
        - json:
            expressions:
              source: source
              level: levelText
        - labels:
            source:
            level:
```

## Alerts overview

- WindowsActiveDirectoryHighPendingReplicationOperations: There is a high number of pending replication operations in Active Directory. A high number of pending operations sustained over a period of time can indicate a problem with replication.
- WindowsActiveDirectoryHighReplicationSyncRequestFailures: There are a number of replication synchronization request failures. These can cause authentication failures, outdated information being propagated across domain controllers, and potentially data loss or inconsistencies.'
- WindowsActiveDirectoryHighPasswordChange: There is a high number of password changes. This may indicate unauthorized changes or attacks.
- WindowsActiveDirectoryMetricsDown: Windows Active Directory metrics are down.

Default thresholds can be configured in `config.libsonnet`.

```js
{
    _configs+:: {
    // alerts thresholds
    alertsHighPendingReplicationOperations: 50,  // count
    alertsHighReplicationSyncRequestFailures: 0, // count
    alertsHighPasswordChanges: 25, //count
    alertsMetricsDownJobName: 'integrations/windows',
    }
}
```

## Install tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
```

For linting and formatting, you would also need `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

`prometheus_alerts.yaml` needs to be imported into Prometheus.

## Generate dashboards and alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
