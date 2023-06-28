# Varnish Cache mixin

The Varnish Cache mixin is a set of a configurable Grafana dashboard and alerts.

The SAP HANA mixin contains the following dashboards:

- Varnish overview

and the following alerts:

- VarnishCacheAlertsLowCacheHitRate
- VarnishCacheAlertsHighCacheEvictionRate
- VarnishCacheAlertsHighSaturation
- VarnishCacheAlertsSessionsDropping
- VarnishCacheAlertsBackendFailure
- VarnishCacheAlertsBackendUnhealthy

Default thresholds can be configured in `config.libsonnet`.

```js
{
  _config+:: {
    VarnishCacheAlertsWarningCacheHitRate: 80, // percent 0-100
    VarnishCacheAlertsCriticalCacheEviction: 0,
    VarnishCacheAlertsCriticalSaturation: 0,
    VarnishCacheAlertsCriticalSessionsDropped: 0,
    VarnishCacheAlertsCriticalBackendFailure: 0,
    VarnishCacheAlertsCriticalBackendUnhealthy: 0,
  },
}
```
## Varnish overview
 
```
## Alerts overview

VarnishCacheAlertsLowCacheHitRate: Cache is not answering a sufficient percent of read requests.
VarnishCacheAlertsHighCacheEvictionRate: The cache is evicting objects too fast.
arnishCacheAlertsHighSaturation': There are too many threads in queue, Varnish is saturated and responses are slowed.
VarnishCacheAlertsSessionsDropping: Incoming requests are being dropped due to a lack of free worker threads.
VarnishCacheAlertsBackendFailure: There was a failure to connect to the backend.
VarnishCacheAlertsBackendUnhealthy: Backend has been marked as unhealthy due to slow 200 response.

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
