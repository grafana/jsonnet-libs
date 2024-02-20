# Istio mixin
The Istio mixin is a set of configurable Grafana dashboards and alerts.

The Istio mixin contains the following dashboards:

- Istio overview
- Istio services overview
- Istio workloads overview
- Istio logs

and the following alerts:

- IstioHighCPUUsageWarning
- IstioHighCPUUsageCritical
- IstioHighRequestLatencyWarning
- IstioGalleyValidationFailuresWarning
- IstioListenerConfigConflictsCritical
- IstioXDSConfigRejectionsWarning
- IstioHighHTTPRequestErrorsCritical
- IstioHighGRPCRequestErrorsCritical
- IstioMetricsDown

## Istio overview
The Istio overview dashboard provides high level details on alerts, HTTP/GRPC requests, vCPU, memory, control plane metrics, and service info for Istiod, proxies, and gateways.
![Istio overview dashboard (system)](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_overview_1.png)
![Istio overview dashboard (control plane)](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_overview_2.png)

## Istio services overview
The Istio services overview dashboard provides details on HTTP/GRPC throughput, HTTP/GRPC response time, TCP throughput, and workload info for services acting in both client and server roles.
![Istio services overview dashboard (client)](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_services_overview_1.png)
![Istio services overview dashboard (server)](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_services_overview_2.png)
![Istio services overview dashboard (workloads)](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_services_overview_3.png)

## Istio workloads overview
The Istio workloads overview dashboard provides details on HTTP/GRPC throughput, HTTP/GRPC response time, and TCP throughput for workloads acting in both client and server roles.
![Istio workloads overview dashboard (client)](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_workloads_overview_1.png)
![Istio workloads overview dashboard (server)](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_workloads_overview_2.png)
![Istio workloads overview dashboard (server TCP)](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_workloads_overview_3.png)

