// PromQL selectors and static label filters shared by the signal
// definitions. Ported from the selectors previously computed in
// variables.libsonnet/targets.libsonnet so that rendered queries stay
// identical to the pre-signals dashboards.
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;

function(this)
  local groupSelector = utils.labelsToPromQLSelector(this.groupLabels);
  {
    queriesGroupSelector: groupSelector,
    queriesGroupIstiodSelector: '%s,%s' % [groupSelector, 'pod=~"$istiod"'],
    queriesGroupGatewaySelector: '%s,%s' % [groupSelector, 'pod=~"$gateway"'],
    queriesGroupProxySelector: '%s,%s' % [groupSelector, 'pod=~"$proxy"'],
    queriesGroupClientServiceSelector: '%s,%s' % [groupSelector, 'source_workload_namespace=~"$namespace",source_canonical_service=~"$service",destination_canonical_service=~"$server_service"'],
    queriesGroupServerServiceSelector: '%s,%s' % [groupSelector, 'destination_workload_namespace=~"$namespace",destination_canonical_service=~"$service",source_canonical_service=~"$client_service"'],
    queriesGroupSourceServiceSelector: '%s,%s' % [groupSelector, 'source_workload_namespace=~"$namespace",source_canonical_service=~"$service"'],
    queriesGroupDestinationServiceSelector: '%s,%s' % [groupSelector, 'destination_workload_namespace=~"$namespace",destination_canonical_service=~"$service"'],
    queriesGroupClientWorkloadSelector: '%s,%s' % [groupSelector, 'source_workload_namespace=~"$namespace",source_workload=~"$workload",destination_workload=~"$server_workload"'],
    queriesGroupServerWorkloadSelector: '%s,%s' % [groupSelector, 'destination_workload_namespace=~"$namespace",destination_workload=~"$workload",source_workload=~"$client_workload"'],
    queriesGroupSourceWorkloadSelector: '%s,%s' % [groupSelector, 'source_workload_namespace=~"$namespace",source_workload=~"$workload"'],
    queriesGroupDestinationWorkloadSelector: '%s,%s' % [groupSelector, 'destination_workload_namespace=~"$namespace",destination_workload=~"$workload"'],
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
    clusterNamexDSGRPCFilter: 'cluster_name="xds-grpc"',
  }
