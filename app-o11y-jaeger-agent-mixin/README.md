# App-O11y jaeger-agent-mixin


The `app-o11y-jaeger-agent-mixin` is a copy of the [jaeger-agent-mixin][1] customised to add recommended [OpenTelemetry Resource][2] attributes to Grafana's existing OpenTracing-based Jaeger spans.

The intent is to allow Grafana services to easily transition to OpenTelemetry conventions by changing usages of [jaeger-agent-mixin][1] to use this mixin instead.  

[1]: ../jaeger-agent-mixin
[2]: https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/semantic_conventions/README.md#service-experimental

