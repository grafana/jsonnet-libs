local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {
    local tsPanel = g.panel.timeSeries,
    local withTableLegend =
      tsPanel.options.legend.withPlacement('right')
      + tsPanel.options.legend.withDisplayMode('table')
      + tsPanel.options.legend.withCalcs(['lastNotNull', 'min', 'mean', 'max']),

    // Replica set state value mappings
    local replicaSetStateMappings =
      g.panel.stat.standardOptions.mapping.ValueMap.withType()
      + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
        '0': { index: 0, text: 'STARTUP' },
        '1': { index: 1, text: 'PRIMARY' },
        '2': { index: 2, text: 'SECONDARY' },
        '3': { index: 3, text: 'RECOVERING' },
        '5': { index: 4, text: 'STARTUP2' },
        '6': { index: 5, text: 'UNKNOWN' },
        '7': { index: 6, text: 'ARBITER' },
        '8': { index: 7, text: 'DOWN' },
        '9': { index: 8, text: 'ROLLBACK' },
        '10': { index: 9, text: 'REMOVED' },
      }),

    replicasetMembers:
      commonlib.panels.generic.stat.base.new(
        'Replica set members',
        targets=[signals.replicaset.replsetMembers.asTarget()],
        description='Number of replica set members.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    replicasetLastElection:
      commonlib.panels.generic.stat.base.new(
        'Replica set last election',
        targets=[signals.replicaset.lastElection.asTarget()],
        description='Time since the last replica set election.'
      )
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    replicasetAvgLag:
      commonlib.panels.generic.stat.base.new(
        'Average replica set lag',
        targets=[signals.replicaset.avgReplicationLag.asTarget()],
        description='Average replication lag across secondary members.'
      )
      + g.panel.stat.standardOptions.withUnit('s')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    replicasetVersions:
      commonlib.panels.generic.table.base.new(
        'MongoDB versions',
        targets=[
          signals.replicaset.versionInfo.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ],
        description='MongoDB server version information.'
      )
      + g.panel.table.standardOptions.withUnit('short')
      + g.panel.table.queryOptions.withTransformations([
        {
          id: 'organize',
          options: {
            excludeByName: { Time: true, Value: true, __name__: true, job: true },
          },
        },
      ]),

    replicasetStates:
      commonlib.panels.generic.statusHistory.base.new(
        'Replica set states',
        targets=[signals.replicaset.replsetStates.asTarget()],
        description='Current state of each replica set member over time.'
      )
      + g.panel.statusHistory.standardOptions.withMappings([replicaSetStateMappings])
      + g.panel.statusHistory.options.withShowValue('auto'),

    replicasetReplicationLag:
      commonlib.panels.generic.timeSeries.base.new(
        'Replication lag',
        targets=[signals.replicaset.replicationLag.asTarget()],
        description='Replication lag per secondary member.'
      )
      + withTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    replicasetOperations:
      commonlib.panels.generic.timeSeries.base.new(
        'Operations',
        targets=[
          signals.replicaset.replOpCountersRepl.asTarget(),
          signals.replicaset.replOpCountersMongod.asTarget(),
          signals.replicaset.replOpCountersTotal.asTarget(),
        ],
        description='Operations per second.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    replicasetElections:
      commonlib.panels.generic.timeSeries.base.new(
        'Elections',
        targets=[signals.replicaset.elections.asTarget()],
        description='Number of replica set elections.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    replicasetHeartbeatTime:
      commonlib.panels.generic.timeSeries.base.new(
        'Max heartbeat time',
        targets=[signals.replicaset.heartbeatTime.asTarget()],
        description='Time since last heartbeat from each member.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    replicasetMemberPing:
      commonlib.panels.generic.timeSeries.base.new(
        'Max member ping time',
        targets=[signals.replicaset.memberPing.asTarget()],
        description='Round-trip packet time to each member.'
      )
      + withTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('ms'),

    replicasetOplogBufferedOps:
      commonlib.panels.generic.timeSeries.base.new(
        'Oplog buffered operations',
        targets=[signals.replicaset.oplogBufferCount.asTarget()],
        description='Number of operations in the oplog buffer.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    replicasetOplogGetmoreTime:
      commonlib.panels.generic.timeSeries.base.new(
        'Oplog getmore time',
        targets=[signals.replicaset.oplogGetmoreTime.asTarget()],
        description='Rate of time spent on oplog getmore operations.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ms'),

    replicasetOplogRecoveryWindow:
      commonlib.panels.generic.timeSeries.base.new(
        'Oplog recovery window',
        targets=[
          signals.replicaset.oplogRecoveryNowToEnd.asTarget(),
          signals.replicaset.oplogRecoveryRange.asTarget(),
        ],
        description='Oplog time window.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    replicasetOplogProcessingTime:
      commonlib.panels.generic.timeSeries.base.new(
        'Oplog processing time',
        targets=[
          signals.replicaset.oplogProcessingDocPreload.asTarget(),
          signals.replicaset.oplogProcessingIndexPreload.asTarget(),
          signals.replicaset.oplogProcessingBatchApply.asTarget(),
        ],
        description='Rate of time spent on oplog processing.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ms'),

    replicasetOplogOperations:
      commonlib.panels.generic.timeSeries.base.new(
        'Oplog operations',
        targets=[
          signals.replicaset.oplogOpsDocPreload.asTarget(),
          signals.replicaset.oplogOpsIndexPreload.asTarget(),
          signals.replicaset.oplogOpsBatchApply.asTarget(),
        ],
        description='Rate of oplog operations.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),
  },
}
