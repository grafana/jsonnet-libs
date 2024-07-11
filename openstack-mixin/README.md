# OpenStack mixin

The OpenStack mixin is a set of configurable Grafana dashboards and alerts.

The OpenStack mixin contains the following dashboards:

- OpenStack overview
- OpenStack Nova
- OpenStack Neutron
- OpenStack Cinder
- OpenStack logs

and the following alerts:

- OpenStackPlacementHighMemoryUsageWarning
- OpenStackPlacementHighMemoryUsageCritical
- OpenStackNovaHighVMMemoryUsage
- OpenStackNovaHighVMVCPUUsage
- OpenStackNeutronHighDisconnectedPortRate
- OpenStackNeutronHighInactiveRouterRate
- OpenStackCinderHighBackupMemoryUsage
- OpenStackCinderHighVolumeMemoryUsage
- OpenStackCinderHighPoolCapacityUsage

## OpenStack overview

The OpenStack overview dashboard provides details on OpenStack services, alerts, cloud resource usage, hierarchy, and images.
![OpenStack overview dashboard (services)](https://storage.googleapis.com/grafanalabs-integration-assets/openstack/screenshots/openstack_overview_1.png)
![OpenStack overview dashboard (images)](https://storage.googleapis.com/grafanalabs-integration-assets/openstack/screenshots/openstack_overview_2.png)

## OpenStack Nova

The OpenStack Nova dashboard provides details on the compute service in OpenStack.
![OpenStack Nova dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/openstack/screenshots/openstack_nova.png)

## OpenStack Neutron

The OpenStack Neutron dashboard provides details on the networking service in OpenStack.
![OpenStack Neutron dashboard (networks)](https://storage.googleapis.com/grafanalabs-integration-assets/openstack/screenshots/openstack_neutron_1.png)
![OpenStack Neutron dashboard (ports)](https://storage.googleapis.com/grafanalabs-integration-assets/openstack/screenshots/openstack_neutron_2.png)

## OpenStack Cinder

The OpenStack Cinder dashboard provides details on the block storage service in OpenStack.
![OpenStack Cinder dashboard (storage)](https://storage.googleapis.com/grafanalabs-integration-assets/openstack/screenshots/openstack_cinder_1.png)
![OpenStack Cinder dashboard (agents)](https://storage.googleapis.com/grafanalabs-integration-assets/openstack/screenshots/openstack_cinder_2.png)

# OpenStack logs

The OpenStack logs dashboard provides details on incoming OpenStack journald logs.
![OpenStack logs dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/openstack/screenshots/openstack_logs.png)

OpenStack logs are enabled by default in the `config.libsonnet` and can be disabled by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

For the selectors to properly work with the OpenStack logs ingested into your logs datasource, please also include the matching `instance` and `job` labels in the [scrape configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/openstack
    journal:
      max_age: 12h
      labels:
        job: integrations/openstack
        instance: <your-instance-name>
    relabel_configs:
      - source_labels: ["__journal_systemd_unit"]
        target_label: "unit"
    pipeline_stages:
      - multiline:
          firstline: "(?P<level>(DEBUG|INFO|WARNING|ERROR)) "
      - regex:
          expression: '(?P<level>(DEBUG|INFO|WARNING|ERROR)) (?P<service>\w+)[\w|.]+ (\[.*] )(?P<message>.*)'
      - labels:
          level:
          service:
```

#### Logging to a file (optional)

This integration collects logs from journald, assuming that logging to a file is not configured. If you wish to configure a log file for your OpenStack services:

1. Create a `<service>.log` file.
2. Edit the `<service>.conf` file to include `log_file` and `level` config options.

```bash
log_file = /Path/to/log/dir/<service>.log
level =  WARNING
```
- Other possible `level` options are `DEBUG`, `INFO`, and `ERROR`.
3. Repeat steps 1 & 2 for each service.

## Alerts overview

- OpenStackPlacementHighMemoryUsageWarning: The cloud is using a significant percentage of its allocated memory.
- OpenStackPlacementHighMemoryUsageCritical: The cloud is using a large percentage of its allocated memory, consider allocating more resources.
- OpenStackNovaHighVMMemoryUsage: VMs are using a high percentage of their allocated memory.
- OpenStackNovaHighVMVCPUUsage: VMs are using a high percentage of their allocated virtual CPUs.
- OpenStackNeutronHighDisconnectedPortRate: A high rate of ports have no IP addresses assigned to them.
- OpenStackNeutronHighInactiveRouterRate: A high rate of routers are currently inactive.
- OpenStackCinderHighBackupMemoryUsage: Cinder backups are using a large amount of their maximum memory.
- OpenStackCinderHighVolumeMemoryUsage: Cinder volumes are using a large amount of their maximum memory.
- OpenStackCinderHighPoolCapacityUsage: Cinder pools are using a large amount of their maximum capacity.
- OpenStackNeutronHighIPsUsageWarning: Free IP addresses are running out.
- OpenStackNeutronHighIPsUsageCritical: There are practically no free IP addresses left.
- OpenStackGlanceIsDown: OpenStack Glance service is down.
- OpenStackHeatIsDown: OpenStack Heat service is down.
- OpenStackIdentityIsDown: OpenStack Identity service is down.
- OpenStackPlacementIsDown: OpenStack Placement service is down.
- OpenStackPlacementHighVCPUUsageWarning: OpenStack is using a significant percentage of its allocated vCPU.
- OpenStackPlacementHighVCPUUsageCritical: OpenStack is using a large percentage of its allocated vCPU, consider allocating more resources.
- OpenStackNovaIsDown: OpenStack Nova service is down.
- OpenStackNovaAgentIsDown: OpenStack Nova agent is down on the specific node.
- OpenStackNovaHighVMMemoryUsage: VMs are using a high percentage of their allocated memory.
- OpenStackNeutronIsDown: OpenStack Neutron is down.
- OpenStackNeutronAgentIsDown: OpenStack Neutron agent is down on the specific node.
- OpenStackNeutronL3AgentIsDown: OpenStack Neutron L3 agent is down on the specific node.
- OpenStackCinderIsDown: OpenStack Cinder service is down.
- OpenStackCinderAgentIsDown: OpenStack Cinder agent is down on the specific node.

Default thresholds can be configured in `config.libsonnet`.

```js
{
    _configs+:: {
      alertsWarningPlacementHighMemoryUsage: 80,  // %
      alertsCriticalPlacementHighMemoryUsage: 90,  // %
      alertsWarningPlacementHighVcpuUsage: 80,  // %
      alertsCriticalPlacementHighVcpuUsage: 90,  // %
      alertsWarningNeutronHighIPsUsage: 80,  // %
      alertsCriticalNeutronHighIPSUsage: 90,  // %
      alertsWarningNovaHighVMMemoryUsage: 80,  // %
      alertsWarningNovaHighVMVCPUUsage: 80,  // %
      alertsCriticalNeutronHighDisconnectedPortRate: 25,  // %
      alertsCriticalNeutronHighInactiveRouterRate: 15,  // %
      alertsWarningCinderHighBackupMemoryUsage: 80,  // %
      alertsWarningCinderHighVolumeMemoryUsage: 80,  // %
      alertsWarningCinderHighPoolCapacityUsage: 80,  // %
    }
}
```

## Install tools

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
```

For linting and formatting, `jsonnetfmt` must be installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will depend on your environment.

`prometheus_alerts.yaml` needs to be imported into Prometheus.

## Generate dashboards and alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
