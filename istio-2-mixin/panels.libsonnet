local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local signals = this.signals,
      local prometheusQuery = g.query.prometheus,
      local alertList = g.panel.alertList,
      local stat = g.panel.stat,
      local timeSeries = g.panel.timeSeries,
      local pieChart = g.panel.pieChart,
      local barGauge = g.panel.barGauge,
      local table = g.panel.table,
      local histogram = g.panel.histogram,

      alertsPanel:
        alertList.new('Istio alerts')
        + alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesGroupSelectorAdvanced),

      proxies:
        commonlib.panels.generic.stat.base.new(
          'Proxies',
          targets=[signals.overview.proxyCount.asTarget()],
          description='Number of proxies in the Istio system.',
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.color.withMode('thresholds')
        + stat.standardOptions.thresholds.withSteps([
          stat.thresholdStep.withColor('super-light-red')
          + stat.thresholdStep.withValue(null),
          stat.thresholdStep.withColor('super-light-green')
          + stat.thresholdStep.withValue(1),
        ]),
      gateways:
        commonlib.panels.generic.stat.base.new(
          'Gateways',
          targets=[signals.overview.gatewayCount.asTarget()],
          description='Number of gateways in the Istio system.',
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.color.withMode('thresholds')
        + stat.standardOptions.thresholds.withSteps([
          stat.thresholdStep.withColor('text')
          + stat.thresholdStep.withValue(null),
          stat.thresholdStep.withColor('super-light-green')
          + stat.thresholdStep.withValue(1),
        ]),
      virtualServices:
        commonlib.panels.generic.stat.base.new(
          'Virtual services',
          targets=[signals.overview.virtualServiceCount.asTarget()],
          description='Number of virtual services in the Istio system.',
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.color.withMode('thresholds')
        + stat.standardOptions.thresholds.withSteps([
          stat.thresholdStep.withColor('text')
          + stat.thresholdStep.withValue(null),
          stat.thresholdStep.withColor('super-light-green')
          + stat.thresholdStep.withValue(1),
        ]),
      destinationRules:
        commonlib.panels.generic.stat.base.new(
          'Destination rules',
          targets=[signals.overview.destinationRuleCount.asTarget()],
          description='Number of destination rules in the Istio system.',
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.color.withMode('thresholds')
        + stat.standardOptions.thresholds.withSteps([
          stat.thresholdStep.withColor('super-light-orange')
          + stat.thresholdStep.withValue(null),
          stat.thresholdStep.withColor('super-light-green')
          + stat.thresholdStep.withValue(1),
        ]),
      serviceEntries:
        commonlib.panels.generic.stat.base.new(
          'Service entries',
          targets=[signals.overview.serviceEntryCount.asTarget()],
          description='Number of service entries in the Istio system.',
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.color.withMode('thresholds')
        + stat.standardOptions.thresholds.withSteps([
          stat.thresholdStep.withColor('text')
          + stat.thresholdStep.withValue(null),
          stat.thresholdStep.withColor('super-light-green')
          + stat.thresholdStep.withValue(1),
        ]),
      workloadEntries:
        commonlib.panels.generic.stat.base.new(
          'Workload entries',
          targets=[signals.overview.workloadEntryCount.asTarget()],
          description='Number of workload entries in the Istio system.',
        )
        + stat.options.withGraphMode('none')
        + stat.standardOptions.color.withMode('thresholds')
        + stat.standardOptions.thresholds.withSteps([
          stat.thresholdStep.withColor('text')
          + stat.thresholdStep.withValue(null),
          stat.thresholdStep.withColor('super-light-green')
          + stat.thresholdStep.withValue(1),
        ]),

      vCPUUsage:
        commonlib.panels.generic.timeSeries.base.new(
          'vCPU usage',
          targets=[
            signals.overview.istiodCPUUsage.asTarget(),
            signals.overview.gatewayCPUUsage.asTarget(),
            signals.overview.proxyCPUUsage.asTarget(),
          ],
          description='vCPU usage for various components of the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        })
        + timeSeries.standardOptions.withUnit('percentunit'),
      openFileDescriptors:
        commonlib.panels.generic.timeSeries.base.new(
          'Open file descriptors',
          targets=[
            signals.overview.istiodOpenFileDescriptors.asTarget(),
            signals.overview.gatewayOpenFileDescriptors.asTarget(),
            signals.overview.proxyOpenFileDescriptors.asTarget(),
          ],
          description='Number of open file descriptors for various components of the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      virtualAndResidentMemory:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Virtual & resident memory',
          targets=[
            signals.overview.istiodVirtualMemory.asTarget(),
            signals.overview.istiodResidentMemory.asTarget(),
            signals.overview.gatewayVirtualMemory.asTarget(),
            signals.overview.gatewayResidentMemory.asTarget(),
            signals.overview.proxyVirtualMemory.asTarget(),
            signals.overview.proxyResidentMemory.asTarget(),
          ],
          description='Available virtual memory compared to the resident memory for the various components of the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.fieldConfig.defaults.custom.withScaleDistributionMixin({
          log: 2,
          type: 'log',
        })
        + timeSeries.standardOptions.withUnit('bytes'),
      heapMemory:
        commonlib.panels.memory.timeSeries.usageBytes.new(
          'Heap memory',
          targets=[
            signals.overview.istiodHeapAllocated.asTarget(),
            signals.overview.istiodHeapInUse.asTarget(),
            signals.overview.istiodHeapSystem.asTarget(),
            signals.overview.gatewayHeapAllocated.asTarget(),
            signals.overview.gatewayHeapInUse.asTarget(),
            signals.overview.gatewayHeapSystem.asTarget(),
            signals.overview.proxyHeapAllocated.asTarget(),
            signals.overview.proxyHeapInUse.asTarget(),
            signals.overview.proxyHeapSystem.asTarget(),
          ],
          description='Heap memory information for the various components of the Istio system.',
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.standardOptions.withUnit('bytes'),
      httpGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests',
          targets=[
            signals.overview.gatewayHTTPGRPCRequestRate.asTarget(),
            signals.overview.proxyHTTPGRPCRequestRate.asTarget(),
          ],
          description='HTTP/GRPC request rate for the components of the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        })
        + timeSeries.standardOptions.withUnit('reqps'),
      xDSEnvoyThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'xDS envoy throughput',
          targets=[
            signals.controlplane.envoyxDSBytesSendRate.asTarget(),
            signals.controlplane.envoyxDSBytesReceiveRate.asTarget(),
          ],
          description='The send and receive data rates from all envoy proxies in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps'),
      xDSErrors:
        commonlib.panels.generic.timeSeries.base.new(
          'xDS errors / $__interval',
          targets=[
            signals.controlplane.pilotCDSxDSRejections.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.controlplane.pilotEDSxDSRejections.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.controlplane.pilotRDSxDSRejections.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.controlplane.pilotLDSxDSRejections.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.controlplane.pilotxDSWriteTimeouts.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.controlplane.pilotxDSInternalErrors.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.controlplane.pilotxDSProxyRejects.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.controlplane.pilotxDSInboundListenerConflicts.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.controlplane.pilotxDSOutboundListenerTCPConflicts.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The xDS related errors across the Istio system.'
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean']),
      clientServiceHTTPGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests sent',
          targets=[
            signals.services.clientServiceHTTPGRPCRequestRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC requests sent from this service to server services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('reqps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceHTTPGRPCRequestDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request delay',
          targets=[
            signals.services.clientServiceHTTPGRPCAvgRequestDelay.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='Average latency of HTTP/GRPC requests sent from this service to server services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('ms'),
      clientServiceHTTPGRPCRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request throughput',
          targets=[
            signals.services.clientServiceHTTPGRPCRequestThroughputRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC request data sent from this service to server services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceHTTPGRPCResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC response throughput',
          targets=[
            signals.services.clientServiceHTTPGRPCResponseThroughputRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC response data received by this service from server services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            signals.services.clientServiceHTTP1xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.services.clientServiceHTTP2xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.services.clientServiceHTTP3xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.services.clientServiceHTTP4xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.services.clientServiceHTTP5xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The types of HTTP responses received by this service from server services in the Istio system.',
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceGRPCResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'GRPC responses / $__interval',
          targets=[
            signals.services.clientServiceGRPCResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The types of GRPC responses received by this service from server services in the Istio system.'
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceTCPRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP request throughput',
          targets=[
            signals.services.clientServiceTCPRequestThroughputRate.asTarget(),
          ],
          description='Rate of TCP request data sent from this service to server services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceTCPResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP response throughput',
          targets=[
            signals.services.clientServiceTCPResponseThroughputRate.asTarget(),
          ],
          description='Rate of TCP response data received by this service from server services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceHTTPGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests received',
          targets=[
            signals.services.serverServiceHTTPGRPCRequestRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC requests received by this service from client services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('reqps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceHTTPGRPCRequestDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request delay',
          targets=[
            signals.services.serverServiceHTTPGRPCAvgRequestDelay.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='Average latency of HTTP/GRPC requests received by this service from client services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('ms'),
      serverServiceHTTPGRPCRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request throughput',
          targets=[
            signals.services.serverServiceHTTPGRPCRequestThroughputRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC request data received by this service from client services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceHTTPGRPCResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC response throughput',
          targets=[
            signals.services.serverServiceHTTPGRPCResponseThroughputRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC response data sent from this service to client services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            signals.services.serverServiceHTTP1xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.services.serverServiceHTTP2xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.services.serverServiceHTTP3xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.services.serverServiceHTTP4xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.services.serverServiceHTTP5xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The types of HTTP responses sent from this service to client services in the Istio system.',
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceGRPCResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'GRPC responses / $__interval',
          targets=[
            signals.services.serverServiceGRPCResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The types of GRPC responses sent from this service to client services in the Istio system.',
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceTCPRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP request throughput',
          targets=[
            signals.services.serverServiceTCPRequestThroughputRate.asTarget(),
          ],
          description='Rate of TCP request data received by this service from client services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceTCPResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP response throughput',
          targets=[
            signals.services.serverServiceTCPResponseThroughputRate.asTarget(),
          ],
          description='Rate of TCP response data sent from this service to client services in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadHTTPGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests sent',
          targets=[
            signals.workloads.clientWorkloadHTTPGRPCRequestRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC requests sent from this workload to server workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('reqps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadHTTPGRPCRequestDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request delay',
          targets=[
            signals.workloads.clientWorkloadHTTPGRPCAvgRequestDelay.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='Average latency of HTTP/GRPC requests sent from this workload to server workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('ms'),
      clientWorkloadHTTPGRPCRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request throughput',
          targets=[
            signals.workloads.clientWorkloadHTTPGRPCRequestThroughputRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC request data sent from this workload to server workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadHTTPGRPCResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC response throughput',
          targets=[
            signals.workloads.clientWorkloadHTTPGRPCResponseThroughputRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC response data received by this workload from server workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            signals.workloads.clientWorkloadHTTP1xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.workloads.clientWorkloadHTTP2xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.workloads.clientWorkloadHTTP3xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.workloads.clientWorkloadHTTP4xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.workloads.clientWorkloadHTTP5xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The types of HTTP responses received by this workload from server workloads in the Istio system.',
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadGRPCResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'GRPC responses / $__interval',
          targets=[
            signals.workloads.clientWorkloadGRPCResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The types of GRPC responses received by this workload from server workloads in the Istio system.',
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadTCPRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP request throughput',
          targets=[
            signals.workloads.clientWorkloadTCPRequestThroughputRate.asTarget(),
          ],
          description='Rate of TCP request data sent from this workload to server workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadTCPResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP response throughput',
          targets=[
            signals.workloads.clientWorkloadTCPResponseThroughputRate.asTarget(),
          ],
          description='Rate of TCP response data received by this workload from server workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadHTTPGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests received',
          targets=[
            signals.workloads.serverWorkloadHTTPGRPCRequestRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC requests received by this workload from client workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('reqps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadHTTPGRPCRequestDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request delay',
          targets=[
            signals.workloads.serverWorkloadHTTPGRPCAvgRequestDelay.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='Average latency of HTTP/GRPC requests received by this workload from client workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('ms'),
      serverWorkloadHTTPGRPCRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request throughput',
          targets=[
            signals.workloads.serverWorkloadHTTPGRPCRequestThroughputRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC request data received by this workload from client workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadHTTPGRPCResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC response throughput',
          targets=[
            signals.workloads.serverWorkloadHTTPGRPCResponseThroughputRate.asTarget(),
          ],
          description='Rate of HTTP/GRPC response data sent from this workload to client workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            signals.workloads.serverWorkloadHTTP1xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.workloads.serverWorkloadHTTP2xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.workloads.serverWorkloadHTTP3xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.workloads.serverWorkloadHTTP4xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
            signals.workloads.serverWorkloadHTTP5xxResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The types of HTTP responses sent from this workload to client workloads in the Istio system.',
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadGRPCResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'GRPC responses / $__interval',
          targets=[
            signals.workloads.serverWorkloadGRPCResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          ],
          description='The types of GRPC responses sent from this workload to client workloads in the Istio system.',
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadTCPRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP request throughput',
          targets=[
            signals.workloads.serverWorkloadTCPRequestThroughputRate.asTarget(),
          ],
          description='Rate of TCP request data received by this workload from client workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadTCPResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP response throughput',
          targets=[
            signals.workloads.serverWorkloadTCPResponseThroughputRate.asTarget(),
          ],
          description='Rate of TCP response data sent from this workload to client workloads in the Istio system.',
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),

      httpResponseOverview:
        pieChart.new(title='HTTP response overview')
        + pieChart.queryOptions.withTargets([
          signals.overview.gatewayHTTPOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.overview.gatewayHTTPErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.overview.proxyHTTPOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.overview.proxyHTTPErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Recent number of successful (1xx, 2xx, 3xx) vs error (4xx, 5xx) HTTP responses received by various components of the Istio system.'),
      clientServiceHTTPResponseOverview:
        pieChart.new(title='HTTP response overview')
        + pieChart.queryOptions.withTargets([
          signals.services.clientServiceHTTPOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.services.clientServiceHTTPErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Overview of the types of HTTP responses received by this service from server services in the Istio system.'),
      clientServiceGRPCResponseOverview:
        pieChart.new(title='GRPC response overview')
        + pieChart.queryOptions.withTargets([
          signals.services.clientServiceGRPCOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.services.clientServiceGRPCErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Overview of the types of GRPC responses received by this service from server services in the Istio system.'),
      serverServiceHTTPResponseOverview:
        pieChart.new(title='HTTP response overview')
        + pieChart.queryOptions.withTargets([
          signals.services.serverServiceHTTPOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.services.serverServiceHTTPErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Overview of the types of HTTP responses sent from this service to client services in the Istio system.'),
      serverServiceGRPCResponseOverview:
        pieChart.new(title='GRPC response overview')
        + pieChart.queryOptions.withTargets([
          signals.services.serverServiceGRPCOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.services.serverServiceGRPCErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Overview of the types of GRPC responses sent from this service to client services in the Istio system.'),
      clientWorkloadHTTPResponseOverview:
        pieChart.new(title='HTTP response overview')
        + pieChart.queryOptions.withTargets([
          signals.workloads.clientWorkloadHTTPOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.workloads.clientWorkloadHTTPErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Overview of the types of HTTP responses received by this workload from server workloads in the Istio system.'),
      clientWorkloadGRPCResponseOverview:
        pieChart.new(title='GRPC response overview')
        + pieChart.queryOptions.withTargets([
          signals.workloads.clientWorkloadGRPCOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.workloads.clientWorkloadGRPCErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Overview of the types of GRPC responses received by this workload from server workloads in the Istio system.'),
      serverWorkloadHTTPResponseOverview:
        pieChart.new(title='HTTP response overview')
        + pieChart.queryOptions.withTargets([
          signals.workloads.serverWorkloadHTTPOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.workloads.serverWorkloadHTTPErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Overview of the types of HTTP responses sent from this workload to client workloads in the Istio system.'),
      serverWorkloadGRPCResponseOverview:
        pieChart.new(title='GRPC response overview')
        + pieChart.queryOptions.withTargets([
          signals.workloads.serverWorkloadGRPCOKResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.workloads.serverWorkloadGRPCErrorResponses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + pieChart.panelOptions.withDescription('Overview of the types of GRPC responses sent from this workload to client workloads in the Istio system.'),

      xDSPushes:
        barGauge.new(title='xDS pushes')
        + barGauge.queryOptions.withTargets([
          signals.controlplane.pilotCDSxDSPushes.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.controlplane.pilotEDSxDSPushes.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.controlplane.pilotLDSxDSPushes.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.controlplane.pilotRDSxDSPushes.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.controlplane.pilotSDSxDSPushes.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.controlplane.pilotNDSxDSPushes.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + barGauge.queryOptions.withDatasource('prometheus', '${datasource}',)
        + barGauge.panelOptions.withDescription('Number of xDS pushes by Istiod over the entire time range for the Istio system.')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + barGauge.options.withOrientation('horizontal')
        + barGauge.options.reduceOptions.withCalcs(['sum']),
      galleyValidations:
        barGauge.new(title='Galley validations')
        + barGauge.queryOptions.withTargets([
          signals.controlplane.galleyValidationsPassed.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.controlplane.galleyValidationsFailed.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + barGauge.queryOptions.withDatasource('prometheus', '${datasource}')
        + barGauge.panelOptions.withDescription('Number of galley validations over the entire time range for the Istio system.')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + barGauge.options.withOrientation('horizontal')
        + barGauge.options.reduceOptions.withCalcs(['sum']),
      sidecarInjections:
        barGauge.new(title='Sidecar injections')
        + barGauge.queryOptions.withTargets([
          signals.controlplane.sidecarInjectionSuccesses.asTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.controlplane.sidecarInjectionFailures.asTarget() + timeSeries.queryOptions.withInterval('1m'),
        ])
        + barGauge.queryOptions.withDatasource('prometheus', '${datasource}')
        + barGauge.panelOptions.withDescription('Number of sidecar injections over the entire time range for the Istio system.')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + barGauge.options.withOrientation('horizontal')
        + barGauge.options.reduceOptions.withCalcs(['sum']),

      xDSPushDelay:
        histogram.new(title='xDS push delay (s)')
        + histogram.queryOptions.withTargets([
          signals.controlplane.pilotxDSProxyPushLatencyBucket.asTarget() + timeSeries.queryOptions.withInterval('1m') + prometheusQuery.withInstant(true) + prometheusQuery.withFormat('heatmap'),
        ])
        + histogram.queryOptions.withDatasource('prometheus', '${datasource}')
        + histogram.options.legend.withPlacement('right')
        + histogram.standardOptions.color.withMode('thresholds')
        + histogram.standardOptions.thresholds.withSteps([
          histogram.thresholdStep.withColor('super-light-green'),
        ])
        + histogram.panelOptions.withDescription('The latency of xDS pushes by Istiod over the entire time range for the Istio system.'),

      services:
        table.new(
          title='Services'
        )
        + table.queryOptions.withTargets([
          signals.services.tableSourceServiceHTTPGRPCRequestRate.asTableTarget(),
          signals.services.tableDestinationServiceHTTPGRPCRequestRate.asTableTarget(),
          signals.services.tableSourceServiceHTTPGRPCRequestLatency.asTableTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.services.tableDestinationServiceHTTPGRPCRequestLatency.asTableTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.services.tableSourceServiceHTTPRequestSuccessRate.asTableTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.services.tableDestinationServiceHTTPRequestSuccessRate.asTableTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.services.tableSourceServiceTCPReceiveRate.asTableTarget(),
          signals.services.tableSourceServiceTCPSendRate.asTableTarget(),
        ])
        + table.queryOptions.withDatasource('prometheus', '${datasource}')
        + table.panelOptions.withDescription('Service details for the Istio system.')
        + table.standardOptions.withNoValue('NA')
        + table.standardOptions.withOverridesMixin([
          table.fieldOverride.byName.new('job')
          + table.fieldOverride.byName.withProperty('custom.hidden', 'true'),
          table.fieldOverride.byName.new('Service')
          + table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/istio-services-overview?var-datasource=${datasource}&var-job=${__data.fields["Job"]}&var-cluster=${__data.fields["Cluster"]}&var-service=${__value.raw}&${__url_time_range}',
            },
          ]),
          table.fieldOverride.byName.new('HTTP/GRPC tx delay')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'ms'),
          table.fieldOverride.byName.new('HTTP/GRPC rx delay')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'ms'),
          table.fieldOverride.byName.new('HTTP/GRPC tx')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'reqps'),
          table.fieldOverride.byName.new('HTTP/GRPC rx')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'reqps'),
          table.fieldOverride.byName.new('HTTP tx success')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'percent'),
          table.fieldOverride.byName.new('HTTP rx success')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'percent'),
          table.fieldOverride.byName.new('TCP tx')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'Bps'),
          table.fieldOverride.byName.new('TCP rx')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'Bps'),
        ])
        + table.options.withFooter(
          table.options.footer.TableFooterOptions.withReducerMixin(['sum'])
        )
        + table.queryOptions.withTransformationsMixin([
          {
            id: 'merge',
            options: {},
          },
          {
            id: 'organize',
            options: {
              excludeByName: {
                Time: true,
              },
              includeByName: {},
              indexByName: {
                Time: 0,
                'Value #Source service HTTP/GRPC request rate': 4,
                'Value #Destination service HTTP/GRPC request rate': 7,
                'Value #Source service HTTP/GRPC request latency': 5,
                'Value #Destination service HTTP/GRPC request latency': 8,
                'Value #Source service HTTP request success rate': 6,
                'Value #Destination service HTTP request success rate': 9,
                'Value #Source service TCP receive rate': 10,
                'Value #Source service TCP send rate': 11,
                cluster: 1,
                job: 2,
                service: 3,
              },
              renameByName: {
                'Value #Source service HTTP/GRPC request rate': 'HTTP/GRPC tx',
                'Value #Destination service HTTP/GRPC request rate': 'HTTP/GRPC rx',
                'Value #Source service HTTP/GRPC request latency': 'HTTP/GRPC tx delay',
                'Value #Destination service HTTP/GRPC request latency': 'HTTP/GRPC rx delay',
                'Value #Source service HTTP request success rate': 'HTTP tx success',
                'Value #Destination service HTTP request success rate': 'HTTP rx success',
                'Value #Source service TCP receive rate': 'TCP tx',
                'Value #Source service TCP send rate': 'TCP rx',
                cluster: 'Cluster',
                job: 'Job',
                service: 'Service',
              },
            },
          },
        ]),
      workloads:
        table.new(
          title='Workloads'
        )
        + table.queryOptions.withTargets([
          signals.workloads.tableSourceWorkloadHTTPGRPCRequestRate.asTableTarget(),
          signals.workloads.tableDestinationWorkloadHTTPGRPCRequestRate.asTableTarget(),
          signals.workloads.tableSourceWorkloadHTTPGRPCRequestLatency.asTableTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.workloads.tableDestinationWorkloadHTTPGRPCRequestLatency.asTableTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.workloads.tableSourceWorkloadHTTPRequestSuccessRate.asTableTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.workloads.tableDestinationWorkloadHTTPRequestSuccessRate.asTableTarget() + timeSeries.queryOptions.withInterval('1m'),
          signals.workloads.tableSourceWorkloadTCPRequestThroughputRate.asTableTarget(),
          signals.workloads.tableDestinationWorkloadTCPResponseThroughputRate.asTableTarget(),
        ])
        + table.queryOptions.withDatasource('prometheus', '${datasource}')
        + table.panelOptions.withDescription('Workload details for a service in the Istio system.')
        + table.standardOptions.withNoValue('NA')
        + table.standardOptions.withOverridesMixin([
          table.fieldOverride.byName.new('job')
          + table.fieldOverride.byName.withProperty('custom.hidden', 'true'),
          table.fieldOverride.byName.new('Service')
          + table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/istio-workloads-overview?var-datasource=${datasource}&var-job=${__data.fields["Job"]}&var-cluster=${__data.fields["Cluster"]}&var-service=${__value.raw}&${__url_time_range}',
            },
          ]),
          table.fieldOverride.byName.new('Workload')
          + table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/istio-workloads-overview?var-datasource=${datasource}&var-job=${__data.fields["Job"]}&var-cluster=${__data.fields["Cluster"]}&var-service=${__data.fields["Service"]}&var-workload=${__value.raw}&${__url_time_range}',
            },
          ]),
          table.fieldOverride.byName.new('HTTP/GRPC tx delay')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'ms'),
          table.fieldOverride.byName.new('HTTP/GRPC rx delay')
          + table.fieldOverride.byName.withProperty('custom.width', 157)
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'ms'),
          table.fieldOverride.byName.new('HTTP/GRPC tx')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'reqps'),
          table.fieldOverride.byName.new('HTTP/GRPC rx')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'reqps'),
          table.fieldOverride.byName.new('HTTP tx success')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'percent'),
          table.fieldOverride.byName.new('HTTP rx success')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'percent'),
          table.fieldOverride.byName.new('TCP tx')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'Bps'),
          table.fieldOverride.byName.new('TCP rx')
          + table.fieldOverride.byName.withProperty('custom.align', 'left')
          + table.fieldOverride.byName.withProperty('unit', 'Bps'),
        ])
        + table.options.withFooter(
          table.options.footer.TableFooterOptions.withReducerMixin(['sum'])
        )
        + table.queryOptions.withTransformationsMixin([
          {
            id: 'merge',
            options: {},
          },
          {
            id: 'organize',
            options: {
              excludeByName: {
                Time: true,
              },
              includeByName: {},
              indexByName: {
                Time: 0,
                'Value #Source workload HTTP/GRPC request rate': 5,
                'Value #Destination workload HTTP/GRPC request rate': 8,
                'Value #Source workload HTTP/GRPC request latency': 6,
                'Value #Destination workload HTTP/GRPC request latency': 9,
                'Value #Source workload HTTP request success rate': 7,
                'Value #Destination workload HTTP request success rate': 10,
                'Value #Source workload TCP request throughput': 11,
                'Value #Destination workload TCP response throughput': 12,
                cluster: 1,
                job: 2,
                service: 3,
                workload: 4,
              },
              renameByName: {
                'Value #Source workload HTTP/GRPC request rate': 'HTTP/GRPC tx',
                'Value #Destination workload HTTP/GRPC request rate': 'HTTP/GRPC rx',
                'Value #Source workload HTTP/GRPC request latency': 'HTTP/GRPC tx delay',
                'Value #Destination workload HTTP/GRPC request latency': 'HTTP/GRPC rx delay',
                'Value #Source workload HTTP request success rate': 'HTTP tx success',
                'Value #Destination workload HTTP request success rate': 'HTTP rx success',
                'Value #Source workload TCP request throughput': 'TCP tx',
                'Value #Destination workload TCP response throughput': 'TCP rx',
                cluster: 'Cluster',
                job: 'Job',
                service: 'Service',
                workload: 'Workload',
              },
            },
          },
        ]),
    },
}
