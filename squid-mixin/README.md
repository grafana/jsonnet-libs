# Squid Mixin

Squid mixin is a set of configurable Grafana dashboards and alerts.

The Squid mixin contains the following dashboards:

- Squid overview

and the following alerts:

- SquidHighPercentageOfHTTPServerRequestErrors
- SquidHighPercentageOfFTPServerRequestErrors
- SquidHighPercentageOfOtherServerRequestErrors
- SquidHighPercentageOfClientRequestErrors
- SquidLowCacheHitRatio

## Squid Overview

The Squid overview dashboard provides details on both server and client HTTP, FTP, and other requests, caching hits and misses, and both cache and access logs.

![TODO Dashboard screenshots]()

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

In order for the selectors to properly work for access and cache logs ingested into your logs datasource, please also include the matching `job` label onto the [scrape_configs](https://grafana.com/docs/loki/latest/clients/promtail/configuration/#scrape_configs) as to match the labels for ingested metrics.

```yaml
scrape_configs:
  - job_name: integrations/squid
    static_configs:
      - targets: [localhost]
        labels:
          job: integrations/squid
          instance: '<your-instance-name>'
          __path__: /var/log/squid/access.log
      - targets: [localhost]
        labels:
          job: integrations/squid
          instance: '<your-instance-name>'
          __path__: /var/log/squid/cache.log
```

## Alerts Overview


| Alert                               | Summary                                                                         |
|-------------------------------------|---------------------------------------------------------------------------------|
| SquidHighPercentageOfHTTPServerRequestErrors             | There are a high number of HTTP server errors.                      |
| SquidHighPercentageOfFTPServerRequestErrors                | There are a high number of FTP server request errors.                         |
| SquidHighPercentageOfOtherServerRequestErrors | There are a high number of other server request errors. |
| SquidHighPercentageOfClientRequestErrors   | There are a high number of HTTP client request errors.                         |
| SquidLowCacheHitRatio     | The cache hit ratio has fallen below 85%.                         |


Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
    alertsCriticalHighPercentageRequestErrors: 5,
    alertsWarningLowCacheHitRatio: 85,
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

## Generate Dashboards And Alerts

Edit `config.libsonnet` if required and then build JSON dashboard files for Grafana:

```bash
make
```

For more advanced uses of mixins, see
https://github.com/monitoring-mixins/docs.
