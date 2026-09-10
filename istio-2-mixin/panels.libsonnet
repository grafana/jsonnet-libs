local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
{
  new(this):
    {
      local signals = this.signals,

      alertsPanel:
        // common-lib has no alertList base: this panel renders Grafana alert state, not a signal query.
        g.panel.alertList.new('Istio alerts')
        + g.panel.alertList.options.UnifiedAlertListOptions.withAlertInstanceLabelFilter(this.grafana.variables.queriesSelectorAdvancedSyntax),

      proxies:
        signals.overview.proxyCount.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('super-light-red')
          + g.panel.stat.thresholdStep.withValue(null),
          g.panel.stat.thresholdStep.withColor('super-light-green')
          + g.panel.stat.thresholdStep.withValue(1),
        ]),
      gateways:
        signals.overview.gatewayCount.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('text')
          + g.panel.stat.thresholdStep.withValue(null),
          g.panel.stat.thresholdStep.withColor('super-light-green')
          + g.panel.stat.thresholdStep.withValue(1),
        ]),
      virtualServices:
        signals.overview.virtualServiceCount.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('text')
          + g.panel.stat.thresholdStep.withValue(null),
          g.panel.stat.thresholdStep.withColor('super-light-green')
          + g.panel.stat.thresholdStep.withValue(1),
        ]),
      destinationRules:
        signals.overview.destinationRuleCount.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('super-light-orange')
          + g.panel.stat.thresholdStep.withValue(null),
          g.panel.stat.thresholdStep.withColor('super-light-green')
          + g.panel.stat.thresholdStep.withValue(1),
        ]),
      serviceEntries:
        signals.overview.serviceEntryCount.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('text')
          + g.panel.stat.thresholdStep.withValue(null),
          g.panel.stat.thresholdStep.withColor('super-light-green')
          + g.panel.stat.thresholdStep.withValue(1),
        ]),
      workloadEntries:
        signals.overview.workloadEntryCount.asStat()
        + commonlib.panels.generic.stat.base.stylize()
        + g.panel.stat.options.withGraphMode('none')
        + g.panel.stat.standardOptions.color.withMode('thresholds')
        + g.panel.stat.standardOptions.thresholds.withSteps([
          g.panel.stat.thresholdStep.withColor('text')
          + g.panel.stat.thresholdStep.withValue(null),
          g.panel.stat.thresholdStep.withColor('super-light-green')
          + g.panel.stat.thresholdStep.withValue(1),
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
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        })
        + g.panel.timeSeries.standardOptions.withUnit('percentunit'),
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
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
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
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withScaleDistributionMixin({
          log: 2,
          type: 'log',
        })
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),
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
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.standardOptions.withUnit('bytes'),
      httpGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests',
          targets=[
            signals.overview.gatewayHTTPGRPCRequestRate.asTarget(),
            signals.overview.proxyHTTPGRPCRequestRate.asTarget(),
          ],
          description='HTTP/GRPC request rate for the components of the Istio system.',
        )
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        })
        + g.panel.timeSeries.standardOptions.withUnit('reqps'),
      xDSEnvoyThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'xDS envoy throughput',
          targets=[
            signals.controlplane.envoyxDSBytesSendRate.asTarget(),
            signals.controlplane.envoyxDSBytesReceiveRate.asTarget(),
          ],
          description='The send and receive data rates from all envoy proxies in the Istio system.',
        )
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),
      xDSErrors:
        commonlib.panels.generic.timeSeries.base.new(
          'xDS errors / $__interval',
          targets=[
            signals.controlplane.pilotCDSxDSRejections.asTarget() { interval: '1m' },
            signals.controlplane.pilotEDSxDSRejections.asTarget() { interval: '1m' },
            signals.controlplane.pilotRDSxDSRejections.asTarget() { interval: '1m' },
            signals.controlplane.pilotLDSxDSRejections.asTarget() { interval: '1m' },
            signals.controlplane.pilotxDSWriteTimeouts.asTarget() { interval: '1m' },
            signals.controlplane.pilotxDSInternalErrors.asTarget() { interval: '1m' },
            signals.controlplane.pilotxDSProxyRejects.asTarget() { interval: '1m' },
            signals.controlplane.pilotxDSInboundListenerConflicts.asTarget() { interval: '1m' },
            signals.controlplane.pilotxDSOutboundListenerTCPConflicts.asTarget() { interval: '1m' },
          ],
          description='The xDS related errors across the Istio system.'
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean']),
      clientServiceHTTPGRPCRequests:
        signals.services.clientServiceHTTPGRPCRequestRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceHTTPGRPCRequestDelay:
        signals.services.clientServiceHTTPGRPCAvgRequestDelay.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + g.panel.timeSeries.options.legend.withPlacement('right'),
      clientServiceHTTPGRPCRequestThroughput:
        signals.services.clientServiceHTTPGRPCRequestThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceHTTPGRPCResponseThroughput:
        signals.services.clientServiceHTTPGRPCResponseThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            signals.services.clientServiceHTTP1xxResponses.asTarget() { interval: '1m' },
            signals.services.clientServiceHTTP2xxResponses.asTarget() { interval: '1m' },
            signals.services.clientServiceHTTP3xxResponses.asTarget() { interval: '1m' },
            signals.services.clientServiceHTTP4xxResponses.asTarget() { interval: '1m' },
            signals.services.clientServiceHTTP5xxResponses.asTarget() { interval: '1m' },
          ],
          description='The types of HTTP responses received by this service from server services in the Istio system.',
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceGRPCResponses:
        signals.services.clientServiceGRPCResponses.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceTCPRequestThroughput:
        signals.services.clientServiceTCPRequestThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientServiceTCPResponseThroughput:
        signals.services.clientServiceTCPResponseThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceHTTPGRPCRequests:
        signals.services.serverServiceHTTPGRPCRequestRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceHTTPGRPCRequestDelay:
        signals.services.serverServiceHTTPGRPCAvgRequestDelay.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + g.panel.timeSeries.options.legend.withPlacement('right'),
      serverServiceHTTPGRPCRequestThroughput:
        signals.services.serverServiceHTTPGRPCRequestThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceHTTPGRPCResponseThroughput:
        signals.services.serverServiceHTTPGRPCResponseThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            signals.services.serverServiceHTTP1xxResponses.asTarget() { interval: '1m' },
            signals.services.serverServiceHTTP2xxResponses.asTarget() { interval: '1m' },
            signals.services.serverServiceHTTP3xxResponses.asTarget() { interval: '1m' },
            signals.services.serverServiceHTTP4xxResponses.asTarget() { interval: '1m' },
            signals.services.serverServiceHTTP5xxResponses.asTarget() { interval: '1m' },
          ],
          description='The types of HTTP responses sent from this service to client services in the Istio system.',
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceGRPCResponses:
        signals.services.serverServiceGRPCResponses.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceTCPRequestThroughput:
        signals.services.serverServiceTCPRequestThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverServiceTCPResponseThroughput:
        signals.services.serverServiceTCPResponseThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadHTTPGRPCRequests:
        signals.workloads.clientWorkloadHTTPGRPCRequestRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadHTTPGRPCRequestDelay:
        signals.workloads.clientWorkloadHTTPGRPCAvgRequestDelay.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + g.panel.timeSeries.options.legend.withPlacement('right'),
      clientWorkloadHTTPGRPCRequestThroughput:
        signals.workloads.clientWorkloadHTTPGRPCRequestThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadHTTPGRPCResponseThroughput:
        signals.workloads.clientWorkloadHTTPGRPCResponseThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            signals.workloads.clientWorkloadHTTP1xxResponses.asTarget() { interval: '1m' },
            signals.workloads.clientWorkloadHTTP2xxResponses.asTarget() { interval: '1m' },
            signals.workloads.clientWorkloadHTTP3xxResponses.asTarget() { interval: '1m' },
            signals.workloads.clientWorkloadHTTP4xxResponses.asTarget() { interval: '1m' },
            signals.workloads.clientWorkloadHTTP5xxResponses.asTarget() { interval: '1m' },
          ],
          description='The types of HTTP responses received by this workload from server workloads in the Istio system.',
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadGRPCResponses:
        signals.workloads.clientWorkloadGRPCResponses.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadTCPRequestThroughput:
        signals.workloads.clientWorkloadTCPRequestThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      clientWorkloadTCPResponseThroughput:
        signals.workloads.clientWorkloadTCPResponseThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadHTTPGRPCRequests:
        signals.workloads.serverWorkloadHTTPGRPCRequestRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadHTTPGRPCRequestDelay:
        signals.workloads.serverWorkloadHTTPGRPCAvgRequestDelay.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + g.panel.timeSeries.options.legend.withPlacement('right'),
      serverWorkloadHTTPGRPCRequestThroughput:
        signals.workloads.serverWorkloadHTTPGRPCRequestThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadHTTPGRPCResponseThroughput:
        signals.workloads.serverWorkloadHTTPGRPCResponseThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            signals.workloads.serverWorkloadHTTP1xxResponses.asTarget() { interval: '1m' },
            signals.workloads.serverWorkloadHTTP2xxResponses.asTarget() { interval: '1m' },
            signals.workloads.serverWorkloadHTTP3xxResponses.asTarget() { interval: '1m' },
            signals.workloads.serverWorkloadHTTP4xxResponses.asTarget() { interval: '1m' },
            signals.workloads.serverWorkloadHTTP5xxResponses.asTarget() { interval: '1m' },
          ],
          description='The types of HTTP responses sent from this workload to client workloads in the Istio system.',
        )
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadGRPCResponses:
        signals.workloads.serverWorkloadGRPCResponses.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.queryOptions.withInterval('1m')
        + g.panel.timeSeries.options.legend.withDisplayMode('table')
        + g.panel.timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadTCPRequestThroughput:
        signals.workloads.serverWorkloadTCPRequestThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),
      serverWorkloadTCPResponseThroughput:
        signals.workloads.serverWorkloadTCPResponseThroughputRate.asTimeSeries()
        + commonlib.panels.generic.timeSeries.base.stylize()
        + g.panel.timeSeries.options.legend.withPlacement('right')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal',
        }),

      httpResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='HTTP response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.overview.gatewayHTTPOKResponses.asTarget() { interval: '1m' },
          signals.overview.gatewayHTTPErrorResponses.asTarget() { interval: '1m' },
          signals.overview.proxyHTTPOKResponses.asTarget() { interval: '1m' },
          signals.overview.proxyHTTPErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Recent number of successful (1xx, 2xx, 3xx) vs error (4xx, 5xx) HTTP responses received by various components of the Istio system.'),
      clientServiceHTTPResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='HTTP response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.services.clientServiceHTTPOKResponses.asTarget() { interval: '1m' },
          signals.services.clientServiceHTTPErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Overview of the types of HTTP responses received by this service from server services in the Istio system.'),
      clientServiceGRPCResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='GRPC response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.services.clientServiceGRPCOKResponses.asTarget() { interval: '1m' },
          signals.services.clientServiceGRPCErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Overview of the types of GRPC responses received by this service from server services in the Istio system.'),
      serverServiceHTTPResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='HTTP response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.services.serverServiceHTTPOKResponses.asTarget() { interval: '1m' },
          signals.services.serverServiceHTTPErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Overview of the types of HTTP responses sent from this service to client services in the Istio system.'),
      serverServiceGRPCResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='GRPC response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.services.serverServiceGRPCOKResponses.asTarget() { interval: '1m' },
          signals.services.serverServiceGRPCErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Overview of the types of GRPC responses sent from this service to client services in the Istio system.'),
      clientWorkloadHTTPResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='HTTP response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.workloads.clientWorkloadHTTPOKResponses.asTarget() { interval: '1m' },
          signals.workloads.clientWorkloadHTTPErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Overview of the types of HTTP responses received by this workload from server workloads in the Istio system.'),
      clientWorkloadGRPCResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='GRPC response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.workloads.clientWorkloadGRPCOKResponses.asTarget() { interval: '1m' },
          signals.workloads.clientWorkloadGRPCErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Overview of the types of GRPC responses received by this workload from server workloads in the Istio system.'),
      serverWorkloadHTTPResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='HTTP response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.workloads.serverWorkloadHTTPOKResponses.asTarget() { interval: '1m' },
          signals.workloads.serverWorkloadHTTPErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Overview of the types of HTTP responses sent from this workload to client workloads in the Istio system.'),
      serverWorkloadGRPCResponseOverview:
        // common-lib has no pieChart base.
        g.panel.pieChart.new(title='GRPC response overview')
        + g.panel.pieChart.queryOptions.withTargets([
          signals.workloads.serverWorkloadGRPCOKResponses.asTarget() { interval: '1m' },
          signals.workloads.serverWorkloadGRPCErrorResponses.asTarget() { interval: '1m' },
        ])
        + g.panel.pieChart.options.legend.withPlacement('right')
        + g.panel.pieChart.options.reduceOptions.withCalcs(['sum'])
        + g.panel.pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc',
        })
        + g.panel.pieChart.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.pieChart.panelOptions.withDescription('Overview of the types of GRPC responses sent from this workload to client workloads in the Istio system.'),

      xDSPushes:
        // common-lib has no barGauge base.
        g.panel.barGauge.new(title='xDS pushes')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.controlplane.pilotCDSxDSPushes.asTarget() { interval: '1m' },
          signals.controlplane.pilotEDSxDSPushes.asTarget() { interval: '1m' },
          signals.controlplane.pilotLDSxDSPushes.asTarget() { interval: '1m' },
          signals.controlplane.pilotRDSxDSPushes.asTarget() { interval: '1m' },
          signals.controlplane.pilotSDSxDSPushes.asTarget() { interval: '1m' },
          signals.controlplane.pilotNDSxDSPushes.asTarget() { interval: '1m' },
        ])
        + g.panel.barGauge.queryOptions.withDatasource('prometheus', '${datasource}',)
        + g.panel.barGauge.panelOptions.withDescription('Number of xDS pushes by Istiod over the entire time range for the Istio system.')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['sum']),
      galleyValidations:
        // common-lib has no barGauge base.
        g.panel.barGauge.new(title='Galley validations')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.controlplane.galleyValidationsPassed.asTarget() { interval: '1m' },
          signals.controlplane.galleyValidationsFailed.asTarget() { interval: '1m' },
        ])
        + g.panel.barGauge.queryOptions.withDatasource('prometheus', '${datasource}')
        + g.panel.barGauge.panelOptions.withDescription('Number of galley validations over the entire time range for the Istio system.')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['sum']),
      sidecarInjections:
        // common-lib has no barGauge base.
        g.panel.barGauge.new(title='Sidecar injections')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.controlplane.sidecarInjectionSuccesses.asTarget() { interval: '1m' },
          signals.controlplane.sidecarInjectionFailures.asTarget() { interval: '1m' },
        ])
        + g.panel.barGauge.queryOptions.withDatasource('prometheus', '${datasource}')
        + g.panel.barGauge.panelOptions.withDescription('Number of sidecar injections over the entire time range for the Istio system.')
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.reduceOptions.withCalcs(['sum']),

      xDSPushDelay:
        // common-lib has no histogram base.
        g.panel.histogram.new(title='xDS push delay (s)')
        + g.panel.histogram.queryOptions.withTargets([
          signals.controlplane.pilotxDSProxyPushLatencyBucket.asTarget() { interval: '1m', instant: true, format: 'heatmap' },
        ])
        + g.panel.histogram.queryOptions.withDatasource('prometheus', '${datasource}')
        + g.panel.histogram.options.legend.withPlacement('right')
        + g.panel.histogram.standardOptions.color.withMode('thresholds')
        + g.panel.histogram.standardOptions.thresholds.withSteps([
          g.panel.histogram.thresholdStep.withColor('super-light-green'),
        ])
        + g.panel.histogram.panelOptions.withDescription('The latency of xDS pushes by Istiod over the entire time range for the Istio system.'),

      services:
        commonlib.panels.generic.table.base.new(
          'Services',
          targets=[
            signals.services.tableSourceServiceHTTPGRPCRequestRate.asTableTarget(),
            signals.services.tableDestinationServiceHTTPGRPCRequestRate.asTableTarget(),
            signals.services.tableSourceServiceHTTPGRPCRequestLatency.asTableTarget() { interval: '1m' },
            signals.services.tableDestinationServiceHTTPGRPCRequestLatency.asTableTarget() { interval: '1m' },
            signals.services.tableSourceServiceHTTPRequestSuccessRate.asTableTarget() { interval: '1m' },
            signals.services.tableDestinationServiceHTTPRequestSuccessRate.asTableTarget() { interval: '1m' },
            signals.services.tableSourceServiceTCPReceiveRate.asTableTarget(),
            signals.services.tableSourceServiceTCPSendRate.asTableTarget(),
          ],
          description='Service details for the Istio system.',
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', 'true'),
          g.panel.table.fieldOverride.byName.new('Service')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/istio-services-overview?var-datasource=${datasource}&var-job=${__data.fields["Job"]}&var-cluster=${__data.fields["Cluster"]}&var-service=${__value.raw}&${__url_time_range}',
            },
          ]),
          g.panel.table.fieldOverride.byName.new('HTTP/GRPC tx delay')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'ms'),
          g.panel.table.fieldOverride.byName.new('HTTP/GRPC rx delay')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'ms'),
          g.panel.table.fieldOverride.byName.new('HTTP/GRPC tx')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'reqps'),
          g.panel.table.fieldOverride.byName.new('HTTP/GRPC rx')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'reqps'),
          g.panel.table.fieldOverride.byName.new('HTTP tx success')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'percent'),
          g.panel.table.fieldOverride.byName.new('HTTP rx success')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'percent'),
          g.panel.table.fieldOverride.byName.new('TCP tx')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'Bps'),
          g.panel.table.fieldOverride.byName.new('TCP rx')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'Bps'),
        ])
        + g.panel.table.options.footer.withReducerMixin(['sum'])
        + g.panel.table.queryOptions.withTransformationsMixin([
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
        commonlib.panels.generic.table.base.new(
          'Workloads',
          targets=[
            signals.workloads.tableSourceWorkloadHTTPGRPCRequestRate.asTableTarget(),
            signals.workloads.tableDestinationWorkloadHTTPGRPCRequestRate.asTableTarget(),
            signals.workloads.tableSourceWorkloadHTTPGRPCRequestLatency.asTableTarget() { interval: '1m' },
            signals.workloads.tableDestinationWorkloadHTTPGRPCRequestLatency.asTableTarget() { interval: '1m' },
            signals.workloads.tableSourceWorkloadHTTPRequestSuccessRate.asTableTarget() { interval: '1m' },
            signals.workloads.tableDestinationWorkloadHTTPRequestSuccessRate.asTableTarget() { interval: '1m' },
            signals.workloads.tableSourceWorkloadTCPRequestThroughputRate.asTableTarget(),
            signals.workloads.tableDestinationWorkloadTCPResponseThroughputRate.asTableTarget(),
          ],
          description='Workload details for a service in the Istio system.',
        )
        + g.panel.table.standardOptions.withNoValue('NA')
        + g.panel.table.standardOptions.withOverridesMixin([
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', 'true'),
          g.panel.table.fieldOverride.byName.new('Service')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/istio-workloads-overview?var-datasource=${datasource}&var-job=${__data.fields["Job"]}&var-cluster=${__data.fields["Cluster"]}&var-service=${__value.raw}&${__url_time_range}',
            },
          ]),
          g.panel.table.fieldOverride.byName.new('Workload')
          + g.panel.table.fieldOverride.byName.withProperty('links', [
            {
              title: '',
              url: 'd/istio-workloads-overview?var-datasource=${datasource}&var-job=${__data.fields["Job"]}&var-cluster=${__data.fields["Cluster"]}&var-service=${__data.fields["Service"]}&var-workload=${__value.raw}&${__url_time_range}',
            },
          ]),
          g.panel.table.fieldOverride.byName.new('HTTP/GRPC tx delay')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'ms'),
          g.panel.table.fieldOverride.byName.new('HTTP/GRPC rx delay')
          + g.panel.table.fieldOverride.byName.withProperty('custom.width', 157)
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'ms'),
          g.panel.table.fieldOverride.byName.new('HTTP/GRPC tx')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'reqps'),
          g.panel.table.fieldOverride.byName.new('HTTP/GRPC rx')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'reqps'),
          g.panel.table.fieldOverride.byName.new('HTTP tx success')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'percent'),
          g.panel.table.fieldOverride.byName.new('HTTP rx success')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'percent'),
          g.panel.table.fieldOverride.byName.new('TCP tx')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'Bps'),
          g.panel.table.fieldOverride.byName.new('TCP rx')
          + g.panel.table.fieldOverride.byName.withProperty('custom.align', 'left')
          + g.panel.table.fieldOverride.byName.withProperty('unit', 'Bps'),
        ])
        + g.panel.table.options.footer.withReducerMixin(['sum'])
        + g.panel.table.queryOptions.withTransformationsMixin([
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
