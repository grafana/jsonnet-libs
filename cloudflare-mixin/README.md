# Cloudflare mixin
The Cloudflare mixin is a set of configurable Grafana dashboards and alerts. 

The metrics analyzed here are a part of `Cloudflare Analytics - account and zone analytics` found [here](https://developers.cloudflare.com/analytics/account-and-zone-analytics/). Pool and worker metrics will not appear until your Cloudflare instance has been configured to utilize them.

The Cloudflare mixin contains the following dashboards:

- Cloudflare zone overview
- Cloudflare GeoMap overview
- Cloudflare worker overview

and the following alerts:

- CloudflareHighThreatCount
- CloudflareHighRequestRate
- CloudflareHighHTTPErrorCodes
- CloudflareUnhealthyPools
- CloudflareMetricsDown

## Cloudflare zone overview
The Cloudflare zone overview dashboard provides a detailed look into the performance of the zones in your Cloudflare account. Metrics analyzed include requests, cached requests, various bandwidth numbers, page views, request status, colocations, and pool status.

![First screenshot of Cloudflare zone overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/cloudflare/screenshots/cloudflare-zone-overview-1.png)
![Second screenshot of Cloudflare zone overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/cloudflare/screenshots/cloudflare-zone-overview-2.png)

## Cloudflare Geomap overview
The Cloudflare Geomap overview dashboard utilizes a GeoMap panel to visualize specific metrics on a global map. The metrics utilized here are requests, bandwidth, threats, non-cached requests, and edge requests.

![Screenshot of Cloudflare Geomap overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/cloudflare/screenshots/cloudflare-geomap-overview.png)

## Cloudflare worker overview
The Cloudflare worker overview dashboard provides a look into Cloudflare Worker performance on a per script basis. Metrics include CPU time quantiles, script duration quantiles, requests, and errors.

![Screenshot of Cloudflare worker overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/cloudflare/screenshots/cloudflare-worker-overview.png)

## Alerts overview

- CloudflareHighThreatCount: There are detected threats targeting the zone.
- CloudflareHighRequestRate: A high spike in requests is occurring which may indicate an attack or unexpected load.
- CloudflareHighHTTPErrorCodes: A high number of 4xx or 5xx HTTP status codes are occurring.
- CloudflareUnhealthyPools: There are unhealthy pools.
- CloudflareMetricsDown: Cloudflare metrics are down.

Be sure to set `alertsMetricsDownJobName` to match your environment if using a different `Job` label than the default.

Default thresholds can be configured in `config.libsonnet`.
```js
{
  _config+:: {
    dashboardTags: ['cloudflare-mixin'],
    dashboardPeriod: 'now-30m',
    dashboardTimezone: 'default',
    dashboardRefresh: '1m',

    // CloudflareMetricsDown alert filter variable
    alertsMetricsDownJobName: 'integrations/cloudflare',

    // alerts thresholds
    alertsHighThreatCount: 3, // count
    alertsHighRequestRate: 150, // percentage
    alertsHighHTTPErrorCodeCount: 100, // count
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
