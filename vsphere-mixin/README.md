# vSphere mixin

The vSphere mixin is a set of configurable Grafana dashboards and alerts.

The vSphere mixin contains the following dashboards:

- vSphere overview
- vSphere cluster
- vSphere hosts
- vSphere virtual machines
- vSphere logs

and the following alerts:

- VSphereHostInfoCPUUtilization
- VSphereHostWarningMemoryUtilization
- VSphereDatastoreWarningDiskUtilization
- VSphereDatastoreCriticalDiskUtilization
- VSphereHostWarningHighPacketErrors

## vSphere overview

The vSphere overview dashboard provides an overview on CPU, memory, and network throughput details for clusters, resource pools, ESXi hosts, and datastores.

![vSphere overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/vsphere/screenshots/vsphere_overview_1.png)  
![vSphere overview dashboard (hosts)](https://storage.googleapis.com/grafanalabs-integration-assets/vsphere/screenshots/vsphere_overview_2.png)

## vSphere clusters

The vSphere clusters dashboard provides details on cluster CPU and memory while giving a high-level view of their ESXi hosts and VMs.

![vSphere clusters dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/vsphere/screenshots/vsphere_clusters.png)

## vSphere hosts

The vSphere hosts dashboard provides details on ESXi host CPU, memory, network while giving a high-level view of their disks and VMs.

![vSphere hosts dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/vsphere/screenshots/vsphere_hosts_1.png)  
![vSphere hosts dashboard (disks)](https://storage.googleapis.com/grafanalabs-integration-assets/vsphere/screenshots/vsphere_hosts_2.png)

## vSphere virtual machines

The vSphere virtual machines dashboard provides details on virtual machine CPU, memory, network, and disks.

![vSphere virtual machines dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/vsphere/screenshots/vsphere_virtual_machines_1.png)  
![vSphere virtual machines dashboard (disks)](https://storage.googleapis.com/grafanalabs-integration-assets/vsphere/screenshots/vsphere_virtual_machines_2.png)

## vSphere logs

The vSphere logs dashboard provides details on the vSphere system. VMware Appliance Management Service (applmgmt), VMware Analytics (analytics), and VMware vCenter Server (vpxd) logs are collected. [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance.

In addition, logs must be forwarded from your vCenter server to a remote syslog server as described [here](https://docs.vmware.com/en/VMware-vSphere/8.0/vsphere-vcenter-configuration/GUID-9633A961-A5C3-4658-B099-B81E0512DC21.html).

![vSphere logs dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/vsphere/screenshots/vsphere_logs.png)

vSphere logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `job` label onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml

```

## Alerts overview

| Alert                                   | Summary                                                                                                                                                                                   |
| --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| VSphereHostInfoCPUUtilization           | CPU is approaching a high threshold of utilization for an ESXi host. High CPU utilization may lead to performance degradation and potential downtime for virtual machines running on this host.                                     |
| VSphereHostWarningMemoryUtilization     | Memory is approaching a high threshold of utilization for an ESXi host. High memory utilization may cause the host to become unresponsive and impact the performance of virtual machines running on this host. |
| VSphereDatastoreWarningDiskUtilization  | Disk space is approaching a warning threshold of utilization for a datastore. Low disk space may prevent virtual machines from functioning properly and cause data loss.                  |
| VSphereDatastoreCriticalDiskUtilization | Disk space is approaching a critical threshold of utilization for a datastore. Low disk space may prevent virtual machines from functioning properly and cause data loss.         |
| VSphereHostWarningHighPacketErrors      | High percentage of packet errors seen for ESXi host. High packet errors may indicate network issues that can lead to poor performance and connectivity problems for virtual machines running on this host.     |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
  alertsHighCPUUtilization: 90,
  alertsHighMemoryUtilization: 90,
  alertsWarningDiskUtilization: 75,
  alertsCriticalDiskUtilization: 90,
  alertsHighPacketErrors: 20,
  },
}
```

## Install tools

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

## Generate dashboards and alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
