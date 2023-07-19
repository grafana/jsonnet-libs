# Apache Hadoop mixin

The Apache Hadoop mixin is a set of configurable Grafana dashboards and alerts.

The Apache Hadoop mixin contains the following dashboards:

- Apache Hadoop NameNode overview
- Apache Hadoop DataNode overview
- Apache Hadoop NodeManager overview
- Apache Hadoop ResourceManager overview

and the following alerts:

- ApacheHadoopLowHDFSCapacity
- ApacheHadoopHDFSMissingBlocks
- ApacheHadoopHDFSHighVolumeFailures
- ApacheHadoopHighDeadDataNodes
- ApacheHadoopHighNodeManagerCPUUsage
- ApacheHadoopHighNodeManagerMemoryUsage
- ApacheHadoopHighResourceManagerVirtualCoreCPUUsage
- ApacheHadoopHighResourceManagerMemoryUsage

## Apache Hadoop NameNode overview

The Apache Hadoop NameNode overview dashboard provides details on all DataNode state, capacity utilization, total, missing and under-replicated blocks, volume failures, total file and total load.

![First screenshot of the Apache Hadoop NameNode overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hadoop/screenshots/hadoop_namenode_overview_1.png)
![Second screenshot of the Apache Hadoop NameNode overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hadoop/screenshots/hadoop_namenode_overview_2.png)

## Apache Hadoop DataNode overview

The Apache Hadoop DataNode overview dashboard provides details on the number of unread blocks evicted, blocks removed and volume failures.

![First screenshot of the Apache Hadoop DataNode overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hadoop/screenshots/hadoop_datanode_overview_1.png)

## Apache Hadoop NodeManager overview

The Apache Hadoop NodeManager overview dashboard provides details on number of applications running, allocated containers, containers localization duration, launch duration and state, JVM resource metrics, Node resource metrics and container resource metrics.

![First screenshot of the Apache Hadoop NodeManager overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hadoop/screenshots/hadoop_nodemanager_overview_1.png)
![Second screenshot of the Apache Hadoop NodeManager overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hadoop/screenshots/hadoop_nodemanager_overview_2.png)

## Apache ResourceManager overview

The Apache Hadoop ResourceManager overview dashboard provides details on Node Managers state, application state and resource metrics and JVM resource metrics.

![First screenshot of the Apache Hadoop ResourceManager overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hadoop/screenshots/hadoop_resourcemanager_overview_1.png)
![Second screenshot of the Apache Hadoop ResourceManager overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/apache-hadoop/screenshots/hadoop_resourcemanager_overview_2.png)

## Logging

To get Apache Hadoop NameNode, DataNode, NodeManager or ResourceManager logs on the related dashboard, [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. The default Apache Hadoop log path is indicated in the `HADDOP_LOG_DIR` for your system located in `/etc/hadoop/conf`. An example log path may look like `/hadoop/logs/*.log` on Linux.

Hadoop NameNode, DataNode, NodeManager and ResourceManager logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for system logs ingested into your logs datasource, please also include the matching `instance`, `job`, and `hadoop_cluster` labels onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/apache-hadoop
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/apache-hadoop
          instance: '<your-instance-name>'
          hadoop_cluster: '<your-cluster-name>'
          __path__: '<your-log-path>'
```

## Alerts overview

ApacheHadoopLowHDFSCapacity - Remaining HDFS cluster capacity is low which may result in DataNode failures or prevent DataNodes from writing data.
ApacheHadoopHDFSMissingBlocks - There are missing blocks in the HDFS cluster which may indicate potential data loss.
ApacheHadoopHDFSHighVolumeFailures - A volume failure in HDFS cluster may indicate hardware failures.
ApacheHadoopHighDeadDataNodes - Number of dead DataNodes has increased, which could result in data loss and increased network activity.
ApacheHadoopHighNodeManagerCPUUsage - A NodeManager has a CPU usage higher than the configured threshold.
ApacheHadoopHighNodeManagerMemoryUsage - A NodeManager has a higher memory utilization than the configured threshold.
ApacheHadoopHighResourceManagerVirtualCoreCPUUsage - A ResourceManager has a virtual core CPU usage higher than the configured threshold.
ApacheHadoopHighResourceManagerMemoryUsage - A ResourceManager has a higher memory utilization than the configured threshold.

## Install Tools

For linting and formatting, you would also need `mixtool` and `jsonnetfmt` installed. If you
have a working Go development environment, it's easiest to run the following:

```bash
go install github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb@latest
go install github.com/monitoring-mixins/mixtool/cmd/mixtool@latest
go install github.com/google/go-jsonnet/cmd/jsonnetfmt@latest
```

The files in `dashboards_out` need to be imported
into your Grafana server. The exact details will be depending on your environment.

`prometheus_alerts.yaml` needs to be imported into Prometheus.

# Generate Dashboards And Alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
