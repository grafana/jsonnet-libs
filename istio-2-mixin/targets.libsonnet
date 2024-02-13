local g = import './g.libsonnet';
local prometheusQuery = g.query.prometheus;
local lokiQuery = g.query.loki;

{
  new(this): {
    local vars = this.grafana.variables,
    local config = this.config,
    local panel = g.panel,

    proxyCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'count by(job, cluster) (istio_build{%(queriesGroupSelector)s, %(componentProxyFilter)s})' % vars { componentProxyFilter: config.componentProxyFilter }
      ),
    gatewayCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeGatewayFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeGatewayFilter)s, %(eventDeleteFilter)s}) or max(up * 0))' % config { queriesGroupSelector: vars.queriesGroupSelector }
      ),
    virtualServiceCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeVirtualServiceFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeVirtualServiceFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % config { queriesGroupSelector: vars.queriesGroupSelector }
      ),
    destinationRuleCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeDestinationRuleFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeDestinationRuleFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % config { queriesGroupSelector: vars.queriesGroupSelector }
      ),
    serviceEntryCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeServiceEntryFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeServiceEntryFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % config { queriesGroupSelector: vars.queriesGroupSelector }
      ),
    workloadEntryCount:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeWorkloadEntryFilter)s, %(eventAddFilter)s}) - (max(pilot_k8s_cfg_events{%(queriesGroupSelector)s, %(typeWorkloadEntryFilter)s, %(eventDeleteFilter)s}) or (max(up) * 0))' % config { queriesGroupSelector: vars.queriesGroupSelector }
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
        'sum by(job, cluster) (rate(istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: config.reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway'),
    proxyHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (rate(istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s}[$__rate_interval]))' % vars { reporterSourceFilter: config.reporterSourceFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy'),
    gatewayHTTPOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s})[$__interval:])' % config { queriesGroupGatewaySelector: vars.queriesGroupGatewaySelector }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - ok'),
    gatewayHTTPErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (istio_requests_total{%(queriesGroupGatewaySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s})[$__interval:])' % config { queriesGroupGatewaySelector: vars.queriesGroupGatewaySelector }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}} - gateway - error'),
    proxyHTTPOKResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeOKFilter)s})[$__interval:])' % config { queriesGroupProxySelector: vars.queriesGroupProxySelector }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - ok'),
    proxyHTTPErrorResponses:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by(job, cluster) (istio_requests_total{%(queriesGroupProxySelector)s, %(reporterSourceFilter)s, %(httpResponseCodeErrorFilter)s})[$__interval:])' % config { queriesGroupProxySelector: vars.queriesGroupProxySelector }
      )
      + panel.pieChart.queryOptions.withInterval('1m')
      + prometheusQuery.withLegendFormat('{{cluster}} - proxy - error'),
    pilotCDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeCDSFilter)s})[$__interval:])' % vars { typeCDSFilter: config.typeCDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - CDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotEDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeEDSFilter)s})[$__interval:])' % vars { typeEDSFilter: config.typeEDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - EDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotLDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeLDSFilter)s})[$__interval:])' % vars { typeLDSFilter: config.typeLDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - LDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotRDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeRDSFilter)s})[$__interval:])' % vars { typeRDSFilter: config.typeRDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - RDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotSDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeSDSFilter)s})[$__interval:])' % vars { typeSDSFilter: config.typeSDSFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - SDS')
      + panel.barGauge.queryOptions.withInterval('1m'),
    pilotNDSxDSPushes:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'increase(sum by (job, cluster) (pilot_xds_pushes{%(queriesGroupIstiodSelector)s, %(typeNDSFilter)s})[$__interval:])' % vars { typeNDSFilter: config.typeNDSFilter }
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
        'sum by(job, cluster) (rate(envoy_cluster_upstream_cx_rx_bytes_total{%(queriesGroupSelector)s, %(clusterNamexDSGRPCFilter)s}[$__rate_interval]))' % vars { clusterNamexDSGRPCFilter: config.clusterNamexDSGRPCFilter }
      )
      + prometheusQuery.withLegendFormat('{{cluster}} - sent'),
    envoyxDSBytesReceiveRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster) (rate(envoy_cluster_upstream_cx_tx_bytes_total{%(queriesGroupSelector)s, %(clusterNamexDSGRPCFilter)s}[$__rate_interval]))' % vars { clusterNamexDSGRPCFilter: config.clusterNamexDSGRPCFilter }
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
        'sum by(job, cluster, service) (label_replace(rate(istio_requests_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)"))' % vars { reporterSourceFilter: config.reporterSourceFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    tableDestinationServiceHTTPGRPCRequestRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service) (label_replace(rate(istio_requests_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]), "service", "$1", "destination_canonical_service", "(.*)"))' % vars { reporterDestinationFilter: config.reporterDestinationFilter }
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
        ||| % vars { reporterSourceFilter: config.reporterSourceFilter }
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
        ||| % vars { reporterDestinationFilter: config.reporterDestinationFilter }
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
        ||| % config { queriesGroupSelector: vars.queriesGroupSelector }
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
        ||| % config { queriesGroupSelector: vars.queriesGroupSelector }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true)
      + panel.table.queryOptions.withInterval('1m'),
    tableSourceServiceTCPReceiveRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service) (label_replace(rate(istio_tcp_received_bytes_total{%(queriesGroupSelector)s, %(reporterSourceFilter)s}[$__rate_interval]), "service", "$1", "source_canonical_service", "(.*)"))' % vars { reporterSourceFilter: config.reporterSourceFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),
    tableSourceServiceTCPSendRate:
      prometheusQuery.new(
        '${' + vars.datasources.prometheus.name + '}',
        'sum by(job, cluster, service) (label_replace(rate(istio_tcp_sent_bytes_total{%(queriesGroupSelector)s, %(reporterDestinationFilter)s}[$__rate_interval]), "service", "$1", "destination_service_name", "(.*)"))' % vars { reporterDestinationFilter: config.reporterDestinationFilter }
      )
      + prometheusQuery.withFormat('table')
      + prometheusQuery.withInstant(true),

    // add more metrics or loki queries as targets below:

  },
}
