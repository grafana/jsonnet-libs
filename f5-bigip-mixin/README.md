# F5 BIG IP Mixin

F5 BIG IP mixin is a set of configurable Grafana dashboards and alerts.

The Big IP mixin contains the following dashboards:

-  Big IP cluster overview
-  Big IP node overview
-  Big IP pool overview
-  Big IP virtual server overview
-  Big IP logs overview

The Big IP mixin contains the following alerts:

- BigIPLowNodeAvailabilityStatus
- BigIPServerSideConnectionLimit
- BigIPHighRequestRate
- BigIPHighConnectionQueueDepth

## Big IP Cluster Overview

The Big IP cluster overview dashboard provides high level details on node, pool and virtual server availability. Additionally, the top metrics for the server-side, outbound traffic, active members in pools, requested pools, queue depth, utilized virtual servers and latency virtual servers is shown.

![Big IP Cluster Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-cluster-overview.png)


## Big IP Node Overview

The Big IP node overview dashboard provides node specific metrics such as availability, active sessions, requests, connections, traffic and packets.

![F5 Node Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-node-overview.png)


## Big IP Pool Overview

The Big IP pool overview dashboard provides pool specific metrics such as availability, members, requests, connections, connection queue depth, connection queue serviced, traffic and packets.

![Big IP Pool Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-pool-overview.png)


## Big IP Virtual Server Overview

The Big IP virtual server overview dashboard provides virtual server specific metrics such as availability, requests, connections, average connection duration, traffic and packets.

![Big IP Virtual Server Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-virtual-server-overview.png)


## Big IP Log Overview

The Big IP log overview dashboard collects Big IP [syslog which are forwarded to grafana loki via promtail](https://utcc.utoronto.ca/~cks/space/blog/sysadmin/PromtailRsyslogForwarderSetup). The dashboard can be used to monitor server, high availability, and audit logs using a logs volume and the raw logs panel. This dashboard includes query labels to filter logs such as job, host, syslog_facility, level and a regex search. The syslog_facility collects [enabled logs](https://my.f5.com/manage/s/article/K35284961) on the Big IP system which may include auth, authpriv, daemon, local0 and local6. Additional logs can be enabled depending on the users need.

The logs dashboard can be used to select a syslog_facility which are created when enabling different [log sources](https://clouddocs.f5.com/api/icontrol-soap/Log__Filter__Source.html) in Big IP. Some useful categorizes to enable are: 

| Log category          | log source                  | log description                                                                   | Syslog Facility files        |
|-----------------------|-----------------------------|-----------------------------------------------------------------------------------|------------------------------|
| Server logs           | LOG_SOURCE_BIGD(12)         | The process collecting health checking status logs.                               | `daemon`, `local0`           |
| Server logs           | LOG_SOURCE_AVR(7)           | The Application Visibility and Reporting module logs.                             | `daemon`, `local0`           |
| Server logs           | LOG_SOURCE_TMM(92)          | The Traffic Management Microkernel logs.                                          | `daemon`, `local0`           |
| High performance logs | LOG_SOURCE_HA(42)           | High Availability logs.                                                           | `daemon`, `local0`, `local6` |
| High performance logs | LOG_SOURCE_CHMAND(19)       | The chassis manager daemon logs.                                                  | `daemon`, `local0`, `local6` |
| High performance logs | LOG_SOURCE_CSYNCD(28)       | Replicating portions of the filesystem between cluster members on a VIPRION logs. | `daemon`, `local0`, `local6` |
| Audit logs            | LOG_SOURCE_ACCESSCONTROL(2) | Access control logs.                                                              | `auth`, `authpriv`           |
| Audit logs            | LOG_SOURCE_MCPD(58)         | The MCP daemon logs.                                                              | `daemon`, `local0`           |
| Audit logs            | LOG_SOURCE_SHELL(79)        | Shell commands logs.                                                              | `user`, `local0`             |


Big IP logs are disabled by default in the `config.libsonnet` and can be updated by setting `enableLokiLogs` to `true`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: true,
  },
}
```

To collect logs, [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance. Logs are being forwarded using promtail which requires the following config with credentials:

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: https://<user>:<pass>@logs-prod3.grafana.net/loki/api/v1/push

scrape_configs:
  - job_name: syslog
    syslog:
      listen_address: 0.0.0.0:40514
      # Don't disconnect the forwarder
      idle_timeout: 12h
      # use_incoming_timestamp: true
      listen_protocol: "udp"
      labels:
        job: "syslog"
    relabel_configs:
      - source_labels: ['__syslog_message_hostname']
        target_label: host
      - source_labels: ['__syslog_message_severity']
        target_label: level
      - source_labels: ['__syslog_message_facility']
        target_label: syslog_facility
      - source_labels: ['__syslog_message_app_name']
        target_label: syslog_identifier
```

![Big IP Logs Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-logs-overview.png)


## Alerts Overview

| Alert                            | Summary                                                                                                          |
|----------------------------------|------------------------------------------------------------------------------------------------------------------|
| BigIPLowNodeAvailabilityStatus | Detecting a significant number of unavailable nodes which can causes potential downtime or degraded performance. |
| BigIPServerSideConnectionLimit | Approaching the connection limit may lead to rejecting new connections, impacting availability.                  |
| BigIPHighRequestRate           | An unexpected spike in requests might indicate an issue like a DDoS attack or unexpected high load.              |
| BigIPHighConnectionQueueDepth  | A sudden spike or sustained high queue depth may indicate a bottleneck in handling incoming connections.         |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
    dashboardTags: ['f5-bigip-mixin'],
    dashboardPeriod: 'now-1h',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    grafanaLogDashboardIDs: {
      'bigip-logs-overview.json': 'bigip-logs-overview',
    },

    // alerts thresholds
    alertsCriticalNodeAvailability: 95,  // %
    alertsWarningServerSideConnectionLimit: 80,  // %
    alertsCriticalHighRequestRate: 150,  // %
    alertsCriticalHighConnectionQueueDepth: 75,  // %

    enableLokiLogs: true,
    filterSelector: 'job=~"syslog"',
  },
}

```

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

## Generate Dashboards And Alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
