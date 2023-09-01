# Apache ActiveMQ mixin

The Apache ActiveMQ mixin is a set of configurable Grafana dashboards and alerts.

The Apache ActiveMQ mixin contains the following dashboards:

- Apache ActiveMQ cluster overview
- Apache ActiveMQ instance overview
- Apache ActiveMQ queue overview
- Apache ActiveMQ topic overview
- Apache ActiveMQ logs overview

and the following alerts:

- ApacheActiveMQHighTopicMemoryUsage
- ApacheActiveMQHighQueueMemoryUsage
- ApacheActiveMQHighStoreMemoryUsage
- ApacheActiveMQHighTemporaryMemoryUsage

## Apache ActiveMQ cluster overview

The Apache ActiveMQ cluster overview provides cluster level statistics showing cluster count, broker count, producer count and consumer counts, overall memory level usage, and a general look into enqueue/dequeue counts.
![Screenshot of the Apache ActiveMQ cluster overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/apache_activemq_cluster_overview.png)

## Apache ActiveMQ instance overview

The Apache ActiveMQ instance overview provides instance level statistics showing memory levels, producer and consumer counts, queue sizes, enqueue/dequeue counts, average enqueue times, expired message counts, jvm garabage collection info, and alerts.
![First screenshot of the Apache ActiveMQ instance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/apache_activemq_instance_overview_1.png)
![Second screenshot of the Apache ActiveMQ instance overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/apache_activemq_instance_overview_2.png)

## Apache ActiveMQ queue overview

The Apache ActiveMQ queue overview provides queue level statistics showing number of queues, message size, producer and consumer count, enqueue/dequeue rates, average enqueue times, expired message rates, and average size of messages.
![Screenshot of the Apache ActiveMQ queue overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/apache_activemq_queue_overview.png)

## Apache ActiveMQ queue overview

The Apache ActiveMQ topic overview provides queue level statistics showing number of topics, message size, producer and consumer count, enqueue/dequeue rates, average enqueue times, expired message rates, and average size of messages.
![Screenshot of the Apache ActiveMQ topic overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/apache_activemq_topic_overview.png)

## Apache ActiveMQ logs overview

The Apache ActiveMQ logs overview provides logs of the ActiveMQ environmnet that is able to be parsed by severity.
![Screenshot of the Apache ActiveMQ logs overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/aerospike/screenshots/apache_activemq_logs_overview.png)

## Alerts Overview

- ApacheActiveMQHighTopicMemoryUsage: Topic destination memory usage high which may result in a reduction of the rate at which producers send messages.
- ApacheActiveMQHighQueueMemoryUsage: Queue destination memory usage high which may result in a reduction of the rate at which producers send messages.
- ApacheActiveMQHighStoreMemoryUsage: Store memory usage high which may result in producers unable to send messages.
- ApacheActiveMQHighTemporaryMemoryUsage: Temporary memory usage high which may result in saturation of messaging throughput.

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    dashboardTags: ['apache-activemq-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // alerts thresholds
    alertsHighTopicMemoryUsage: 70,  // %
    alertsHighQueueMemoryUsage: 70,  // %
    alertsHighStoreMemoryUsage: 70,  // %
    alertsHighTemporaryMemoryUsage: 70,  // %

    enableLokiLogs: false,
    filterSelector: 'job=~"integrations/activemq"',
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
