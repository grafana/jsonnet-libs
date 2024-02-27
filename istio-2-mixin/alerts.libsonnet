{
  new(this): {
    local reporterSourceFilter = 'reporter="source"',
    local grpcResponseStatusErrorFilter = 'grpc_response_status=~"[1-9]\\\\d*"',
    local grpcResponseStatusFilter = 'grpc_response_status=~"[0-9]\\\\d*"',
    local requestProtocolHTTPFilter = 'request_protocol="http"',
    local httpResponseCodeErrorFilter = 'request_protocol="http", response_code=~"[45].+"',

    groups: [
      {
        name: 'istio-alerts-' + this.config.uid,
        rules: [
          {
            alert: 'IstioHighCPUUsageWarning',
            expr: |||
              100 * (sum without (instance, pod) (rate(process_cpu_seconds_total{%(filteringSelector)s, pod=~"istiod.*"}[5m])) + sum without (instance, pod) (rate(istio_agent_process_cpu_seconds_total{%(filteringSelector)s}[5m]))) > %(alertsWarningHighCPUUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High vCPU usage can indicate that the k8s environment is underprovisioned.',
              description: |||
                Istio cluster {{$labels.cluster}} has had vCPU usage of {{ printf "%%.0f" $value }}%% over the last 5 minutes, which is above the threshold of %(alertsWarningHighCPUUsage)s.
              ||| % this.config,
            },
          },
          {
            alert: 'IstioHighCPUUsageCritical',
            expr: |||
              100 * (sum without (instance, pod) (rate(process_cpu_seconds_total{%(filteringSelector)s, pod=~"istiod.*"}[5m])) + sum without (instance, pod) (rate(istio_agent_process_cpu_seconds_total{%(filteringSelector)s}[5m]))) > %(alertsCriticalHighCPUUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'High vCPU usage can indicate that the k8s environment is underprovisioned.',
              description: |||
                Istio cluster {{$labels.cluster}} has had vCPU usage of {{ printf "%%.0f" $value }}%% over the last 5 minutes, which is above the threshold of %(alertsCriticalHighCPUUsage)s.
              ||| % this.config,
            },
          },
          {
            alert: 'IstioHighRequestLatencyWarning',
            expr: |||
              sum without(connection_security_policy, destination_app, destination_canonical_revision, destination_service_name, destination_cluster, destination_principal, destination_service, destination_service_namespace, destination_version, destination_workload, destination_workload_namespace, grpc_response_status, instance, pod, reporter, request_protocol, response_code, response_flags, source_app, source_canonical_revision, source_cluster, source_principal, source_version, source_workload, source_workload_namespace) (increase(istio_request_duration_milliseconds_sum{%(filteringSelector)s, %(reporterSourceFilter)s}[5m]))
              /
              clamp_min(sum without(connection_security_policy, destination_app, destination_canonical_revision, destination_service_name, destination_cluster, destination_principal, destination_service, destination_service_namespace, destination_version, destination_workload, destination_workload_namespace, grpc_response_status, instance, pod, reporter, request_protocol, response_code, response_flags, source_app, source_canonical_revision, source_cluster, source_principal, source_version, source_workload, source_workload_namespace) (increase(istio_request_duration_milliseconds_count{%(filteringSelector)s, %(reporterSourceFilter)s}[5m])), 1) > %(alertsWarningHighRequestLatency)s
            ||| % this.config { reporterSourceFilter: reporterSourceFilter },
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'High request latency between pods can indicate that there are performance issues within the k8s environment.',
              description: |||
                Requests from Istio service {{$labels.source_canonical_service}} to service {{$labels.destination_canonical_service}} on cluster {{$labels.cluster}} has an average latency of {{ printf "%%.0f" $value }}ms, which is above the threshold of %(alertsWarningHighRequestLatency)s.
              ||| % this.config,
            },
          },
          {
            alert: 'IstioGalleyValidationFailuresWarning',
            expr: |||
              sum without(instance) (increase(galley_validation_failed{%(filteringSelector)s, pod=~"istiod.*"}[5m])) > %(alertsWarningGalleyValidationFailures)s
            ||| % this.config,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Istio Galley is reporting failures for a number of configurations.',
              description: |||
                {{$labels.pod}} on cluster {{$labels.cluster}} has had {{ printf "%%.0f" $value }} Galley validation failures, which is above the thresold of %(alertsWarningGalleyValidationFailures)s.
              ||| % this.config,
            },
          },
          {
            alert: 'IstioListenerConfigConflictsCritical',
            expr: |||
              sum without(instance) (increase(pilot_conflict_inbound_listener{%(filteringSelector)s, pod=~"istiod.*"}[5m])) + sum without(instance) (increase(pilot_conflict_outbound_listener_tcp_over_current_tcp{%(filteringSelector)s, pod=~"istiod.*"}[5m])) > %(alertsCriticalListenerConfigConflicts)s
            ||| % this.config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Istio Pilot is seeing a number of inbound and or outbound listener conflicts by envoy proxies.',
              description: |||
                {{$labels.pod}} on cluster {{$labels.cluster}} has had {{ printf "%%.0f" $value }} inbound and or outbound listener conflicts reported from envoy proxies, which is above the threshold of %(alertsCriticalListenerConfigConflicts)s.
              ||| % this.config,
            },
          },
          {
            alert: 'IstioXDSConfigRejectionsWarning',
            expr: |||
              sum without(instance) (increase(pilot_total_xds_rejects{%(filteringSelector)s, pod=~"istiod.*"}[5m])) > %(alertsWarningXDSConfigRejections)s
            ||| % this.config,
            'for': '1m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Istio Pilot is seeing a number of xDS rejections from envoy proxies.',
              description: |||
                {{$labels.pod}} on cluster {{$labels.cluster}} has had {{ printf "%%.0f" $value }} xDS rejections from envoy proxies, which is above the threshold of %(alertsWarningXDSConfigRejections)s.
              ||| % this.config,
            },
          },
          {
            alert: 'IstioHighHTTPRequestErrorsCritical',
            expr: |||
              100 * sum without(connection_security_policy, destination_app, destination_canonical_revision, destination_service_name, destination_cluster, destination_principal, destination_service, destination_service_namespace, destination_version, destination_workload, destination_workload_namespace, grpc_response_status, instance, pod, reporter, request_protocol, response_code, response_flags, source_app, source_canonical_revision, source_cluster, source_principal, source_version, source_workload, source_workload_namespace) (increase(istio_requests_total{%(filteringSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s}[5m]))
              /
              clamp_min(sum without(connection_security_policy, destination_app, destination_canonical_revision, destination_service_name, destination_cluster, destination_principal, destination_service, destination_service_namespace, destination_version, destination_workload, destination_workload_namespace, grpc_response_status, instance, pod, reporter, request_protocol, response_code, response_flags, source_app, source_canonical_revision, source_cluster, source_principal, source_version, source_workload, source_workload_namespace) (increase(istio_requests_total{%(filteringSelector)s, %(reporterSourceFilter)s, %(requestProtocolHTTPFilter)s}[5m])), 1) > %(alertsCriticalHTTPRequestErrorPercentage)s
            ||| % this.config { reporterSourceFilter: reporterSourceFilter, httpResponseCodeErrorFilter: httpResponseCodeErrorFilter, requestProtocolHTTPFilter: requestProtocolHTTPFilter },
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of HTTP request errors in the Istio system.',
              description: |||
                HTTP requests from Istio service {{$labels.source_canonical_service}} to service {{$labels.destination_canonical_service}} on cluster {{$labels.cluster}} have an error rate above {{ printf "%%.0f" $value }}%%, which is above the threshold of %(alertsCriticalHTTPRequestErrorPercentage)s%%.
              ||| % this.config,
            },
          },
          {
            alert: 'IstioHighGRPCRequestErrorsCritical',
            expr: |||
              100 * sum without(connection_security_policy, destination_app, destination_canonical_revision, destination_service_name, destination_cluster, destination_principal, destination_service, destination_service_namespace, destination_version, destination_workload, destination_workload_namespace, grpc_response_status, instance, pod, reporter, request_protocol, response_code, response_flags, source_app, source_canonical_revision, source_cluster, source_principal, source_version, source_workload, source_workload_namespace) (increase(istio_requests_total{%(filteringSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusErrorFilter)s}[5m]))
              /
              clamp_min(sum without(connection_security_policy, destination_app, destination_canonical_revision, destination_service_name, destination_cluster, destination_principal, destination_service, destination_service_namespace, destination_version, destination_workload, destination_workload_namespace, grpc_response_status, instance, pod, reporter, request_protocol, response_code, response_flags, source_app, source_canonical_revision, source_cluster, source_principal, source_version, source_workload, source_workload_namespace) (increase(istio_requests_total{%(filteringSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusFilter)s}[5m])), 1) > %(alertsCriticalGRPCRequestErrorPercentage)s
            ||| % this.config { reporterSourceFilter: reporterSourceFilter, grpcResponseStatusErrorFilter: grpcResponseStatusErrorFilter, grpcResponseStatusFilter: grpcResponseStatusFilter },
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are a high number of GRPC request errors in the Istio system.',
              description: |||
                GRPC requests from Istio service {{$labels.source_canonical_service}} to service {{$labels.destination_canonical_service}} on cluster {{$labels.cluster}} have an error rate above {{ printf "%%.0f" $value }}%%, which is above the threshold of %(alertsCriticalGRPCRequestErrorPercentage)s%%.
              ||| % this.config,
            },
          },
          {
            alert: 'IstioMetricsDown',
            expr: |||
              up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Istio metrics are down.',
              description:
                (
                  'There are no available metrics for Istio integration from pod {{$labels.pod}} in cluster {{$labels.cluster}}.'
                ) % this.config,
            },
          },
        ],
      },
    ],
  },
}
