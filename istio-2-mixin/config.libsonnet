{
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: 'job="integrations/istio"',
  // Used to identify 'group' of instances.
  groupLabels: ['job', 'cluster'],
  istiodLabel: 'istiod',
  gatewayLabel: 'gateway',
  proxyLabel: 'proxy',
  namespaceLabel: 'namespace',
  namespaceQuery: 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster"}) by (destination_workload_namespace, source_workload_namespace) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster"}) by (destination_workload_namespace, source_workload_namespace))',
  namespaceRegex: '/(?:destination|source)_workload_namespace="([^"]*)/g',
  serviceLabel: 'service',
  serviceQuery: 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace"}) by (source_canonical_service) or sum(istio_requests_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace"}) by (destination_canonical_service) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", source_workload_namespace=~"$namespace"}) by (source_canonical_service) or sum(istio_tcp_sent_bytes_total{job=~"$job", cluster=~"$cluster", destination_workload_namespace=~"$namespace"}) by (destination_canonical_service))',
  serviceRegex: '/(?:source_canonical_service|destination_canonical_service)="([^"]*)/g',
  clientServiceLabel: 'client_service',
  clientServiceQuery: 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", destination_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", destination_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service))',
  clientServiceRegex: '/source_canonical_service="([^"]*)/',
  serverServiceLabel: 'server_service',
  serverServiceQuery: 'query_result(sum(istio_requests_total{job=~"$job", cluster=~"$cluster", source_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service) or sum(istio_tcp_received_bytes_total{job=~"$job", cluster=~"$cluster", source_canonical_service=~"$service"}) by (destination_canonical_service, source_canonical_service))',
  serverServiceRegex: '/destination_canonical_service="([^"]*)/',
  instanceLabels: [self.istiodLabel, self.gatewayLabel, self.proxyLabel],
  instanceVariableMetrics: ['pilot_info', 'istio_agent_process_cpu_seconds_total', 'istio_agent_process_cpu_seconds_total'],
  // Prefix all dashboards uids and alert groups
  uid: 'istio',
  // Prefix for all Dashboards and (optional) rule groups
  dashboardNamePrefix: '',
  dashboardTags: [self.uid],
  dashboardPeriod: 'now-1h',
  dashboardTimezone: 'default',
  dashboardRefresh: '1m',

  // Alert thresholds
  alertsWarningHighCPUUsage: 70,  //%
  alertsCriticalHighCPUUsage: 90, //%
  alertsWarningHighHTTPErrorResponseStatus: 5, //%
  alertsWarningHighRequestLatency: 4000,
  alertsWarningGalleyValidationFailures: 0,
  alertsCriticalListenerConfigConflicts: 0,
  alertsWarningXDSConfigRejections: 0,

  // Logs lib related
  // Set to false to disable logs dashboard and logs annotations
  enableLokiLogs: true,

  componentProxyFilter: 'component="proxy"',
  typeGatewayFilter: 'type="Gateway"',
  typeVirtualServiceFilter: 'type="VirtualService"',
  typeDestinationRuleFilter: 'type="DestinationRule"',
  typeServiceEntryFilter: 'type="ServiceEntry"',
  typeWorkloadEntryFilter: 'type="WorkloadEntry"',
  eventAddFilter: 'event="add"',
  eventDeleteFilter: 'event="delete"',
  reporterSourceFilter: 'reporter="source"',
  reporterDestinationFilter: 'reporter="destination"',
  requestProtocolHTTPFilter: 'request_protocol="http"',
  httpResponseCodeOKFilter: 'request_protocol="http", response_code=~"[123].+"',
  httpResponseCodeErrorFilter: 'request_protocol="http", response_code=~"[45].+"',
  httpResponseCode1xxFilter: 'request_protocol="http", response_code=~"1.+"',
  httpResponseCode2xxFilter: 'request_protocol="http", response_code=~"2.+"',
  httpResponseCode3xxFilter: 'request_protocol="http", response_code=~"3.+"',
  httpResponseCode4xxFilter: 'request_protocol="http", response_code=~"4.+"',
  httpResponseCode5xxFilter: 'request_protocol="http", response_code=~"5.+"',
  grpcResponseStatusOKFilter: 'grpc_response_status="0"',
  grpcResponseStatusErrorFilter: 'grpc_response_status=~"[1-9]\\\\d*"',
  grpcResponseStatusFilter: 'grpc_response_status=~"[0-9]\\\\d*"',
  typeCDSFilter: 'type="cds"',
  typeEDSFilter: 'type="eds"',
  typeLDSFilter: 'type="lds"',
  typeSDSFilter: 'type="sds"',
  typeNDSFilter: 'type="nds"',
  typeRDSFilter: 'type="rds"',
  clusterNamexDSGRPCFilter: 'cluster_name="xds-grpc"'
}
