# Catchpoint Mixin
The Catchpoint mixin is a set of configurable Grafana dashboards and alerts.

The Catchpoint mixin contains the following dashboards:

- Catchpoint overview
- Catchpoint web performance by test name
- Catchpoint web performance by node name

and the following alerts:

- HighDNSResolutionTime
- TotalTimeExceeded
- ContentLoadingDelays
- HighServerResponseTime
- HighFailedRequestRatio

## Catchpoint overview

The Catchpoint cluster overview dashboard provides details on alerts, load times, request success rates, connections, and errors.

![Catchpoint overview dashboard]()

## Catchpoint web performance by test name

The Catchpoint web performance by test name dashboard provides details on page completion times, response sizes, network connections, requests, content types, and errors. These metrics are all grouped by test name.

![Catchpoint web performance by test name]()

## Catchpoint web performance by node name

The Catchpoint web performance by node name dashboard provides details on page completion times, response sizes, network connections, requests, content types, and errors. These metrics are all grouped by node name.

![Catchpoint web performance by node name]()

## Alerts Overview

| Alert                                  | Summary                                                                                                                                                                 |
| -------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| HighNumberClientWaitingConnections     | High number of clients waiting a connection, which may indicate a bottleneck in connection pooling, where too many clients are waiting for available server connections |
| HighClientWaitTime                     | Clients are experiencing significant delays, which could indicate issues with connection pool saturation or server performance.                                         |
| HighServerConnectionSaturationWarning  | System is nearing a high number of user connections, near the threshold of configured max user connections.                                                             |
| HighServerConnectionSaturationCritical | System is nearing a critically high number of user connections, near the threshold of configured max user connections.                                                  |

Default thresholds can be configured in `config.libsonnet`

```js
{
  _config+:: {
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

