# Varnish Cache mixin

Varnish Cache mixin contains a configurable dashboard and set of alerts.

The Varnish Cache mixin contains the following dashboards:

- Varnish overview

and the following alerts:

- VarnishCacheLowCacheHitRate
- VarnishCacheHighMemoryUsage
- VarnishCacheHighCacheEvictionRate
- VarnishCacheHighSaturation
- VarnishCacheSessionsDropping
- VarnishCacheBackendUnhealthy

## Varnish Cache overview

The Varnish overview dashboard delivers a breakdown of metrics such as thread utilization, client and backend requests, connections, cache, network throughput, and client and backend log data, offering an in-depth perspective on connections and communication. [Promtail and Loki needs to be installed](https://grafana.com/docs/loki/latest/installation/) and provisioned for logs with your Grafana instance.

![First screenshot of the Varnish Cache overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/varnish/screenshots/varnish_cache_overview_1.png)
![Second screenshot of the Varnish Cache overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/varnish/screenshots/varnish_cache_overview_2.png)

In order to get logs, users must enable the `varnishncsa` process with the below commands after creating their varnish instance.

```bash
sudo systemctl enable varnishncsa
sudo systemctl start varnishncsa`
```

Users have the choice of configuring their varnish logs to show whatever they'd like with the formatting flag of varnishncsa, by default this dashboard provides the following configuration.

```bash
sudo varnishncsa -F '{"Timestamp": "%t", "Varnish-Side": "%{Varnish:side}x", "Age": %{age}o, "Handling": "%{Varnish:handling}x", "Request": "%r", "Status": "%s", "Response-Reason": "%{VSL:RespReason}x", "Fetch-Error": "%{VSL:FetchError}x", "X-Forwarded-For": "%{x-forwarded-for}i", "Remote-User": "%u", "Bytes": "%b", "Time-To-Serve": %D, "User-Agent": "%{User-agent}i", "Referer": "%{Referer}i", "X-Varnish": "%{x-varnish}o", "X-Magento-Tags": "%{x-magento-tags}o"}}' -D -w /var/log/varnish/varnishncsa.log
sudo varnishncsa -b -F '{"Timestamp": "%t", "Varnish-Side": "%{Varnish:side}x", "Handling": "%{Varnish:handling}x", "Request": "%r", "Status": "%s", "Response-Reason": "%{VSL:RespReason}x", "Fetch-Error": "%{VSL:FetchError}x", "Bytes": "%b", "Time-To-Serve": %D}' -D -w /var/log/varnish/varnishncsa-backend.log
```

The above two commmands provide client and backend logs. Note the portion below which specifies where the logs are written and to daemonize the process.

```bash
-D -w /var/log/varnish/
```

```yaml
scrape_configs:
  - job_name: integrations/varnish-cache
    static_configs:
      - targets:
          - localhost
        labels:
          job: integrations/varnish-cache
          instance: <exporter_host>:<exporter_port>
          __path__: /var/log/varnish/varnishncsa*.log*
```

#### Varnish Cache logs in Kubernetes

To collect logs from Varnish Cache when running in a kubernetes environment, `varnishncsa` and Alloy sidecars must be added to the deployment configuration. Additional ConfigMaps for custom Alloy configurations must be created. The deployment will need an additional volume for logs and all sidecars will need `volumeMounts` for that volume.

> For `varnishncsa` to run, the log file needs to already exist. This can be accomplished with an `initContainer`.

The mixin is expecting `filename` to match with the following regex patterns for frontend and/or backend logs:
```regex
/var/log/varnish/varnishncsa-frontend.*.log|/opt/varnish/log/varnishncsa-frontend.*.log
/var/log/varnish/varnishncsa-backend.*.log|/opt/varnish/log/varnishncsa-backend.*.log
```
It is necessary for the log location in your deployment to match these patterns.

The `varnishncsa` sidecars need to run as a user with the appropriate permissions to write to the log file(s). If there are
frontend and backend logs, two separate sidecars will need to be defined, customized to start `varnishncsa` with the appropriate flags.

Refer to [this documentation](https://grafana.com/docs/grafana-cloud/monitor-infrastructure/integrations/integration-reference/integration-varnish-cache/#set-up-varnish-cache-logging) for more information on the commands and flags needed for frontend/backend logging. Additionally, for further details on varnishncsa refer to [this documentation](https://varnish-cache.org/docs/trunk/reference/varnishncsa.html).

A single Alloy sidecar with a custom configuration can be defined to collect all the logs, assuming the appropriate volumes are 
mounted and that the log files are all located in the same location.

## Alerts overview

| Alert                             | Summary                                                                             |
| --------------------------------- | ----------------------------------------------------------------------------------- |
| VarnishCacheLowCacheHitRate       | Cache is not answering a sufficient percentage of read requests.                    |
| VarnishCacheHighMemoryUsage       | Varnish Cache is running low on available memory.                                   |
| VarnishCacheHighCacheEvictionRate | The cache is evicting too many objects.                                             |
| VarnishCacheHighSaturation        | There are too many threads in queue, Varnish is saturated and responses are slowed. |
| VarnishCacheSessionsDropping      | Incoming requests are being dropped due to a lack of free worker threads.           |
| VarnishCacheBackendUnhealthy      | Backend has been marked as unhealthy due to slow 200 responses.                     |

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    alertsWarningCacheHitRate: 80,  //%
    alertsWarningHighMemoryUsage: 90,  //%
    alertsCriticalCacheEviction: 0,
    alertsWarningHighSaturation: 0,
    alertsCriticalSessionsDropped: 0,
    alertsCriticalBackendUnhealthy: 0,
    enableLokiLogs: true,
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
