# IBM MQ Mixin

IBM MQ mixin is a set of configurable Grafana dashboards and alerts.

The IBM MQ mixin contains the following dashboards:

- IBM MQ cluster overview
- IBM MQ queue overview
- IBM MQ queue manager overview
- IBM MQ topics overview

and the following alerts:

- IBMMQStaleMessages
- IBMMQStaleMessages
- IBMMQLowDiskSpace
- IBMMQHighQueueManagerCpuUsage

## IBM MQ cluster overview 

The IBM MQ cluster overview dashboard provides details on the number and status of clusters, queue managers, queues, and topics within and IBM MQ cluster. This also includes information about the amount of time it takes for a messsage to get through a transmission queue.

# screenshots
![]()

## IBM MQ queue manager overview

The IBM MQ queue manager dashboard provides details on the different queue managers within a cluster. This includes memory usage, active connections, the numbers of queues controlled, current status, published and expired messages, and queue operations. Lastly, queue manager dashboard provides a look at IBM MQ error logs. IBM MQ error logs can be found via this glob `/var/mqm/log/<qmgr>/errors/*.log` on Linux or ` C:\Program Files\IBM\MQ\qmgrs\**\errors\*.(log|LOG)` on Windows. There will typically be a folder for each queue manager. Under that folder there will hold all the error logs for a specific queue manager (Example: `/var/mqm/log/LONDON/errors/*.log`).

IBM MQ logs are enabled by default in the `config.libsonnet` and can be removed by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for error logs ingested into your logs datasource, please also include the matching `job` and `instance` labels onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics. In order to add a `qmgr` label to filter logs in a dashboard, be sure to include the `pipeline_stages` section from the snippet below.

```yaml
- job_name: integrations/ibm_mq
      static_configs:
        - targets:
            - localhost
          labels:
            job: integrations/ibm_mq
            instance: <your-instance>
            __path__: /var/mqm/qmgrs/*/errors/*.LOG
      pipeline_stages:
      - match:
          selector: '{job="integrations/ibm_mq",instance="<your-instance>"}'
          stages:
          - regex:
              source: filename
              expression: "/var/mqm/qmgrs/(?P<qmgr>.*?)/errors/.*\\.LOG"
          - labels:
              qmgr:
      - multiline:
          firstline: '^\s*\d{2}\/\d{2}\/\d{2}\s+\d{2}:\d{2}:\d{2}\s*-'
```
# screenshots
![]()
## IBM MQ queue overview

The IBM MQ queue overview dashboard provides details on queue depth, average queue time, expired queue messages, operations, and operations throughput. 

# screenshots
![]()
## IBM MQ topics overview

The IBM MQ topics overview dashboard provides details on topic subscribers, topic publishers, time since last message, and subscription status.

# screenshots
![]()
## Alerts overview

IBMMQStaleMessages: There are expired messages, which imply that application resilience is failing.
IBMMQStaleMessages: Stale messages have been detected.
IBMMQLowDiskSpace: There is limited disk available for a queue manager.
IBMMQHighQueueManagerCpuUsage: There is a high cpu usage estimate for a queue manager.

Default thresholds can be configured in `config,libsonnet`

```js
{
  _config+:: {
    alertsExpiredMessages: 2,  //count
    alertsStaleMessagesSeconds: 300,  //seconds
    alertsLowDiskSpace: 5,  //percentage: 0-100
    alertsHighQueueManagerCpuUsage: 85,  //percentage: 0-100
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

## Generate dashboards and alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
