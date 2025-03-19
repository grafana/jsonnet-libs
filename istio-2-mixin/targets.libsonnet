local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,
    local panel = g.panel,
    local componentProxyFilter = 'component="proxy"',
    local typeGatewayFilter = 'type="Gateway"',
    local typeVirtualServiceFilter = 'type="VirtualService"',
    local typeDestinationRuleFilter = 'type="DestinationRule"',
    local typeServiceEntryFilter = 'type="ServiceEntry"',
    local typeWorkloadEntryFilter = 'type="WorkloadEntry"',
    local eventAddFilter = 'event="add"',
    local eventDeleteFilter = 'event="delete"',
    local reporterSourceFilter = 'reporter="source"',
    local reporterDestinationFilter = 'reporter="destination"',
    local requestProtocolHTTPFilter = 'request_protocol="http"',
    local httpResponseCodeOKFilter = 'request_protocol="http", response_code=~"[123].+"',
    local httpResponseCodeErrorFilter = 'request_protocol="http", response_code=~"[45].+"',
    local httpResponseCode1xxFilter = 'request_protocol="http", response_code=~"1.+"',
    local httpResponseCode2xxFilter = 'request_protocol="http", response_code=~"2.+"',
    local httpResponseCode3xxFilter = 'request_protocol="http", response_code=~"3.+"',
    local httpResponseCode4xxFilter = 'request_protocol="http", response_code=~"4.+"',
    local httpResponseCode5xxFilter = 'request_protocol="http", response_code=~"5.+"',
    local grpcResponseStatusOKFilter = 'grpc_response_status="0"',
    local grpcResponseStatusErrorFilter = 'grpc_response_status=~"[1-9]\\\\d*"',
    local grpcResponseStatusFilter = 'grpc_response_status=~"[0-9]\\\\d*"',
    local typeCDSFilter = 'type="cds"',
    local typeEDSFilter = 'type="eds"',
    local typeLDSFilter = 'type="lds"',
    local typeSDSFilter = 'type="sds"',
    local typeNDSFilter = 'type="nds"',
    local typeRDSFilter = 'type="rds"',
    local clusterNamexDSGRPCFilter = 'cluster_name="xds-grpc"',

    proxyCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count by(job, cluster) (istio_build{%(queriesGroupSelector)s, %(componentProxyFilter)s})' % vars { componentProxyFilter: componentProxyFilter }
      ),
    gatewayCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeGatewayFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeGatewayFilter)s, %(eventDeleteFilter)s}) or max(up * 0))' % vars { typeGatewayFilter: typeGatewayFilter, eventAddFilter: eventAddFilter, eventDeleteFilter: eventDeleteFilter }
      ),
    virtualServiceCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeVirtualServiceFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeVirtualServiceFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % vars { typeVirtualServiceFilter: typeVirtualServiceFilter, eventAddFilter: eventAddFilter, eventDeleteFilter: eventDeleteFilter }
      ),
    destinationRuleCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeDestinationRuleFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeDestinationRuleFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % vars { typeDestinationRuleFilter: typeDestinationRuleFilter, eventAddFilter: eventAddFilter, eventDeleteFilter: eventDeleteFilter }
      ),
    serviceEntryCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeServiceEntryFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeServiceEntryFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % vars { typeServiceEntryFilter: typeServiceEntryFilter, eventAddFilter: eventAddFilter, eventDeleteFilter: eventDeleteFilter }
      ),
    workloadEntryCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeWorkloadEntryFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeWorkloadEntryFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % vars { typeWorkloadEntryFilter: typeWorkloadEntryFilter, eventAddFilter: eventAddFilter, eventDeleteFilter: eventDeleteFilter }
      ),
    istiodCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by (job, cluster) (rate(process_cpu_seconds_total{%(queriesGroupIstiodSelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - istiod'),
    gatewayCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (rate(istio_agent_process_cpu_seconds_total{%(queriesGroupGatewaySelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway'),
    proxyCPUUsage:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (rate(istio_agent_process_cpu_seconds_total{%(queriesGroupProxySelector)s}[$__rate_interval]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy'),
    istiodOpenFileDescriptors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (process_open_fds{%(queriesGroupIstiodSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - istiod'),
    gatewayOpenFileDescriptors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_process_open_fds{%(queriesGroupGatewaySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway'),
    proxyOpenFileDescriptors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_process_open_fds{%(queriesGroupProxySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy'),
    istiodVirtualMemory:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (process_virtual_memory_bytes{%(queriesGroupIstiodSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - istiod - virtual'),
    istiodResidentMemory:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (process_resident_memory_bytes{%(queriesGroupIstiodSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - istiod - resident'),
    gatewayVirtualMemory:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_process_virtual_memory_bytes{%(queriesGroupGatewaySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - virtual'),
    gatewayResidentMemory:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_process_resident_memory_bytes{%(queriesGroupGatewaySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - resident'),
    proxyVirtualMemory:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_process_virtual_memory_bytes{%(queriesGroupProxySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - virtual'),
    proxyResidentMemory:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_process_resident_memory_bytes{%(queriesGroupProxySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - resident'),
    istiodHeapAllocated:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (go_memstats_heap_alloc_bytes{%(queriesGroupIstiodSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - istiod - alloc'),
    istiodHeapInUse:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (go_memstats_heap_inuse_bytes{%(queriesGroupIstiodSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - istiod - inuse'),
    istiodHeapSystem:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (go_memstats_heap_sys_bytes{%(queriesGroupIstiodSelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - istiod - sys'),
    gatewayHeapAllocated:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_go_memstats_heap_alloc_bytes{%(queriesGroupGatewaySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - alloc'),
    gatewayHeapInUse:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_go_memstats_heap_inuse_bytes{%(queriesGroupGatewaySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - inuse'),
    gatewayHeapSystem:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_go_memstats_heap_sys_bytes{%(queriesGroupGatewaySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - sys'),
    proxyHeapAllocated:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_go_memstats_heap_alloc_bytes{%(queriesGroupProxySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - alloc'),
    proxyHeapInUse:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_go_memstats_heap_inuse_bytes{%(queriesGroupProxySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - inuse'),
    proxyHeapSystem:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (istio_agent_go_memstats_heap_sys_bytes{%(queriesGroupProxySelector)s})' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - sys'),
    gatewayHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (rate(istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway'),
    proxyHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (rate(istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy'),
    gatewayHTTPOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - ok'),
    gatewayHTTPErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeErrorFilter: httpResponseCodeErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - error'),
    proxyHTTPOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - ok'),
    proxyHTTPErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeErrorFilter: httpResponseCodeErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - error'),
    pilotCDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeCDSFilter)s})[$__interval:])' % vars { typeCDSFilter: typeCDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - CDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotEDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeEDSFilter)s})[$__interval:])' % vars { typeEDSFilter: typeEDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - EDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotLDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeLDSFilter)s})[$__interval:])' % vars { typeLDSFilter: typeLDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - LDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotRDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeRDSFilter)s})[$__interval:])' % vars { typeRDSFilter: typeRDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - RDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotSDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeSDSFilter)s})[$__interval:])' % vars { typeSDSFilter: typeSDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - SDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotNDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeNDSFilter)s})[$__interval:])' % vars { typeNDSFilter: typeNDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - NDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotxDSProxyPushLatencyBucket:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(le, job, cluster) (increase(pilot_proxy_convergence_time_bucket{%(queriesGroupIstiodSelector)s}[$__range:]))' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}}')
      + panel.histogram.queryOptions.withInterval('1m')
      + prometheusQuery.withInstant(true)
      + prometheusQuery.withFormat('heatmap'),
    galleyValidationsPassed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (galley_validation_passed{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - passed')
      + panel.barGauge.queryOptions.withInterval('1m'),
    galleyValidationsFailed:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (galley_validation_failed{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - failed')
      + panel.barGauge.queryOptions.withInterval('1m'),
    envoyxDSBytesSendRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (rate(envoy_cluster_upstream_cx_rx_bytes_total{%(queriesGroupSelector)s, %(clusterNamexDSGRPCFilter)s}[$__rate_interval]))' % vars { clusterNamexDSGRPCFilter: clusterNamexDSGRPCFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - sent'),
    envoyxDSBytesReceiveRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (rate(envoy_cluster_upstream_cx_tx_bytes_total{%(queriesGroupSelector)s, %(clusterNamexDSGRPCFilter)s}[$__rate_interval]))' % vars { clusterNamexDSGRPCFilter: clusterNamexDSGRPCFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - received'),
    pilotCDSxDSRejections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_cds_reject{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - CDS reject')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pilotEDSxDSRejections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_eds_reject{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - EDS reject')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pilotRDSxDSRejections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_rds_reject{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - RDS reject')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pilotLDSxDSRejections:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_lds_reject{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - LDS reject')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pilotxDSWriteTimeouts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_write_timeout{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - write timeout')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pilotxDSInternalErrors:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_total_xds_internal_errors{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - internal')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pilotxDSProxyRejects:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_total_xds_rejects{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy rejects')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pilotxDSInboundListenerConflicts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_conflict_inbound_listener{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - in listener conflict')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    pilotxDSOutboundListenerTCPConflicts:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_conflict_outbound_listener_tcp_over_current_tcp{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - out listener tcp conflict')
      + panel.timeSeries.queryOptions.withInterval('1m'),
    sidecarInjectionSuccesses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (sidecar_injection_success_total{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - success')
      + panel.barGauge.queryOptions.withInterval('1m'),
    sidecarInjectionFailures:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (sidecar_injection_failure_total{%(queriesGroupIstiodSelector)s})[$__interval:])' % vars
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - failure')
      + panel.barGauge.queryOptions.withInterval('1m'),
    tableSourceServiceHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service) (label_replace(rate(istio_requests_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)"))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    tableDestinationServiceHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service) (label_replace(rate(istio_requests_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)"))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    tableSourceServiceHTTPGRPCRequestLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          sum by(job, cluster, service) (label_replace(increase(istio_request_duration_milliseconds_sum{%(queriesGroupSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"))
          /
          clamp_min(sum by(job, cluster, service) (label_replace(increase(istio_request_duration_milliseconds_count{%(queriesGroupSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)")), 1)
        ||| % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableDestinationServiceHTTPGRPCRequestLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          sum by(job, cluster, service) (label_replace(increase(istio_request_duration_milliseconds_sum{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"))
          /
          clamp_min(sum by(job, cluster, service) (label_replace(increase(istio_request_duration_milliseconds_count{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)")), 1)
        ||| % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableSourceServiceHTTPRequestSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          100 * sum by(job, cluster, service) (label_replace(increase(istio_requests_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"))
          /
          clamp_min(sum by(job, cluster, service) (label_replace(increase(istio_requests_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s, %(requestProtocolHTTPFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)")), 1)
        ||| % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter, requestProtocolHTTPFilter: requestProtocolHTTPFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableDestinationServiceHTTPRequestSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          100 * sum by(job, cluster, service) (label_replace(increase(istio_requests_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeOKFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"))
          /
          clamp_min(sum by(job, cluster, service) (label_replace(increase(istio_requests_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s, %(requestProtocolHTTPFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)")), 1)
        ||| % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter, requestProtocolHTTPFilter: requestProtocolHTTPFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableSourceServiceTCPReceiveRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service) (label_replace(rate(istio_tcp_received_bytes_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)"))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    tableSourceServiceTCPSendRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service) (label_replace(rate(istio_tcp_sent_bytes_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)"))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    clientServiceHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} -> {{destination_canonical_service}}'),
    clientServiceHTTPGRPCAvgRequestDelay:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          sum by(job, cluster, source_canonical_service, destination_canonical_service) (increase(istio_request_duration_milliseconds_sum{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]))
          /
          clamp_min(sum by(job, cluster, source_canonical_service, destination_canonical_service) (increase(istio_request_duration_milliseconds_count{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval:])), 1)
        ||| % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} -> {{destination_canonical_service}}'),
    clientServiceHTTPGRPCRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_request_bytes_sum{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} -> {{destination_canonical_service}}'),
    clientServiceHTTPGRPCResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_response_bytes_sum{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}'),
    clientServiceHTTPOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (ok)'),
    clientServiceHTTPErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeErrorFilter: httpResponseCodeErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (error)'),
    clientServiceHTTP1xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode1xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode1xxFilter: httpResponseCode1xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (1xx)'),
    clientServiceHTTP2xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode2xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode2xxFilter: httpResponseCode2xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (2xx)'),
    clientServiceHTTP3xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode3xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode3xxFilter: httpResponseCode3xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (3xx)'),
    clientServiceHTTP4xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode4xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode4xxFilter: httpResponseCode4xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (4xx)'),
    clientServiceHTTP5xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCode5xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode5xxFilter: httpResponseCode5xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (5xx)'),
    clientServiceGRPCOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusOKFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, grpcResponseStatusOKFilter: grpcResponseStatusOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (ok)'),
    clientServiceGRPCErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusErrorFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, grpcResponseStatusErrorFilter: grpcResponseStatusErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: (error)'),
    clientServiceGRPCResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, grpcResponseStatusFilter: grpcResponseStatusFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}: {{grpc_response_status}}'),
    clientServiceTCPRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_tcp_received_bytes_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} -> {{destination_canonical_service}}'),
    clientServiceTCPResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_tcp_sent_bytes_total{%(queriesGroupClientServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_canonical_service}} <- {{destination_canonical_service}}'),
    serverServiceHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} <- {{source_canonical_service}}'),
    serverServiceHTTPGRPCAvgRequestDelay:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          sum by(job, cluster, source_canonical_service, destination_canonical_service) (increase(istio_request_duration_milliseconds_sum{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]))
          /
          clamp_min(sum by(job, cluster, source_canonical_service, destination_canonical_service) (increase(istio_request_duration_milliseconds_count{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:])), 1)
        ||| % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} <- {{source_canonical_service}}'),
    serverServiceHTTPGRPCRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_request_bytes_sum{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} <- {{source_canonical_service}}'),
    serverServiceHTTPGRPCResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_response_bytes_sum{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}'),
    serverServiceHTTPOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeOKFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (ok)'),
    serverServiceHTTPErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeErrorFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCodeErrorFilter: httpResponseCodeErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (error)'),
    serverServiceHTTP1xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode1xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode1xxFilter: httpResponseCode1xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (1xx)'),
    serverServiceHTTP2xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode2xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode2xxFilter: httpResponseCode2xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (2xx)'),
    serverServiceHTTP3xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode3xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode3xxFilter: httpResponseCode3xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (3xx)'),
    serverServiceHTTP4xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode4xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode4xxFilter: httpResponseCode4xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (4xx)'),
    serverServiceHTTP5xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode5xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode5xxFilter: httpResponseCode5xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (5xx)'),
    serverServiceGRPCOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusOKFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, grpcResponseStatusOKFilter: grpcResponseStatusOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (ok)'),
    serverServiceGRPCErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusErrorFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, grpcResponseStatusErrorFilter: grpcResponseStatusErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: (error)'),
    serverServiceGRPCResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_canonical_service, destination_canonical_service) (istio_requests_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, grpcResponseStatusFilter: grpcResponseStatusFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}: {{grpc_response_status}}'),
    serverServiceTCPRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_tcp_received_bytes_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} <- {{source_canonical_service}}'),
    serverServiceTCPResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_canonical_service, destination_canonical_service) (rate(istio_tcp_sent_bytes_total{%(queriesGroupServerServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_canonical_service}} -> {{source_canonical_service}}'),
    tableSourceWorkloadHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service, workload) (label_replace(label_replace(rate(istio_requests_total{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)"))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    tableDestinationWorkloadHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service, workload) (label_replace(label_replace(rate(istio_requests_total{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)"))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    tableSourceWorkloadHTTPGRPCRequestLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_request_duration_milliseconds_sum{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)"))
          /
          clamp_min(sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_request_duration_milliseconds_count{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)")), 1)
        ||| % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableDestinationWorkloadHTTPGRPCRequestLatency:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_request_duration_milliseconds_sum{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)"))
          /
          clamp_min(sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_request_duration_milliseconds_count{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)")), 1)
        ||| % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableSourceWorkloadHTTPRequestSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          100 * sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_requests_total{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)"))
          /
          clamp_min(sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_requests_total{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s, %(requestProtocolHTTPFilter)s}[$__rate_interval:]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)")), 1)
        ||| % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter, requestProtocolHTTPFilter: requestProtocolHTTPFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableDestinationWorkloadHTTPRequestSuccessRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          100 * sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_requests_total{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeOKFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)"))
          /
          clamp_min(sum by(job, cluster, service, workload) (label_replace(label_replace(increase(istio_requests_total{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s, %(requestProtocolHTTPFilter)s}[$__rate_interval:]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)")), 1)
        ||| % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter, requestProtocolHTTPFilter: requestProtocolHTTPFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableSourceWorkloadTCPRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service, workload) (label_replace(label_replace(rate(istio_tcp_received_bytes_total{%(queriesGroupSourceServiceSelector)s, %(reporterSourceFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)"), "workload", "$1", "source_workload", "(.*)"))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    tableDestinationWorkloadTCPResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service, workload) (label_replace(label_replace(rate(istio_tcp_sent_bytes_total{%(queriesGroupDestinationServiceSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)"), "workload", "$1", "destination_workload", "(.*)"))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    clientWorkloadHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_workload}} -> {{destination_workload}}'),
    clientWorkloadHTTPGRPCAvgRequestDelay:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          sum by(job, cluster, source_workload, destination_workload) (increase(istio_request_duration_milliseconds_sum{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval:]))
          /
          clamp_min(sum by(job, cluster, source_workload, destination_workload) (increase(istio_request_duration_milliseconds_count{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval:])), 1)
        ||| % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} -> {{destination_workload}}'),
    clientWorkloadHTTPGRPCRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_request_bytes_sum{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_workload}} -> {{destination_workload}}'),
    clientWorkloadHTTPGRPCResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_response_bytes_sum{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}'),
    clientWorkloadHTTPOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (ok)'),
    clientWorkloadHTTPErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCodeErrorFilter: httpResponseCodeErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (error)'),
    clientWorkloadHTTP1xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode1xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode1xxFilter: httpResponseCode1xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (1xx)'),
    clientWorkloadHTTP2xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode2xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode2xxFilter: httpResponseCode2xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (2xx)'),
    clientWorkloadHTTP3xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode3xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode3xxFilter: httpResponseCode3xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (3xx)'),
    clientWorkloadHTTP4xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode4xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode4xxFilter: httpResponseCode4xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (4xx)'),
    clientWorkloadHTTP5xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(httpResponseCode5xxFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, httpResponseCode5xxFilter: httpResponseCode5xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (5xx)'),
    clientWorkloadGRPCOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusOKFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, grpcResponseStatusOKFilter: grpcResponseStatusOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (ok)'),
    clientWorkloadGRPCErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusErrorFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, grpcResponseStatusErrorFilter: grpcResponseStatusErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: (error)'),
    clientWorkloadGRPCResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s, %(grpcResponseStatusFilter)s})[$__interval:])' % vars { reporterSourceFilter: reporterSourceFilter, grpcResponseStatusFilter: grpcResponseStatusFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}: {{grpc_response_status}}'),
    clientWorkloadTCPRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_tcp_received_bytes_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_workload}} -> {{destination_workload}}'),
    clientWorkloadTCPResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_tcp_sent_bytes_total{%(queriesGroupClientWorkloadSelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{source_workload}} <- {{destination_workload}}'),
    serverWorkloadHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_workload}} <- {{source_workload}}'),
    serverWorkloadHTTPGRPCAvgRequestDelay:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        |||
          sum by(job, cluster, source_workload, destination_workload) (increase(istio_request_duration_milliseconds_sum{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:]))
          /
          clamp_min(sum by(job, cluster, source_workload, destination_workload) (increase(istio_request_duration_milliseconds_count{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval:])), 1)
        ||| % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} <- {{source_workload}}'),
    serverWorkloadHTTPGRPCRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_request_bytes_sum{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_workload}} <- {{source_workload}}'),
    serverWorkloadHTTPGRPCResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_response_bytes_sum{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}'),
    serverWorkloadHTTPOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeOKFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCodeOKFilter: httpResponseCodeOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (ok)'),
    serverWorkloadHTTPErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCodeErrorFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCodeErrorFilter: httpResponseCodeErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (error)'),
    serverWorkloadHTTP1xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode1xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode1xxFilter: httpResponseCode1xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (1xx)'),
    serverWorkloadHTTP2xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode2xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode2xxFilter: httpResponseCode2xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (2xx)'),
    serverWorkloadHTTP3xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode3xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode3xxFilter: httpResponseCode3xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (3xx)'),
    serverWorkloadHTTP4xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode4xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode4xxFilter: httpResponseCode4xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (4xx)'),
    serverWorkloadHTTP5xxResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(httpResponseCode5xxFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, httpResponseCode5xxFilter: httpResponseCode5xxFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (5xx)'),
    serverWorkloadGRPCOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusOKFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, grpcResponseStatusOKFilter: grpcResponseStatusOKFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (ok)'),
    serverWorkloadGRPCErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusErrorFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, grpcResponseStatusErrorFilter: grpcResponseStatusErrorFilter }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: (error)'),
    serverWorkloadGRPCResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster, source_workload, destination_workload) (istio_requests_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s, %(grpcResponseStatusFilter)s})[$__interval:])' % vars { reporterDestinationFilter: reporterDestinationFilter, grpcResponseStatusFilter: grpcResponseStatusFilter }
      )
      + panel.timeSeries.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}: {{grpc_response_status}}'),
    serverWorkloadTCPRequestThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_tcp_received_bytes_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_workload}} <- {{source_workload}}'),
    serverWorkloadTCPResponseThroughputRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, source_workload, destination_workload) (rate(istio_tcp_sent_bytes_total{%(queriesGroupServerWorkloadSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]))' % vars { reporterDestinationFilter: reporterDestinationFilter }
      )
      + prometheusQuery.withLegendFormat('{{destination_workload}} -> {{source_workload}}'),

    // add more metrics or loki queries as targets below:

  },
}