# Istio logs
The Istio logs dashboard provides details on incoming envoy proxy access logs.
![Istio logs dashboard](https://storage.googleapis.com/grafanalabs-integration-assets/istio/screenshots/istio_logs.png)

Istio logs are enabled by default in the `config.libsonnet` and can be disabled by setting `enableLokiLogs` to `false`. Then run `make` again to regenerate the dashboard:

```
{
  _config+:: {
    enableLokiLogs: false,
  },
}
```

For the selectors to properly work with the Istio logs ingested into your logs datasource, replace the `cluster` labels as well as ensuring that the `request_method`, `response_code`, and `protocol` are being generated.

```
{
  discovery.kubernetes "istiod" {
    role = "endpoints"

    namespaces {
      names = ["istio-system"]
    }
  }

  discovery.relabel "istiod_filter" {
    targets = discovery.kubernetes.istiod.targets

    rule {
      source_labels = ["__meta_kubernetes_service_name", "__meta_kubernetes_endpoint_port_name"]
      regex         = "istiod;http-monitoring"
      action        = "keep"
    }

    rule {
      action = "replace"
      source_labels = ["__meta_kubernetes_pod_name"]
      target_label  = "pod"
    }

    rule {
      target_label  = "cluster"
      replacement   = "<your-cluster-name>"
    }
  }

  prometheus.scrape "istiod" {
    targets    = discovery.relabel.istiod_filter.output
    forward_to = [prometheus.remote_write.cloud.receiver]
    job_name   = "integrations/istio"
  }

  discovery.kubernetes "envoy_proxies" {
    role = "pod"
  }

  discovery.relabel "envoy_proxies_metrics_filter" {
    targets = discovery.kubernetes.envoy_proxies.targets

    rule {
      source_labels = ["__meta_kubernetes_pod_container_name"]
      regex         = "istio-proxy.*"
      action        = "keep"
    }

    rule {
      source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_port", "__meta_kubernetes_pod_ip"]
      regex         = "(\\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})"
      target_label  = "__address__"
      replacement   = "[$2]:$1"
    }

    rule {
      source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_port", "__meta_kubernetes_pod_ip"]
      regex         = "(\\d+);((([0-9]+?)(\\.|$)){4})"
      target_label  = "__address__"
      replacement   = "$2:$1"
    }

    rule {
      action = "replace"
      source_labels = ["__meta_kubernetes_pod_name"]
      target_label  = "pod"
    }

    rule {
      target_label  = "cluster"
      replacement   = "<your-cluster-name>"
    }
  }

  prometheus.scrape "envoy_proxies" {
    targets      = discovery.relabel.envoy_proxies_metrics_filter.output
    forward_to   = [prometheus.remote_write.cloud.receiver]
    job_name     = "integrations/istio"
    metrics_path = "/stats/prometheus"
  }

  loki.source.kubernetes "envoy_proxies" {
    targets    = discovery.relabel.envoy_proxies_logs_filter.output
    forward_to = [loki.process.istio_access.receiver, loki.process.istio_system.receiver]
  }

  discovery.relabel "envoy_proxies_logs_filter" {
    targets = discovery.kubernetes.envoy_proxies.targets

    rule {
      source_labels = ["__meta_kubernetes_pod_container_port_name"]
      regex         = ".*-envoy-prom"
      action        = "keep"
    }

    rule {
      source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_port", "__meta_kubernetes_pod_ip"]
      regex         = "(\\d+);(([A-Fa-f0-9]{1,4}::?){1,7}[A-Fa-f0-9]{1,4})"
      target_label  = "instance"
      replacement   = "[$2]:$1"
    }

    rule {
      source_labels = ["__meta_kubernetes_pod_annotation_prometheus_io_port", "__meta_kubernetes_pod_ip"]
      regex         = "(\\d+);((([0-9]+?)(\\.|$)){4})"
      target_label  = "instance"
      replacement   = "$2:$1"
    }

    rule {
      target_label  = "job"
      replacement   = "integrations/istio"
    }

    rule {
      target_label  = "cluster"
      replacement   = "<your-cluster-name>"
    }

    rule {
      action = "replace"
      source_labels = ["__meta_kubernetes_pod_name"]
      target_label  = "pod"
    }
  }

  loki.process "istio_system" {
    forward_to = [loki.write.cloud.receiver]

    stage.drop {
      expression = "^\\[.*"
    }

    stage.multiline {
      firstline = "^\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}"
    }
  }

  loki.process "istio_access" {
    forward_to = [loki.write.<name>.receiver]

    stage.drop {
      expression = "^[^\\[].*"
    }

    stage.regex {
      expression = "\\[\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}\\.\\d{3}Z\\] \"(?P<request_method>\\w+) \\S+ (?P<protocol>\\S+)\" (?P<response_code>\\d+) .+"
    }

    stage.labels {
      values = {
        request_method  = "",
        protocol = "",
        response_code = "",
      }
    }
  }
}
```

## Alerts overview
- IstioHighCPUUsageWarning: High vCPU usage can indicate that the k8s environment is underprovisioned.
- IstioHighCPUUsageCritical: High vCPU usage can indicate that the k8s environment is underprovisioned.
- IstioHighRequestLatencyWarning: High request latency between pods can indicate that there are performance issues within the k8s environment.
- IstioGalleyValidationFailuresWarning: Istio Galley is reporting failures for a number of configurations.
- IstioListenerConfigConflictsCritical: Istio Pilot is seeing a number of inbound and or outbound listener conflicts by envoy proxies.
- IstioXDSConfigRejectionsWarning: Istio Pilot is seeing a number of xDS rejections from envoy proxies..
- IstioHighHTTPRequestErrorsCritical: There are a high number of HTTP request errors in the Istio system.
- IstioHighGRPCRequestErrorsCritical: There are a high number of GRPC request errors in the Istio system.
- IstioMetricsDown: Istio metrics are down.

Default thresholds can be configured in `config.libsonnet`.

```js
{
    _configs+:: {
      // alerts thresholds
      alertsWarningHighCPUUsage: 70,  //%
      alertsCriticalHighCPUUsage: 90, //%
      alertsWarningHighRequestLatency: 4000,
      alertsWarningGalleyValidationFailures: 0,
      alertsCriticalListenerConfigConflicts: 0,
      alertsWarningXDSConfigRejections: 0,
      alertsCriticalHTTPRequestErrorPercentage: 5, //%
      alertsCriticalGRPCRequestErrorPercentage: 5, //%
    }
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
