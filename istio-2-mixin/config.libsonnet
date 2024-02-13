{
  // Static selector to apply to ALL dashboard variables of type query, panel queries, alerts and recording rules.
  filteringSelector: 'job="integrations/istio"',
  // Used to identify 'group' of instances.
  groupLabels: ['job', 'cluster'],
  istiodLabel: 'istiod',
  gatewayLabel: 'gateway',
  proxyLabel: 'proxy',
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
  typeCDSFilter: 'type="cds"',
  typeEDSFilter: 'type="eds"',
  typeLDSFilter: 'type="lds"',
  typeSDSFilter: 'type="sds"',
  typeNDSFilter: 'type="nds"',
  typeRDSFilter: 'type="rds"',
  clusterNamexDSGRPCFilter: 'cluster_name="xds-grpc"'
}
