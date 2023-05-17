# SAP HANA mixin

The SAP HANA mixin is a set of configurable Grafana dashboards and alerts.

The SAP HANA mixin contains the following dashboards:

- SAP HANA system overview
- SAP HANA instance overview

and the following alerts:

- SapHanaHighCpuUtilization
- SapHanaHighPhysicalMemoryUsage
- SapHanaMemAllocLimitBelowRecommendation
- SapHanaHighMemoryUsage
- SapHanaHighDiskUtilization
- SapHanaHighSqlExecutionTime
- SapHanaHighReplicationShippingTime
- SapHanaReplicationStatusError

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    alertsCriticalHighCpuUsage: 80, // percent 0-100
    alertsCriticalHighPhysicalMemoryUsage: 80, // percent 0-100
    alertsWarningLowMemAllocLimit: 90, // percent 0-100
    alertsCriticalHighMemoryUsage: 80, // percent 0-100
    alertsCriticalHighDiskUtilization: 80, //percent 0-100
    alertsCriticalHighSqlExecutionTime: 1, // second
    alertsCriticalHighReplicationShippingTime: 1, //second
  },
}
```
## SAP HANA system overview

The SAP HANA system overview dashboard provides details on replica status, memory/cpu/disk usage, network throughput, query execution time, connections, and alerts for an SAP HANA system. 

![First screenshot of the SAP HANA system overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/sap-hana/screenshots/sap-hana-system-overview-1.png)
![Second screenshot of the SAP HANA system overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/sap-hana/screenshots/sap-hana-system-overview-2.png)

## SAP HANA instance overview

The SAP HANA instance overview dashboard provides details on memory/cpu/disk usage, network throughput, connections, query time, alerts, schema memory usage, table memory usage, sql query times, and trace logs for SAP HANA hosts.

![First screenshot of the SAP HANA instance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/sap-hana/screenshots/sap-hana-instance-overview-1.png)
![Second screenshot of the SAP HANA instance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/sap-hana/screenshots/sap-hana-instance-overview-2.png)
![Third screenshot of the SAP HANA instance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/sap-hana/screenshots/sap-hana-instance-overview-3.png)

To get SAP HANA trace logs, [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. The default directory for trace files is `/opt/hana/shared/<sid>/HDB<insnr>/<host>/trace/` e.g. `/opt/hana/shared/ID0/HDB00/hana-0/trace/*.trc`

SAP HANA trace logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

## Alerts overview

SapHanaHighCpuUtilization: CPU utilization is high.
SapHanaHighPhysicalMemoryUsage: Current physical memory usage of the host is approaching capacity.
SapHanaMemAllocLimitBelowRecommendation: Memory allocation limit set below recommended limit.
SapHanaHighMemoryUsage: Current SAP HANA memory usage is approaching capacity.
SapHanaHighDiskUtilization: SAP HANA disk is approaching capacity.
SapHanaHighSqlExecutionTime: SAP HANA SQL average execution time is high.
SapHanaHighReplicationShippingTime: SAP HANA system replication log shipping delay is high.
SapHanaReplicationStatusError: SAP HANA system replication status signifies an error.

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
