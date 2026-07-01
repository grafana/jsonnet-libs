local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {
    local tsPanel = g.panel.timeSeries,
    local withStacking = tsPanel.fieldConfig.defaults.custom.stacking.withMode('normal'),

    // Replica set state value mappings
    local replicaSetStateMappings =
      g.panel.stat.standardOptions.mapping.ValueMap.withType()
      + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
        '0': { index: 0, text: 'STARTUP' },
        '1': { index: 1, text: 'PRIMARY (Healthy)' },
        '2': { index: 2, text: 'SECONDARY (Healthy)' },
        '3': { index: 3, text: 'RECOVERING' },
        '5': { index: 4, text: 'STARTUP2' },
        '6': { index: 5, text: 'UNKNOWN' },
        '7': { index: 6, text: 'ARBITER' },
        '8': { index: 7, text: 'DOWN' },
        '9': { index: 8, text: 'ROLLBACK' },
        '10': { index: 9, text: 'REMOVED' },
      }),

    instanceUptime:
      commonlib.panels.generic.stat.base.new(
        'Uptime',
        targets=[signals.instance.uptime.asTarget()],
        description='The uptime of the MongoDB instance.'
      )
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    instanceQps:
      commonlib.panels.generic.stat.base.new(
        'QPS',
        targets=[signals.instance.qps.asTarget()],
        description='Queries per second.'
      )
      + g.panel.stat.standardOptions.withUnit('ops')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    instanceReplicaSetState:
      commonlib.panels.generic.stat.base.new(
        'Replica set',
        targets=[signals.instance.replicaSetState.asTarget()],
        description='Current replica set state of the member (for example PRIMARY or SECONDARY). See https://www.mongodb.com/docs/manual/reference/replica-states/ for the meaning of each value.'
      )
      + g.panel.stat.standardOptions.withMappings([replicaSetStateMappings])
      + g.panel.stat.standardOptions.withDisplayName('${__field.labels.service_name}')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    instanceLatency:
      commonlib.panels.generic.stat.base.new(
        'Latency',
        targets=[signals.instance.commandLatency.asTarget()],
        description='Average command latency.'
      )
      + g.panel.stat.standardOptions.withUnit('µs')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    instanceReplicaSetStateGauge:
      commonlib.panels.generic.stat.base.new(
        'Current replica set state',
        targets=[signals.instance.replicaSetState.asTarget()],
        description='Current state of the replica set member.'
      )
      + g.panel.stat.standardOptions.withMappings([replicaSetStateMappings])
      + g.panel.stat.standardOptions.withDisplayName('${__field.labels.service_name}')
      + g.panel.stat.options.withGraphMode('none')
      + g.panel.stat.standardOptions.color.withMode('thresholds')
      + g.panel.stat.standardOptions.thresholds.withSteps([
        g.panel.stat.standardOptions.threshold.step.withColor('green')
        + g.panel.stat.standardOptions.threshold.step.withValue(null),
        g.panel.stat.standardOptions.threshold.step.withColor('green')
        + g.panel.stat.standardOptions.threshold.step.withValue(1),
        g.panel.stat.standardOptions.threshold.step.withColor('blue')
        + g.panel.stat.standardOptions.threshold.step.withValue(2),
        g.panel.stat.standardOptions.threshold.step.withColor('orange')
        + g.panel.stat.standardOptions.threshold.step.withValue(3),
        g.panel.stat.standardOptions.threshold.step.withColor('red')
        + g.panel.stat.standardOptions.threshold.step.withValue(8),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

    instanceCommandOps:
      commonlib.panels.generic.timeSeries.base.new(
        'Command operations',
        targets=[
          signals.instance.opCountersTotal.asTarget(),
          signals.instance.opCountersReplTotal.asTarget(),
          signals.instance.ttlDeletedDocuments.asTarget(),
        ],
        description='Rate of command operations by type.'
      )
      + withStacking
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceConnections:
      commonlib.panels.generic.timeSeries.base.new(
        'Connections',
        targets=[signals.instance.connectionsCurrent.asTarget()],
        description='Number of current connections.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    instanceDocumentOps:
      commonlib.panels.generic.timeSeries.base.new(
        'Document operations',
        targets=[signals.instance.documentOps.asTarget()],
        description='Rate of document operations by state.'
      )
      + withStacking
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceLatencyDetail:
      commonlib.panels.generic.timeSeries.base.new(
        'Latency detail',
        targets=[signals.instance.latencyDetail.asTarget()],
        description='Average operation latency by type.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('µs'),

    instanceQueuedOps:
      commonlib.panels.generic.timeSeries.base.new(
        'Queued operations',
        targets=[signals.instance.queuedOps.asTarget()],
        description='Number of operations queued due to a lock.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    instanceCursors:
      commonlib.panels.generic.timeSeries.base.new(
        'Cursors',
        targets=[signals.instance.cursorsOpen.asTarget()],
        description='Number of open cursors by state.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    instanceScannedAndMoved:
      commonlib.panels.generic.timeSeries.base.new(
        'Scanned and moved objects',
        targets=[
          signals.instance.queryExecutor.asTarget(),
          signals.instance.recordMoves.asTarget(),
        ],
        description='Rate of scanned objects and record moves.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceAsserts:
      commonlib.panels.generic.timeSeries.base.new(
        'Assert events',
        targets=[signals.instance.asserts.asTarget()],
        description='Rate of assert events by type.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceGetLastErrorWriteOps:
      commonlib.panels.generic.timeSeries.base.new(
        'getLastError write operations',
        targets=[
          signals.instance.getLastErrorNum.asTarget(),
          signals.instance.getLastErrorTimeouts.asTarget(),
        ],
        description='Rate of getLastError write operations and timeouts.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    instanceQueryEfficiency:
      commonlib.panels.generic.timeSeries.base.new(
        'Query efficiency',
        targets=[
          signals.instance.queryEfficiencyDoc.asTarget(),
          signals.instance.queryEfficiencyIndex.asTarget(),
        ],
        description='Ratio of documents returned vs scanned, and index usage.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('percentunit'),

    instanceGetLastErrorWriteTime:
      commonlib.panels.generic.timeSeries.base.new(
        'getLastError write time',
        targets=[signals.instance.getLastErrorWriteTime.asTarget()],
        description='Rate of getLastError write wait time.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ms'),

    instancePageFaults:
      commonlib.panels.generic.timeSeries.base.new(
        'Page faults',
        targets=[signals.instance.pageFaults.asTarget()],
        description='Rate of page faults.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),
  },
}
