local g = import './g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(this)::
    {
      local signals = this.signals,
      local vars = this.grafana.variables,

      //
      // Cluster Overview Panels
      //
      nodeAvailability:
        g.panel.gauge.new('Node availability')
        + g.panel.gauge.panelOptions.withDescription('The percentage of nodes available.')
        + g.panel.gauge.queryOptions.withTargets([
          signals.system.nodeAvailabilityPercentage.asTarget(),
        ])
        + g.panel.gauge.standardOptions.withUnit('percent')
        + g.panel.gauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('red')
          + g.panel.gauge.thresholdStep.withValue(null),
          g.panel.gauge.thresholdStep.withColor('red')
          + g.panel.gauge.thresholdStep.withValue(95),
          g.panel.gauge.thresholdStep.withColor('yellow')
          + g.panel.gauge.thresholdStep.withValue(96),
          g.panel.gauge.thresholdStep.withColor('green')
          + g.panel.gauge.thresholdStep.withValue(100),
        ]),

      poolAvailability:
        g.panel.gauge.new('Pool availability')
        + g.panel.gauge.panelOptions.withDescription('The percentage of pools available.')
        + g.panel.gauge.queryOptions.withTargets([
          signals.system.poolAvailabilityPercentage.asTarget(),
        ])
        + g.panel.gauge.standardOptions.withUnit('percent')
        + g.panel.gauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('red')
          + g.panel.gauge.thresholdStep.withValue(null),
          g.panel.gauge.thresholdStep.withColor('red')
          + g.panel.gauge.thresholdStep.withValue(95),
          g.panel.gauge.thresholdStep.withColor('yellow')
          + g.panel.gauge.thresholdStep.withValue(96),
          g.panel.gauge.thresholdStep.withColor('green')
          + g.panel.gauge.thresholdStep.withValue(100),
        ]),

      virtualServerAvailability:
        g.panel.gauge.new('Virtual server availability')
        + g.panel.gauge.panelOptions.withDescription('The percentage of virtual servers available.')
        + g.panel.gauge.queryOptions.withTargets([
          signals.system.virtualServerAvailabilityPercentage.asTarget(),
        ])
        + g.panel.gauge.standardOptions.withUnit('percent')
        + g.panel.gauge.standardOptions.thresholds.withMode('absolute')
        + g.panel.gauge.standardOptions.thresholds.withSteps([
          g.panel.gauge.thresholdStep.withColor('red')
          + g.panel.gauge.thresholdStep.withValue(null),
          g.panel.gauge.thresholdStep.withColor('red')
          + g.panel.gauge.thresholdStep.withValue(95),
          g.panel.gauge.thresholdStep.withColor('yellow')
          + g.panel.gauge.thresholdStep.withValue(96),
          g.panel.gauge.thresholdStep.withColor('green')
          + g.panel.gauge.thresholdStep.withValue(100),
        ]),

      topActiveServersideNodes:
        g.panel.barGauge.new('Top active serverside nodes')
        + g.panel.barGauge.panelOptions.withDescription('Nodes with the highest number of active serverside connections.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.nodes.topActiveServersideNodes.asTarget(),
        ])
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('green')
          + g.panel.barGauge.thresholdStep.withValue(null),
        ])
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withShowUnfilled(true),

      topOutboundTrafficNodes:
        g.panel.barGauge.new('Top outbound traffic nodes / $__interval')
        + g.panel.barGauge.panelOptions.withDescription('Nodes with the highest outbound traffic.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.nodes.topOutboundTrafficNodes.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.barGauge.standardOptions.withUnit('decbytes')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('green')
          + g.panel.barGauge.thresholdStep.withValue(null),
        ])
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withShowUnfilled(true),

      topActiveMembersInPools:
        g.panel.barGauge.new('Top active members in pools')
        + g.panel.barGauge.panelOptions.withDescription('Pools with the highest number of active members.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.pools.topActiveMembersInPools.asTarget(),
        ])
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('green')
          + g.panel.barGauge.thresholdStep.withValue(null),
        ])
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withShowUnfilled(true),

      topRequestedPools:
        g.panel.barGauge.new('Top requested pools / $__interval')
        + g.panel.barGauge.panelOptions.withDescription('Pools with the highest number of requests.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.pools.topRequestedPools.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('green')
          + g.panel.barGauge.thresholdStep.withValue(null),
        ])
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withShowUnfilled(true),

      topQueueDepthPools:
        g.panel.barGauge.new('Top queue depth pools')
        + g.panel.barGauge.panelOptions.withDescription('Pools with the highest connection queue depth.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.pools.topQueueDepth.asTarget(),
        ])
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('green')
          + g.panel.barGauge.thresholdStep.withValue(null),
        ])
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withShowUnfilled(true),

      topUtilizedVirtualServers:
        g.panel.barGauge.new('Top utilized virtual servers')
        + g.panel.barGauge.panelOptions.withDescription('Virtual servers with the highest number of current clientside connections.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.virtualServers.topUtilizedVirtualServers.asTarget(),
        ])
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('green')
          + g.panel.barGauge.thresholdStep.withValue(null),
        ])
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withShowUnfilled(true),

      topLatencyVirtualServers:
        g.panel.barGauge.new('Top latency virtual servers')
        + g.panel.barGauge.panelOptions.withDescription('Virtual servers with the highest mean connection duration.')
        + g.panel.barGauge.queryOptions.withTargets([
          signals.virtualServers.topLatencyVirtualServers.asTarget(),
        ])
        + g.panel.barGauge.standardOptions.withUnit('ms')
        + g.panel.barGauge.standardOptions.withMin(0)
        + g.panel.barGauge.standardOptions.thresholds.withSteps([
          g.panel.barGauge.thresholdStep.withColor('green')
          + g.panel.barGauge.thresholdStep.withValue(null),
        ])
        + g.panel.barGauge.options.withDisplayMode('gradient')
        + g.panel.barGauge.options.withOrientation('horizontal')
        + g.panel.barGauge.options.withShowUnfilled(true),

      //
      // Node Overview Panels
      //
      nodeAvailabilityStatus:
        g.panel.table.new('Availability status')
        + g.panel.table.panelOptions.withDescription('The availability status of the node.')
        + g.panel.table.queryOptions.withTargets([
          signals.nodes.statusAvailabilityState.asTarget()
          + g.query.prometheus.withIntervalFactor(2)
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ])
        + g.panel.table.standardOptions.withMappings([
          g.panel.table.standardOptions.mapping.ValueMap.withType()
          + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
            '0': { color: 'red', index: 1, text: 'Unavailable' },
            '1': { color: 'green', index: 0, text: 'Available' },
          }),
        ])
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byName.new('Time')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('__name__')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('partition')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance'),
          g.panel.table.fieldOverride.byName.new('node')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Node'),
          g.panel.table.fieldOverride.byName.new('Value')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Status'),
        ]),

      nodeCurrentSessions:
        g.panel.timeSeries.new('Current sessions')
        + g.panel.timeSeries.panelOptions.withDescription('The number of current sessions on the node.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.nodes.currentSessions.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      nodeRequests:
        g.panel.timeSeries.new('Requests / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of requests made to the node.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.nodes.totalRequests.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      nodeServersideBytesIn:
        g.panel.timeSeries.new('Serverside bytes in / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of bytes received on the serverside.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.nodes.serversideBytesIn.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      nodeServersideBytesOut:
        g.panel.timeSeries.new('Serverside bytes out / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of bytes sent on the serverside.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.nodes.serversideBytesOut.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      nodeServersideCurrentConnections:
        g.panel.timeSeries.new('Serverside current connections')
        + g.panel.timeSeries.panelOptions.withDescription('The number of current serverside connections on the node.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.nodes.serversideCurrentConnections.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      nodeServersideMaxConnections:
        g.panel.timeSeries.new('Serverside max connections')
        + g.panel.timeSeries.panelOptions.withDescription('The maximum number of serverside connections on the node.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.nodes.serversideMaxConnections.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      //
      // Pool Overview Panels
      //
      poolAvailabilityStatus:
        g.panel.table.new('Availability status')
        + g.panel.table.panelOptions.withDescription('The availability status of the pool.')
        + g.panel.table.queryOptions.withTargets([
          signals.pools.statusAvailabilityState.asTarget()
          + g.query.prometheus.withIntervalFactor(2)
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ])
        + g.panel.table.standardOptions.withMappings([
          g.panel.table.standardOptions.mapping.ValueMap.withType()
          + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
            '0': { color: 'red', index: 1, text: 'Unavailable' },
            '1': { color: 'green', index: 0, text: 'Available' },
          }),
        ])
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byName.new('Time')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('__name__')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('partition')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance'),
          g.panel.table.fieldOverride.byName.new('pool')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Pool'),
          g.panel.table.fieldOverride.byName.new('Value')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Status'),
        ]),

      poolActiveMemberCount:
        g.panel.timeSeries.new('Active member count')
        + g.panel.timeSeries.panelOptions.withDescription('The number of active members in the pool.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.pools.activeMemberCount.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      poolConnectionQueueDepth:
        g.panel.timeSeries.new('Connection queue depth')
        + g.panel.timeSeries.panelOptions.withDescription('The depth of the connection queue.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.pools.connectionQueueDepth.asTarget(),
        ])
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      poolRequests:
        g.panel.timeSeries.new('Requests / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of requests made to the pool.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.pools.totalRequests.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      poolServersideBytesIn:
        g.panel.timeSeries.new('Serverside bytes in / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of bytes received on the serverside.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.pools.serversideBytesIn.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      poolServersideBytesOut:
        g.panel.timeSeries.new('Serverside bytes out / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of bytes sent on the serverside.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.pools.serversideBytesOut.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      poolServersideCurrentConnections:
        g.panel.timeSeries.new('Serverside current connections')
        + g.panel.timeSeries.panelOptions.withDescription('The number of current serverside connections on the pool.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.pools.serversideCurrentConnections.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      //
      // Virtual Server Overview Panels
      //
      virtualServerAvailabilityStatus:
        g.panel.table.new('Availability status')
        + g.panel.table.panelOptions.withDescription('The availability status of the virtual server.')
        + g.panel.table.queryOptions.withTargets([
          signals.virtualServers.statusAvailabilityState.asTarget()
          + g.query.prometheus.withIntervalFactor(2)
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ])
        + g.panel.table.standardOptions.withMappings([
          g.panel.table.standardOptions.mapping.ValueMap.withType()
          + g.panel.table.standardOptions.mapping.ValueMap.withOptions({
            '0': { color: 'red', index: 1, text: 'Unavailable' },
            '1': { color: 'green', index: 0, text: 'Available' },
          }),
        ])
        + g.panel.table.standardOptions.withOverrides([
          g.panel.table.fieldOverride.byName.new('Time')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('job')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('__name__')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('partition')
          + g.panel.table.fieldOverride.byName.withProperty('custom.hidden', true),
          g.panel.table.fieldOverride.byName.new('instance')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Instance'),
          g.panel.table.fieldOverride.byName.new('virtual_server')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Virtual Server'),
          g.panel.table.fieldOverride.byName.new('Value')
          + g.panel.table.fieldOverride.byName.withProperty('displayName', 'Status'),
        ]),

      virtualServerClientsideCurrentConnections:
        g.panel.timeSeries.new('Clientside current connections')
        + g.panel.timeSeries.panelOptions.withDescription('The number of current clientside connections on the virtual server.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.virtualServers.clientsideCurrentConnections.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      virtualServerRequests:
        g.panel.timeSeries.new('Requests / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of requests made to the virtual server.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.virtualServers.totalRequests.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      virtualServerClientsideBytesIn:
        g.panel.timeSeries.new('Clientside bytes in / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of bytes received on the clientside.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.virtualServers.clientsideBytesIn.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      virtualServerClientsideBytesOut:
        g.panel.timeSeries.new('Clientside bytes out / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of bytes sent on the clientside.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.virtualServers.clientsideBytesOut.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      virtualServerMeanConnectionDuration:
        g.panel.timeSeries.new('Mean connection duration')
        + g.panel.timeSeries.panelOptions.withDescription('The mean connection duration on the virtual server.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.virtualServers.meanConnectionDuration.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('ms')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      virtualServerEphemeralCurrentConnections:
        g.panel.timeSeries.new('Ephemeral current connections')
        + g.panel.timeSeries.panelOptions.withDescription('The number of current ephemeral connections on the virtual server.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.virtualServers.ephemeralCurrentConnections.asTarget(),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('short')
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      virtualServerEphemeralBytesIn:
        g.panel.timeSeries.new('Ephemeral bytes in / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of ephemeral bytes received.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.virtualServers.ephemeralBytesIn.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),

      virtualServerEphemeralBytesOut:
        g.panel.timeSeries.new('Ephemeral bytes out / $__interval')
        + g.panel.timeSeries.panelOptions.withDescription('The number of ephemeral bytes sent.')
        + g.panel.timeSeries.queryOptions.withTargets([
          signals.virtualServers.ephemeralBytesOut.asTarget()
          + g.query.prometheus.withInterval('1m'),
        ])
        + g.panel.timeSeries.standardOptions.withUnit('bytes')
        + g.panel.timeSeries.fieldConfig.defaults.custom.withFillOpacity(30)
        + g.panel.timeSeries.options.legend.withDisplayMode('list')
        + g.panel.timeSeries.options.legend.withPlacement('bottom'),
    },
}
