local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';
local utils = commonlib.utils;
{
  new(this):
    {
      local t = this.grafana.targets,
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
          targets=[t.proxyCount],
          description='Number of proxies in the Istio system.'
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
          targets=[t.gatewayCount],
          description='Number of gateways in the Istio system.'
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
          targets=[t.virtualServiceCount],
          description='Number of virtual services in the Istio system.'
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
          targets=[t.destinationRuleCount],
          description='Number of destination rules in the Istio system.'
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
          targets=[t.serviceEntryCount],
          description='Number of service entries in the Istio system.'
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
          targets=[t.workloadEntryCount],
          description='Number of workload entries in the Istio system.'
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
            t.istiodCPUUsage,
            t.gatewayCPUUsage,
            t.proxyCPUUsage,
          ],
          description='vCPU usage for various components of the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        })
        + timeSeries.standardOptions.withUnit('percentunit'),
      openFileDescriptors:
        commonlib.panels.generic.timeSeries.base.new(
          'Open file descriptors',
          targets=[
            t.istiodOpenFileDescriptors,
            t.gatewayOpenFileDescriptors,
            t.proxyOpenFileDescriptors,
          ],
          description='Number of open file descriptors for various components of the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      virtualAndResidentMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Virtual & resident memory',
          targets=[
            t.istiodVirtualMemory,
            t.istiodResidentMemory,
            t.gatewayVirtualMemory,
            t.gatewayResidentMemory,
            t.proxyVirtualMemory,
            t.proxyResidentMemory,
          ],
          description='Available virtual memory compared to the resident memory for the various components of the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.fieldConfig.defaults.custom.withScaleDistributionMixin({
          log: 2,
          type: 'log'
        })
        + timeSeries.standardOptions.withUnit('bytes'),
      heapMemory:
        commonlib.panels.generic.timeSeries.base.new(
          'Heap memory',
          targets=[
            t.istiodHeapAllocated,
            t.istiodHeapInUse,
            t.istiodHeapSystem,
            t.gatewayHeapAllocated,
            t.gatewayHeapInUse,
            t.gatewayHeapSystem,
            t.proxyHeapAllocated,
            t.proxyHeapInUse,
            t.proxyHeapSystem,
          ],
          description='Heap memory information for the various components of the Istio system.'
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.standardOptions.withUnit('bytes'),
      httpGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests',
          targets=[
            t.gatewayHTTPGRPCRequestRate,
            t.proxyHTTPGRPCRequestRate,
          ],
          description='HTTP/GRPC request rate for the components of the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        })
        + timeSeries.standardOptions.withUnit('reqps'),
      xDSEnvoyThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'xDS envoy throughput',
          targets=[
            t.envoyxDSBytesSendRate,
            t.envoyxDSBytesReceiveRate,
          ],
          description='The send and receive data rates from all envoy proxies in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps'),
      xDSErrors:
        commonlib.panels.generic.timeSeries.base.new(
          'xDS errors / $__interval',
          targets=[
            t.pilotCDSxDSRejections,
            t.pilotEDSxDSRejections,
            t.pilotRDSxDSRejections,
            t.pilotLDSxDSRejections,
            t.pilotxDSWriteTimeouts,
            t.pilotxDSInternalErrors,
            t.pilotxDSProxyRejects,
            t.pilotxDSInboundListenerConflicts,
            t.pilotxDSOutboundListenerTCPConflicts,
          ],
          description='The xDS related errors across the Istio system.'
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean']),
      clientServiceHTTPGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests sent',
          targets=[
            t.clientServiceHTTPGRPCRequestRate
          ],
          description='Rate of HTTP/GRPC requests sent from this service to server services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('reqps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      clientServiceHTTPGRPCRequestDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request delay',
          targets=[
            t.clientServiceHTTPGRPCAvgRequestDelay
          ],
          description='Average latency of HTTP/GRPC requests sent from this service to server services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('ms'),
      clientServiceHTTPGRPCRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request throughput',
          targets=[
            t.clientServiceHTTPGRPCRequestThroughputRate
          ],
          description='Rate of HTTP/GRPC request data sent from this service to server services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      clientServiceHTTPGRPCResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC response throughput',
          targets=[
            t.clientServiceHTTPGRPCResponseThroughputRate
          ],
          description='Rate of HTTP/GRPC response data received by this service from server services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      clientServiceHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            t.clientServiceHTTP1xxResponses,
            t.clientServiceHTTP2xxResponses,
            t.clientServiceHTTP3xxResponses,
            t.clientServiceHTTP4xxResponses,
            t.clientServiceHTTP5xxResponses,
          ],
          description='The types of HTTP responses received by this service from server services in the Istio system.'
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      clientServiceGRPCResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'GRPC responses / $__interval',
          targets=[
            t.clientServiceGRPCResponses,
          ],
          description='The types of GRPC responses received by this service from server services in the Istio system.'
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      clientServiceTCPRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP request throughput',
          targets=[
            t.clientServiceTCPRequestThroughputRate
          ],
          description='Rate of TCP request data sent from this service to server services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      clientServiceTCPResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP response throughput',
          targets=[
            t.clientServiceTCPResponseThroughputRate
          ],
          description='Rate of TCP response data received by this service from server services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      serverServiceHTTPGRPCRequests:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC requests received',
          targets=[
            t.serverServiceHTTPGRPCRequestRate
          ],
          description='Rate of HTTP/GRPC requests received by this service from client services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('reqps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      serverServiceHTTPGRPCRequestDelay:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request delay',
          targets=[
            t.serverServiceHTTPGRPCAvgRequestDelay
          ],
          description='Average latency of HTTP/GRPC requests received by this service from client services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('ms'),
      serverServiceHTTPGRPCRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC request throughput',
          targets=[
            t.serverServiceHTTPGRPCRequestThroughputRate
          ],
          description='Rate of HTTP/GRPC request data received by this service from client services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      serverServiceHTTPGRPCResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP/GRPC response throughput',
          targets=[
            t.serverServiceHTTPGRPCResponseThroughputRate
          ],
          description='Rate of HTTP/GRPC response data sent from this service to client services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      serverServiceHTTPResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'HTTP responses / $__interval',
          targets=[
            t.serverServiceHTTP1xxResponses,
            t.serverServiceHTTP2xxResponses,
            t.serverServiceHTTP3xxResponses,
            t.serverServiceHTTP4xxResponses,
            t.serverServiceHTTP5xxResponses,
          ],
          description='The types of HTTP responses sent from this service to client services in the Istio system.'
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      serverServiceGRPCResponses:
        commonlib.panels.generic.timeSeries.base.new(
          'GRPC responses / $__interval',
          targets=[
            t.serverServiceGRPCResponses,
          ],
          description='The types of GRPC responses sent from this service to client services in the Istio system.'
        )
        + timeSeries.options.legend.withDisplayMode('table')
        + timeSeries.options.legend.withCalcsMixin(['min', 'max', 'mean'])
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      serverServiceTCPRequestThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP request throughput',
          targets=[
            t.serverServiceTCPRequestThroughputRate
          ],
          description='Rate of TCP request data received by this service from client services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),
      serverServiceTCPResponseThroughput:
        commonlib.panels.generic.timeSeries.base.new(
          'TCP response throughput',
          targets=[
            t.serverServiceTCPResponseThroughputRate
          ],
          description='Rate of TCP response data sent from this service to client services in the Istio system.'
        )
        + timeSeries.options.legend.withPlacement('right')
        + timeSeries.standardOptions.withUnit('Bps')
        + timeSeries.fieldConfig.defaults.custom.withStackingMixin({
          group: 'A',
          mode: 'normal'
        }),

      httpResponseOverview:
        pieChart.new(title='HTTP response overview')
        + pieChart.queryOptions.withTargets([
            t.gatewayHTTPOKResponses,
            t.gatewayHTTPErrorResponses,
            t.proxyHTTPOKResponses,
            t.proxyHTTPErrorResponses,
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc'
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}')
        + pieChart.panelOptions.withDescription('Recent number of successful (1xx, 2xx, 3xx) vs error (4xx, 5xx) HTTP responses received by various components of the Istio system.'),
      clientServiceHTTPResponseOverview:
        pieChart.new(title='HTTP response overview')
        + pieChart.queryOptions.withTargets([
            t.clientServiceHTTPOKResponses,
            t.clientServiceHTTPErrorResponses,
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc'
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}')
        + pieChart.panelOptions.withDescription('Overview of the types of HTTP responses received by this service from server services in the Istio system.'),
      clientServiceGRPCResponseOverview:
        pieChart.new(title='GRPC response overview')
        + pieChart.queryOptions.withTargets([
            t.clientServiceGRPCOKResponses,
            t.clientServiceGRPCErrorResponses,
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc'
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}')
        + pieChart.panelOptions.withDescription('Overview of the types of GRPC responses received by this service from server services in the Istio system.'),
      serverServiceHTTPResponseOverview:
        pieChart.new(title='HTTP response overview')
        + pieChart.queryOptions.withTargets([
            t.serverServiceHTTPOKResponses,
            t.serverServiceHTTPErrorResponses,
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc'
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}')
        + pieChart.panelOptions.withDescription('Overview of the types of HTTP responses sent from this service to client services in the Istio system.'),
      serverServiceGRPCResponseOverview:
        pieChart.new(title='GRPC response overview')
        + pieChart.queryOptions.withTargets([
            t.serverServiceGRPCOKResponses,
            t.serverServiceGRPCErrorResponses,
        ])
        + pieChart.options.legend.withPlacement('right')
        + pieChart.options.reduceOptions.withCalcs(['sum'])
        + pieChart.options.withTooltipMixin({
          mode: 'multi',
          sort: 'desc'
        })
        + pieChart.queryOptions.withDatasource('prometheus', '${datasource}')
        + pieChart.panelOptions.withDescription('Overview of the types of GRPC responses sent from this service to client services in the Istio system.'),

      xDSPushes:
        barGauge.new(title='xDS pushes')
        + barGauge.queryOptions.withTargets([
            t.pilotCDSxDSPushes,
            t.pilotEDSxDSPushes,
            t.pilotLDSxDSPushes,
            t.pilotRDSxDSPushes,
            t.pilotSDSxDSPushes,
            t.pilotNDSxDSPushes,
        ])
        + barGauge.queryOptions.withDatasource('prometheus', '${datasource}')
        + barGauge.panelOptions.withDescription('Number of xDS pushes by Istiod over the entire time range for the Istio system.')
        + barGauge.standardOptions.thresholds.withSteps([
          barGauge.thresholdStep.withColor('super-light-green'),
        ])
        + barGauge.options.withOrientation('horizontal')
        + barGauge.options.reduceOptions.withCalcs(['sum']),
      galleyValidations:
        barGauge.new(title='Galley validations')
        + barGauge.queryOptions.withTargets([
            t.galleyValidationsPassed,
            t.galleyValidationsFailed,
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
            t.sidecarInjectionSuccesses,
            t.sidecarInjectionFailures,
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
            t.pilotxDSProxyPushLatencyBucket,
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
          t.tableSourceServiceHTTPGRPCRequestRate,
          t.tableDestinationServiceHTTPGRPCRequestRate,
          t.tableSourceServiceHTTPGRPCRequestLatency,
          t.tableDestinationServiceHTTPGRPCRequestLatency,
          t.tableSourceServiceHTTPRequestSuccessRate,
          t.tableDestinationServiceHTTPRequestSuccessRate,
          t.tableSourceServiceTCPReceiveRate,
          t.tableSourceServiceTCPSendRate,
        ])
        + table.queryOptions.withDatasource('prometheus', '${datasource}')
        + table.panelOptions.withDescription('Service details for the Istio system.')
        + table.standardOptions.withNoValue('NA')
        + table.standardOptions.withOverridesMixin([
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
          options: {}
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              job: true
            },
            includeByName: {},
            indexByName: {
              Time: 0,
              'Value #A': 4,
              'Value #B': 7,
              'Value #C': 5,
              'Value #D': 8,
              'Value #E': 6,
              'Value #F': 9,
              'Value #G': 10,
              'Value #H': 11,
              'Value #I': 13,
              'Value #J': 12,
              cluster: 1,
              job: 2,
              service: 3
            },
            renameByName: {
              'Value #A': 'HTTP/GRPC tx',
              'Value #B': 'HTTP/GRPC rx',
              'Value #C': 'HTTP/GRPC tx delay',
              'Value #D': 'HTTP/GRPC rx delay',
              'Value #E': 'HTTP tx success',
              'Value #F': 'HTTP rx success',
              'Value #G': 'TCP tx',
              'Value #H': 'TCP rx',
              'Value #I': 'TCP client closes',
              'Value #J': 'TCP client opens',
              cluster: 'Cluster',
              job: 'Job',
              service: 'Service'
            }
          }
        }
      ]),
      workloads:
        table.new(
          title='Workloads'
        )
        + table.queryOptions.withTargets([
          t.tableSourceWorkloadHTTPGRPCRequestRate,
          t.tableDestinationWorkloadHTTPGRPCRequestRate,
          t.tableSourceWorkloadHTTPGRPCRequestLatency,
          t.tableDestinationWorkloadHTTPGRPCRequestLatency,
          t.tableSourceWorkloadHTTPRequestSuccessRate,
          t.tableDestinationWorkloadHTTPRequestSuccessRate,
          t.tableSourceWorkloadTCPRequestThroughputRate,
          t.tableDestinationWorkloadTCPResponseThroughputRate,
        ])
        + table.queryOptions.withDatasource('prometheus', '${datasource}')
        + table.panelOptions.withDescription('Workload details for a service in the Istio system.')
        + table.standardOptions.withNoValue('NA')
        + table.standardOptions.withOverridesMixin([
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
          options: {}
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              Time: true,
              job: true
            },
            includeByName: {},
            indexByName: {
              Time: 0,
              'Value #A': 5,
              'Value #B': 8,
              'Value #C': 6,
              'Value #D': 9,
              'Value #E': 7,
              'Value #F': 10,
              cluster: 1,
              job: 2,
              service: 3,
              workload: 4
            },
            renameByName: {
              'Value #A': 'HTTP/GRPC tx',
              'Value #B': 'HTTP/GRPC rx',
              'Value #C': 'HTTP/GRPC tx delay',
              'Value #D': 'HTTP/GRPC rx delay',
              'Value #E': 'HTTP tx success',
              'Value #F': 'HTTP rx success',
              'Value #G': 'TCP tx',
              'Value #H': 'TCP rx',
              cluster: 'Cluster',
              service: 'Service',
              workload: 'Workload'
            }
          }
        }
      ]),
    },
}
