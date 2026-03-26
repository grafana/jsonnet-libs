# OpenTelemetry Collector observability library

This library can be used to generate dashboards, rows, panels, and alerts for [OpenTelemetry Collector internal telemetry](https://opentelemetry.io/docs/collector/internal-telemetry/) .

## Collector instrumentation

To instrument the OpenTelemetry collector, add the following to your configuration:

```yaml
service:
  telemetry:
    metrics:
      readers:
        - periodic:
            exporter:
              otlp:
                protocol: http/protobuf
                # example: https://otlp-gateway-prod-eu-west-2.grafana.net/otlp/v1/metrics
                endpoint: "<your-otlp-endpoint>"
                # optional, add authorization headers as required
                headers:
                  - name: "authorization"
                    value: "${env:GRAFANA_CLOUD_BASIC_AUTH_HEADER}"
    logs:
      processors:
        - batch:
            exporter:
              otlp:
                protocol: http/protobuf
                # example: https://otlp-gateway-prod-eu-west-2.grafana.net/otlp/v1/logs
                endpoint: "<your-otlp-endpoint>"
                # optional, add authorization headers as required
                headers:
                  - name: "authorization"
                    value: "${env:GRAFANA_CLOUD_BASIC_AUTH_HEADER}"
```

## Import

```sh
jb init
jb install https://github.com/grafana/jsonnet-libs/opentelemetry-collector-observ-lib
```

## Example: Generate monitoring-mixin

```.jsonnet
local otelcollib = import 'opentelemetry-collector-observ-lib/main.libsonnet';
local otelcol =
  otelcollib.new()
  + otelcollib.withConfigMixin(
    {
        filteringSelector: 'job!=""',
    }
  );
otelcollib.asMonitoringMixin()
```

## Implementation notes

The OpenTelemetry collector instrumentation generates separate named metrics for each signal type (logs,metrics,spans) as well as the processing outcome (`accepted`/`refused`).
This causes repetetive signal declaration which is why affected signals are templated based on the signal type instead.


When adding `refused`/`accepted` metrics like `A+B`, additional queries need to be made as prometheus only adds values from `B` if a corresponding series exists in `A`.
The resulting query looks complex but can be broken down to:

```promql
(A + B) or (A unless B) or (B unless A)
```

Once [delayed `__name__` removal](github.com/prometheus/prometheus/pull/14477) is stable across all supported prometheus compatible query engines, we can simplify this library significantly.
Without this feature, we can't run queries like `sum by (receiver) (rate({__name__=~"accepted|refused"}[$__rate_interval]))` as calculating rates across multiple `__name__` values drops the `__name__` label and prevents further aggregation as the vector then contains multiple identical labelsets.

## Developing

An easy way to work on this mixin is to use [grafanactl](https://github.com/grafana/grafanactl).
You can use this tool to work on dashboards locally while using the data from a remote grafana instance.

The [`debug.jsonnet`](./debug.jsonnet) file can be used to render the mixin in a format consumabel by `grafanactl` like this:

```sh
grafanactl resources serve --script 'jsonnet -J vendor ./debug.jsonnet' --watch ./
```

You can now open the dashboard in your browser at `localhost:8080`.
Changes to the jsonnet files will automatically rebuild the dashboard and reload it in your browser.
