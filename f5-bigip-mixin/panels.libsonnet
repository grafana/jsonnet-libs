local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,

      // Cluster overview panels - Gauges
      clusterNodeAvailabilityGauge:
        g.panel.gauge.new('Node availability')
        + g.panel.gauge.queryOptions.withTargets([
          signals.cluster.nodeAvailability.asTarget() { interval+: '2m' },
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of nodes available.')
        + g.panel.gauge.standardOptions.withUnit('percent')
        + g.panel.gauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withValue(0)
          + g.panel.gauge.thresholdStep.withColor('red'),
          g.panel.gauge.thresholdStep.withValue(95)
          + g.panel.gauge.thresholdStep.withColor('red'),
          g.panel.gauge.thresholdStep.withValue(96)
          + g.panel.gauge.thresholdStep.withColor('yellow'),
          g.panel.gauge.thresholdStep.withValue(100)
          + g.panel.gauge.thresholdStep.withColor('green'),
        ])
        + g.panel.gauge.options.withShowThresholdMarkers(true)
        + g.panel.gauge.options.withShowThresholdLabels(false),

      clusterPoolAvailabilityGauge:
        g.panel.gauge.new('Pool availability')
        + g.panel.gauge.queryOptions.withTargets([
          signals.cluster.poolAvailability.asTarget() { interval+: '2m' },
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of pools available.')
        + g.panel.gauge.standardOptions.withUnit('percent')
        + g.panel.gauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withValue(0)
          + g.panel.gauge.thresholdStep.withColor('red'),
          g.panel.gauge.thresholdStep.withValue(95)
          + g.panel.gauge.thresholdStep.withColor('red'),
          g.panel.gauge.thresholdStep.withValue(96)
          + g.panel.gauge.thresholdStep.withColor('yellow'),
          g.panel.gauge.thresholdStep.withValue(100)
          + g.panel.gauge.thresholdStep.withColor('green'),
        ])
        + g.panel.gauge.options.withShowThresholdMarkers(true)
        + g.panel.gauge.options.withShowThresholdLabels(false),

      clusterVirtualServerAvailabilityGauge:
        g.panel.gauge.new('Virtual server availability')
        + g.panel.gauge.queryOptions.withTargets([
          signals.cluster.virtualServerAvailability.asTarget() { interval+: '2m' },
        ])
        + g.panel.gauge.panelOptions.withDescription('The percentage of virtual servers available.')
        + g.panel.gauge.standardOptions.withUnit('percent')
        + g.panel.gauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withValue(0)
          + g.panel.gauge.thresholdStep.withColor('red'),
          g.panel.gauge.thresholdStep.withValue(95)
          + g.panel.gauge.thresholdStep.withColor('red'),
          g.panel.gauge.thresholdStep.withValue(96)
          + g.panel.gauge.thresholdStep.withColor('yellow'),
          g.panel.gauge.thresholdStep.withValue(100)
          + g.panel.gauge.thresholdStep.withColor('green'),
        ])
        + g.panel.gauge.options.withShowThresholdMarkers(true)
        + g.panel.gauge.options.withShowThresholdLabels(false),

      // Cluster overview panels - BarGauges for TopK
      clusterTopActiveServersideNodesBarGauge:
        g.panel.barGauge.new('Top active server-side nodes')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.topActiveServersideNodes.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Nodes with the highest number of active server-side connections.')
        + g.panel.barGauge.standardOptions.withUnit('short')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal'),

      clusterTopOutboundTrafficNodesBarGauge:
        g.panel.barGauge.new('Top outbound traffic nodes / $__interval')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.topOutboundTrafficNodes.asTarget() { interval+: '2m' },
        ])
        + g.panel.barGauge.panelOptions.withDescription('Nodes with the highest outbound traffic.')
        + g.panel.barGauge.standardOptions.withUnit('decbytes')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal'),

      clusterTopActiveMembersInPoolsBarGauge:
        g.panel.barGauge.new('Top active members in pools')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.topActiveMembersInPools.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Pools with the highest number of active members.')
        + g.panel.barGauge.standardOptions.withUnit('short')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal'),

      clusterTopRequestedPoolsBarGauge:
        g.panel.barGauge.new('Top requested pools / $__interval')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.topRequestedPools.asTarget() { interval+: '2m' },
        ])
        + g.panel.barGauge.panelOptions.withDescription('Pools with the highest number of requests.')
        + g.panel.barGauge.standardOptions.withUnit('short')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal'),

      clusterTopQueueDepthBarGauge:
        g.panel.barGauge.new('Top queue depth')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.topQueueDepthPools.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Pools with the largest connection queues.')
        + g.panel.barGauge.standardOptions.withUnit('short')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal'),

      clusterTopUtilizedVirtualServersBarGauge:
        g.panel.barGauge.new('Top utilized virtual servers / $__interval')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.topUtilizedVirtualServers.asTarget() { interval+: '2m' },
        ])
        + g.panel.barGauge.panelOptions.withDescription('Virtual servers with the highest traffic (inbound and outbound).')
        + g.panel.barGauge.standardOptions.withUnit('decbytes')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal'),

      clusterTopLatencyVirtualServersBarGauge:
        g.panel.barGauge.new('Top latency virtual servers')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.cluster.topLatencyVirtualServers.asTarget(),
        ])
        + g.panel.barGauge.panelOptions.withDescription('Virtual servers with the highest response times.')
        + g.panel.barGauge.standardOptions.withUnit('ms')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal'),

      // Node panels
      nodeAvailabilityStatusTable:
      commonlib.panels.generic.table.base.new(
        title='Availability status',
        targets=[signals.node.availabilityState.asTableTarget()],
      )
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {
              Time: true,
              job: true,
              __name__: true,
              partition: true,
            },
            indexByName: {},
            renameByName: {
              instance: 'Instance',
              node: 'Node',
              Value: 'Status',
            },
          }),
        ])
        + g.panel.table.panelOptions.withDescription('The availability status of the node.')
        + g.panel.table.standardOptions.withUnit('short'),

      nodeRequestsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests / $__interval',
          targets=[signals.node.totalRequests.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of requests made to the node.')
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      nodeActiveSessionsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Active sessions',
          targets=[signals.node.currentSessions.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The current number of active sessions to the node.')
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      nodeConnectionsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Connections',
          targets=[
            signals.node.serversideCurrentConns.asTarget(),
            signals.node.serversideMaxConns.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The current active server-side connections to the node in comparison to the maximum connection capacity.')
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      nodeTrafficInboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Traffic inbound',
          targets=[signals.node.serversideBytesIn.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The rate of data received from the pool by the node.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      nodeTrafficOutboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Traffic outbound',
          targets=[signals.node.serversideBytesOut.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The rate of data sent from the pool by the node.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps')
        + g.panel.timeSeries.options.legend.withDisplayMode('table'),

      nodePacketsInboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Packets inbound / $__interval',
          targets=[signals.node.serversidePktsIn.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of packets received by the node from the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      nodePacketsOutboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Packets outbound / $__interval',
          targets=[signals.node.serversidePktsOut.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of packets sent by the node from the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      // Pool panels
      poolAvailabilityStatusTable:
        commonlib.panels.generic.table.base.new(
          title='Availability status',
          targets=[signals.pool.availabilityState.asTableTarget()],
        )
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {
              Time: true,
              job: true,
              __name__: true,
              partition: true,
            },
            indexByName: {},
            renameByName: {
              instance: 'Instance',
              pool: 'Pool',
              Value: 'Status',
            },
          }),
        ])
        + g.panel.table.panelOptions.withDescription('The availability status of the pool.')
        + g.panel.table.standardOptions.withUnit('short'),

      poolRequestsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests / $__interval',
          targets=[signals.pool.totalRequests.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of requests made to the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      poolMembersTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Members',
          targets=[
            signals.pool.activeMemberCount.asTarget(),
            signals.pool.minActiveMembers.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of active and minimum required members within the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      poolConnectionsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Connections',
          targets=[
            signals.pool.serversideCurrentConns.asTarget(),
            signals.pool.serversideMaxConns.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The current and maximum number of node connections within the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      poolConnectionQueueDepthTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Connection queue depth',
          targets=[signals.pool.connectionQueueDepth.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The depth of connection queues within the pool, including the current depth.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      poolConnectionQueueServicedTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Connection queue serviced / $__interval',
          targets=[signals.pool.connectionQueueServiced.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of connections that have been serviced within the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      poolTrafficInboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Traffic inbound',
          targets=[signals.pool.serversideBytesIn.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The rate of date received from virtual servers by the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      poolTrafficOutboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Traffic outbound',
          targets=[signals.pool.serversideBytesOut.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The rate of date sent from virtual servers by the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      poolPacketsInboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Packets inbound / $__interval',
          targets=[signals.pool.serversidePktsIn.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of packets received from virtual servers by the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      poolPacketsOutboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Packets outbound / $__interval',
          targets=[signals.pool.serversidePktsOut.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of packets sent from virtual servers by the pool.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      // Virtual Server panels
      virtualServerAvailabilityStatusTable:
        commonlib.panels.generic.table.base.new(
          title='Availability status',
          targets=[signals.virtualServer.availabilityState.asTableTarget()],
        )
        + g.panel.table.queryOptions.withTransformations([
          g.panel.table.transformation.withId('organize')
          + g.panel.table.transformation.withOptions({
            excludeByName: {
              Time: true,
              job: true,
              __name__: true,
              partition: true,
            },
            indexByName: {},
            renameByName: {
              instance: 'Instance',
              vs: 'Virtual Server',
              Value: 'Status',
            },
          }),
        ])
        + g.panel.table.panelOptions.withDescription('The availability status of the virtual server.')
        + g.panel.table.standardOptions.withUnit('short'),

      virtualServerRequestsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Requests / $__interval',
          targets=[signals.virtualServer.totalRequests.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of requests made to the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      virtualServerAvgConnectionDurationTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Average connection duration',
          targets=[signals.virtualServer.clientsideMeanConnDuration.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The average connection duration within the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('ms'),

      virtualServerConnectionsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Connections',
          targets=[
            signals.virtualServer.clientsideCurrentConns.asTarget(),
            signals.virtualServer.clientsideMaxConns.asTarget(),
            signals.virtualServer.clientsideEvictedConns.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The evicted and current client-side connections within the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      virtualServerEphemeralConnectionsTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Ephemeral connections',
          targets=[
            signals.virtualServer.ephemeralCurrentConns.asTarget(),
            signals.virtualServer.ephemeralMaxConns.asTarget(),
            signals.virtualServer.ephemeralEvictedConns.asTarget(),
          ]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The ephemeral evicted and current client-side connections within the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      virtualServerTrafficInboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Traffic inbound',
          targets=[signals.virtualServer.clientsideBytesIn.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The rate of data received from clients by the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      virtualServerTrafficOutboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Traffic outbound',
          targets=[signals.virtualServer.clientsideBytesOut.asTarget()]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The rate of data sent from clients by the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      virtualServerEphemeralTrafficInboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Ephemeral traffic inbound',
          targets=[signals.virtualServer.ephemeralBytesIn.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The rate of ephemeral data received from clients by the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      virtualServerEphemeralTrafficOutboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Ephemeral traffic outbound',
          targets=[signals.virtualServer.ephemeralBytesOut.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The rate of ephemeral data sent from clients by the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('Bps'),

      virtualServerPacketsInboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Packets inbound / $__interval',
          targets=[signals.virtualServer.clientsidePktsIn.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of packets received by the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      virtualServerPacketsOutboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Packets outbound / $__interval',
          targets=[signals.virtualServer.clientsidePktsOut.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of packets sent by the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      virtualServerEphemeralPacketsInboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Ephemeral packets inbound / $__interval',
          targets=[signals.virtualServer.ephemeralPktsIn.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of ephemeral packets received by the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),

      virtualServerEphemeralPacketsOutboundTimeSeries:
        commonlib.panels.generic.timeSeries.base.new(
          'Ephemeral packets outbound / $__interval',
          targets=[signals.virtualServer.ephemeralPktsOut.asTarget() { interval+: '2m' }]
        )
        + g.panel.timeSeries.panelOptions.withDescription('The number of ephemeral packets sent by the virtual server.')
        + g.panel.timeSeries.standardOptions.withUnit('short'),
    },
}
