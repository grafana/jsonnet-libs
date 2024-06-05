# Catchpoint Mixin

The Catchpoint mixin is a set of configurable Grafana dashboards and alerts.

The Catchpoint mixin contains the following dashboards:

- Catchpoint overview
- Catchpoint web performance by tests
- Catchpoint web performance by nodes

and the following alerts:

- CatchpointHighDNSResolutionTime
- CatchpointTotalTimeExceeded
- CatchpointContentLoadingDelays
- CatchpointHighServerResponseTime
- CatchpointHighFailedRequestRatio

## Catchpoint overview

The Catchpoint overview dashboard provides details on alerts, load times, request success rates, connections, and errors.

![Catchpoint overview dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/catchpoint/catchpoint_overview_1.png)
![Catchpoint overview dashboard (connectivity)](https://storage.googleapis.com/grafanalabs-integration-assets/catchpoint/catchpoint_overview_2.png)

## Catchpoint web performance by tests

The Catchpoint web performance by tests dashboard provides details on page completion times, response sizes, network connections, requests, content types, and errors. These metrics are all grouped by tests.

![Catchpoint web performance by tests](https://storage.googleapis.com/grafanalabs-integration-assets/catchpoint/catchpoint_test_overview_1.png)
![Catchpoint web performance by tests (network)](https://storage.googleapis.com/grafanalabs-integration-assets/catchpoint/catchpoint_test_overview_2.png)

## Catchpoint web performance by nodes

The Catchpoint web performance by nodes dashboard provides details on page completion times, response sizes, network connections, requests, content types, and errors. These metrics are all grouped by nodes.

![Catchpoint web performance by nodes](https://storage.googleapis.com/grafanalabs-integration-assets/catchpoint/catchpoint_node_overview_1.png)
![Catchpoint web performance by nodes](https://storage.googleapis.com/grafanalabs-integration-assets/catchpoint/catchpoint_node_overview_2.png)

## Alerts Overview

| Alert                            | Summary                                                                                                                                                       |
| -------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CatchpointHighDNSResolutionTime  | DNS resolution time is high, which could indicate DNS server issues or misconfigurations affecting website accessibility.                                     |
| CatchpointTotalTimeExceeded      | Webpage takes too long to load, potentially indicating issues with server response, network latency, or resource-heavy pages.                                 |
| CatchpointContentLoadingDelays   | Significant delays in content loading could impact user experience and webpage usability.                                                                     |
| CatchpointHighServerResponseTime | High server response times can lead to slow user experiences and decreased satisfaction.                                                                      |
| CatchpointHighFailedRequestRatio | High ratio of failed requests to total requests could indicate deteriorations in service quality, which could affect user experience and compliance with SLA. |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
  alertsHighServerResponseTime: 1000, //ms
  alertsHighServerResponseTimePercent: 1.2, // 120%
  alertsTotalTimeExceeded: 5000, //ms
  alertsTotalTimeExceededPercent: 1.2, // 120%
  alertsHighDNSResolutionTime: 500, //ms
  alertsHighDNSResolutionTimePercent: 1.2, // 120%
  alertsContentLoadingDelay: 3000, //ms
  alertsContentLoadingDelayPercent: 1.2, // 120%
  alertsHighFailedRequestRatioPercent: 0.1, // 10%
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
