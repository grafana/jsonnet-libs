# F5 BIG-IP Mixin

F5 BIG-IP mixin is a set of configurable Grafana dashboards and alerts.

The BIG-IP mixin contains the following dashboards:

-  BIG-IP cluster overview
-  BIG-IP node overview
-  BIG-IP pool overview
-  BIG-IP virtual server overview
-  BIG-IP logs overview

The BIG-IP mixin contains the following alerts:

- BigIPLowNodeAvailabilityStatus
- BigIPServerSideConnectionLimit
- BigIPHighRequestRate
- BigIPHighConnectionQueueDepth

## BIG-IP Cluster Overview

The BIG-IP cluster overview dashboard provides high level details on node, pool and virtual server availability. Additionally, the top metrics for the server-side, outbound traffic, active members in pools, requested pools, queue depth, utilized virtual servers and latency virtual servers is shown.

![BIG-IP Cluster Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-cluster-overview.png)


## BIG-IP Node Overview

The BIG-IP node overview dashboard provides node specific metrics such as availability, active sessions, requests, connections, traffic and packets.

![F5 Node Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-node-overview.png)


## BIG-IP Pool Overview

The BIG-IP pool overview dashboard provides pool specific metrics such as availability, members, requests, connections, connection queue depth, connection queue serviced, traffic and packets.

![BIG-IP Pool Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-pool-overview-1.png)

![BIG-IP Pool Overview 2 Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-pool-overview-2.png)


## BIG-IP Virtual Server Overview

The BIG-IP virtual server overview dashboard provides virtual server specific metrics such as availability, requests, connections, average connection duration, traffic and packets.

![BIG-IP Virtual Server Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-virtual-server-overview-1.png)

![BIG-IP Virtual Server Overview 2 Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-virtual-server-overview-2.png)

## ### BIG-IP Logs Overview

The Logs Overview dashboard monitors server, high availability and audit logs using a logs volume and the raw logs panel. To collect BIG-IP logs, several actions must be taken such as, enabling logs on F5 BIG-IP, forward logs with a[syslog-forward-converter](https://utcc.utoronto.ca/~cks/space/blog/sysadmin/PromtailRsyslogForwarderSetup), and forwarding logs to Loki Using [Promtail](https://grafana.com/docs/loki/latest/setup/install/).

### Enabling Logs on F5 BIG-IP

Start by enabling logs on your F5 BIG-IP system. The Logs Overview dashboard monitors server, high availability and audit logs. These logs must first be [enabled](https://my.f5.com/manage/s/article/K35284961) on the BIG-IP system which may include auth, authpriv, daemon, local0 and local6 files as recommended in the the table below. The logs dashboard can be used to select a syslog_facility which are created when enabling different [log sources](https://clouddocs.f5.com/api/icontrol-soap/Log__Filter__Source.html) in BIG-IP. Additional logs can be enabled depending on the users need. 


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

### Forwarding Logs From F5 BIG-IP To A Dedicated Host

After logs are enabled, the next step is to securely forward them to a dedicated host. Using a dedicated host provides an extra layer of security by reducing direct access to the F5 BIG-IP system. 

Configuration: Navigate to System > Log > Remote Logging on the F5 BIG-IP interface. Enter the IP address of the dedicated host.

### Processing Logs With Rsyslog

To forward logs to Promtail, you must use [Rsyslog](https://www.rsyslog.com/doc/master/installation/index.html) as an intermediate log forwarder. Below are the steps:

1. Install Rsyslog: If not already installed, get it from the package manager of your choice.
2. Configure Rsyslog: Edit `/etc/rsyslog.conf` or create a new configuration file in `/etc/rsyslog.d/`. Add the following:

```bash
module(load="imudp")
module(load="imtcp")

input(type="imudp" port="50514")
input(type="imtcp" port="50514")

*.*  action(type="omfwd"
      protocol="tcp" target="127.0.0.1" port="40514"
      Template="RSYSLOG_SyslogProtocol23Format"
      TCP_Framing="octet-counted" KeepAlive="on"
      action.resumeRetryCount="-1"
      queue.type="linkedlist" queue.size="50000")
```
3. Restart Rsyslog: Apply the new settings with the following command:
```
sudo systemctl restart rsyslog
```
4. Verify Operation: Check `/var/log/syslog`` for any Rsyslog errors.

### Forwarding Logs To Loki Using Promtail

Finally, configure [Promtail](https://grafana.com/docs/loki/latest/setup/install/) to forward logs to Loki. The Promtail YAML configuration should look similar too the one below:

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
      idle_timeout: 12h
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

### Enable Logs For The Mixin

BIG-IP logs are disabled by default in the `config.libsonnet` and can be updated by setting `enableLokiLogs` to `true`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: true,
  },
}
```

![BIG-IP Logs Overview Dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/f5-bigip/screenshots/bigip-logs-overview.png)


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
    dashboardPeriod: 'now-30m',
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
