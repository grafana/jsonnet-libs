# Aerospike mixin

The Aerospike mixin is a set of configurable Grafana dashboards and alerts.

The Aerospike mixin contains the following dashboards:

- Aerospike overview
- Aerospike instance overview
- Aerospike namespace overview
- Aerospike logs

and the following alerts:

- AerospikeNodeHighMemoryUsage
- AerospikeNamespaceHighDiskUsage
- AerospikeUnavailablePartitions
- AerospikeDeadPartitions
- AerospikeNamespaceRejectingWrites
- AerospikeHighClientReadErrorRate
- AerospikeHighClientWriteErrorRate
- AerospikeHighClientUDFErrorRate

## Aerospike overview

The Aerospike overview dashboard provides cluster statistics, including number of namespaces and nodes, unavailable/dead partitions, memory/disk usage, client transactions, and connections. 

![First screenshot of the Aerospike overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/aerospike_overview_1.png)
![Second screenshot of the Aerospike overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/aerospike_overview_2.png)

## Aerospike instance overview

The Aerospike instance overview dashboard provides details on one or more instances, including memory/disk usage, unavailable/dead partitions, client transactions, system resources, and system logs. By default, Aerospike logs are sent to STDERR, but the recommended configuration sends logs to `/var/log/aerospike/aerospike.log`.

![First screenshot of the Aerospike instance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/aerospike_instance_overview_1.png)
![Second screenshot of the Aerospike instance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/aerospike_instance_overview_2.png)
![Third screenshot of the Aerospike instance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/aerospike_instance_overview_3.png)

## Aerospike namespace overview

The Aerospike namespace overview dashboard provides details on one or more namespaces, including system resource utilization, unavailable/dead partitions, and client transactions.

![First screenshot of the Aerospike namespace overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/aerospike_namespace_overview_1.png)
![Second screenshot of the Aerospike namespace overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/aerospike_namespace_overview_2.png)

## Aerospike logs

The Aerospike logs dashboard provides details on incoming system logs.

![First screenshot of the Aerospike logs dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/aerospike_logs_1.png)

Aerospike system logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `instance`, `job`, and `aerospike_cluster` labels onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/aerospike
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/aerospike
          instance: "<your-instance-name>"
          aerospike_cluster: "<your-cluster-name>"
          __path__: /var/log/aerospike/aerospike.log
    pipeline_stages:
        - multiline:
            firstline: '\w{3} \d{2} \d{4}'
        - regex:
            expression: '\w{3} \d{2} \d{4} \d{2}:\d{2}:\d{2} \w{3}: (?P<level>\w+) \((?P<context>\w+)\): (?P<trace>\(\S+\))\s+(?P<message>(?s:.*))$'
        - labels:
            level:
            context:
```

## Alerts overview

- AerospikeNodeHighMemoryUsage: There is a limited amount of memory available for a node.
- AerospikeNamespaceHighDiskUsage: There is a limited amount of disk space available for a node.
- AerospikeUnavailablePartitions: There is an unavailable partition in the Aerospike cluster.
- AerospikeDeadPartitions: There is a dead partition in the Aerospike cluster.
- AerospikeNamespaceRejectingWrites: A namespace is currently rejecting all writes. Check for unavailable/dead partitions, clock skew, or nodes running out of memory/disk.
- AerospikeHighClientReadErrorRate: There is a high rate of errors for client read transactions.
- AerospikeHighClientWriteErrorRate: There is a high rate of errors for client write transactions.
- AerospikeHighClientUDFErrorRate: There is a high rate of errors for client UDF transactions.

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    alertsCriticalNodeHighMemoryUsage: 20, // %
    alertsCriticalNamespaceHighDiskUsage: 20,  // %
    alertsCriticalUnavailablePartitions: 0,  // count
    alertsCriticalDeadPartitions: 0,  // count
    alertsCriticalSystemRejectingWrites: 0, // count
    alertsWarningHighClientReadErrorRate: 25, // %
    alertsWarningHighClientWriteErrorRate: 25, // %
    alertsWarningHighClientUDFErrorRate: 25, // %
  },
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
