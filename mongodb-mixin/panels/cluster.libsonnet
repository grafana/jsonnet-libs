local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {
    local tsPanel = g.panel.timeSeries,
    local withTableLegend =
      tsPanel.options.legend.withPlacement('right')
      + tsPanel.options.legend.withDisplayMode('table')
      + tsPanel.options.legend.withCalcs(['lastNotNull', 'min', 'mean', 'max']),
    // For low-cardinality panels (a handful of series): keep the table columns but place them below the graph.
    local withBottomTableLegend =
      tsPanel.options.legend.withPlacement('bottom')
      + tsPanel.options.legend.withDisplayMode('table')
      + tsPanel.options.legend.withCalcs(['lastNotNull', 'min', 'mean', 'max']),
    local withStacking = tsPanel.fieldConfig.defaults.custom.stacking.withMode('normal'),

    local shardTableColumns(valueName) =
      g.panel.table.queryOptions.withTransformationsMixin([
        {
          id: 'organize',
          options: {
            excludeByName: { Time: true },
            renameByName: { shard: 'Shard', db: 'Database', Value: valueName },
          },
        },
      ]),

    // Sharding overview stats
    clusterShardsTotal:
      commonlib.panels.generic.stat.base.new(
        'Total shards',
        targets=[signals.cluster.shardsTotal.asTarget()],
        description='Total number of shards.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    clusterShardedDbs:
      commonlib.panels.generic.stat.base.new(
        'Sharded DBs',
        targets=[signals.cluster.shardedDbs.asTarget()],
        description='Number of sharded databases.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    clusterUnshardedDbs:
      commonlib.panels.generic.stat.base.new(
        'Unsharded DBs',
        targets=[signals.cluster.unshardedDbs.asTarget()],
        description='Number of unsharded databases.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    clusterDrainingShards:
      commonlib.panels.generic.stat.base.new(
        'Draining shards',
        targets=[signals.cluster.drainingShards.asTarget()],
        description='Number of shards being drained.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    clusterShardedCollections:
      commonlib.panels.generic.stat.base.new(
        'Sharded collections',
        targets=[signals.cluster.shardedCollections.asTarget()],
        description='Total number of sharded collections.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    clusterChunksTotal:
      commonlib.panels.generic.stat.base.new(
        'Chunks',
        targets=[signals.cluster.chunksTotal.asTarget()],
        description='Total number of chunks.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    clusterBalancerEnabled:
      commonlib.panels.generic.stat.base.new(
        'Balancer enabled',
        targets=[signals.cluster.balancerEnabled.asTarget()],
        description='Whether the balancer is enabled.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withMappings([
        g.panel.stat.standardOptions.mapping.ValueMap.withType()
        + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
          '0': { index: 0, text: 'Disabled', color: 'red' },
          '1': { index: 1, text: 'Enabled', color: 'green' },
        }),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    clusterBalancerRunning:
      commonlib.panels.generic.stat.base.new(
        'Balancer running',
        targets=[signals.cluster.balancerRunning.asTarget()],
        description='Whether the balancer is currently running.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.standardOptions.withMappings([
        g.panel.stat.standardOptions.mapping.ValueMap.withType()
        + g.panel.stat.standardOptions.mapping.ValueMap.withOptions({
          '0': { index: 0, text: 'Idle', color: 'green' },
          '1': { index: 1, text: 'Running', color: 'blue' },
        }),
      ])
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull'])
      + g.panel.stat.options.withGraphMode('none'),

    // Tables
    clusterCollectionsInShardsTable:
      commonlib.panels.generic.table.base.new(
        'Number of collections in shards',
        targets=[
          signals.cluster.collectionsInShards.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ],
        description='Number of collections per shard and database.'
      )
      + g.panel.table.standardOptions.withUnit('short')
      + shardTableColumns('Collections'),

    clusterCollectionSizeInShardsTable:
      commonlib.panels.generic.table.base.new(
        'Size of collections in shards',
        targets=[
          signals.cluster.collectionSizeInShards.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ],
        description='Size of collections per shard and database.'
      )
      + g.panel.table.standardOptions.withUnit('bytes')
      + shardTableColumns('Collection size'),

    // QPS by service type
    clusterShardServicesQps:
      commonlib.panels.generic.timeSeries.base.new(
        'Shard services QPS - $shard',
        targets=[signals.cluster.shardServicesQps.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Queries per second for shard services.'
      )
      + withBottomTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.panelOptions.withRepeat('shard'),

    clusterConfigServicesQps:
      commonlib.panels.generic.timeSeries.base.new(
        'Config services QPS',
        targets=[signals.cluster.configServicesQps.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Queries per second for config services.'
      )
      + withTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    clusterMongosServicesQps:
      commonlib.panels.generic.timeSeries.base.new(
        'Mongos services QPS',
        targets=[signals.cluster.mongosServicesQps.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Queries per second for mongos services.'
      )
      + withTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    // Chunks
    clusterChunksInShardsTable:
      commonlib.panels.generic.table.base.new(
        'Number of chunks per shard',
        targets=[
          signals.cluster.shardChunks.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ],
        description='Number of chunks per shard.'
      )
      + g.panel.table.standardOptions.withUnit('short')
      + shardTableColumns('Chunks'),

    clusterChunksDynamic:
      commonlib.panels.generic.timeSeries.base.new(
        'Chunk count change rate',
        targets=[signals.cluster.shardChunksDynamic.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of change in chunk counts.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    clusterChunkSplitEvents:
      commonlib.panels.generic.timeSeries.base.new(
        'Chunk split events',
        targets=[signals.cluster.chunkSplitEvents.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of chunk split events.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    clusterChunkMoveEvents:
      commonlib.panels.generic.timeSeries.base.new(
        'Chunk move events',
        targets=[signals.cluster.chunkMoveEvents.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of chunk move events.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    // Indexes
    clusterIndexesPerShardTable:
      commonlib.panels.generic.table.base.new(
        'Number of indexes per shard',
        targets=[
          signals.cluster.indexesPerShard.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ],
        description='Number of indexes per shard and database.'
      )
      + g.panel.table.standardOptions.withUnit('short')
      + shardTableColumns('Indexes'),

    clusterIndexesDynamic:
      commonlib.panels.generic.timeSeries.base.new(
        'Index count change rate',
        targets=[signals.cluster.indexesDynamic.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of change in index counts.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    clusterIndexSizePerShardTable:
      commonlib.panels.generic.table.base.new(
        'Size of indexes per shard',
        targets=[
          signals.cluster.indexSizePerShard.asTarget()
          + g.query.prometheus.withInstant(true)
          + g.query.prometheus.withFormat('table'),
        ],
        description='Size of indexes per shard and database.'
      )
      + g.panel.table.standardOptions.withUnit('bytes')
      + shardTableColumns('Index size'),

    clusterIndexSizeDynamic:
      commonlib.panels.generic.timeSeries.base.new(
        'Index size change rate',
        targets=[signals.cluster.indexSizeDynamic.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Rate of change in index sizes.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('Bps'),

    // Connections
    clusterConnectionsCurrent:
      commonlib.panels.generic.timeSeries.base.new(
        'Current connections per instance',
        targets=[signals.cluster.connectionsCurrent.asTarget()],
        description='Current number of connections per instance.'
      )
      + withBottomTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    clusterConnectionsAvailable:
      commonlib.panels.generic.timeSeries.base.new(
        'Available connections per instance',
        targets=[signals.cluster.connectionsAvailable.asTarget()],
        description='Available connections per instance.'
      )
      + withBottomTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    clusterConnectionsPerShard:
      commonlib.panels.generic.timeSeries.base.new(
        'Current connections per shard',
        targets=[signals.cluster.connectionsPerShard.asTarget()],
        description='Current connections aggregated per shard.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    // Operations
    clusterOpsPerShard:
      commonlib.panels.generic.timeSeries.base.new(
        'Operations per shard',
        targets=[signals.cluster.opsPerShard.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Operations per second aggregated by shard.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    clusterOpsByType:
      commonlib.panels.generic.timeSeries.base.new(
        'Operations by type',
        targets=[signals.cluster.opsByType.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Operations per second by type.'
      )
      + withStacking
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    clusterOpsByServiceName:
      commonlib.panels.generic.timeSeries.base.new(
        'Operations $service_name',
        targets=[signals.cluster.opsByServiceName.asTarget() + g.query.prometheus.withInterval('2m')],
        description='Operations per second for selected instance.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('ops'),

    // Cursors
    clusterCursorsPerShard:
      commonlib.panels.generic.timeSeries.base.new(
        'Cursors per shard',
        targets=[signals.cluster.cursorsPerShard.asTarget()],
        description='Total cursors aggregated by shard.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    clusterCursorsTotal:
      commonlib.panels.generic.stat.base.new(
        'MongoDB cursors',
        targets=[signals.cluster.cursorsTotal.asTarget()],
        description='Total number of open cursors across the cluster.'
      )
      + g.panel.stat.standardOptions.withUnit('short')
      + g.panel.stat.options.reduceOptions.withCalcs(['lastNotNull']),

    clusterCursorsByInstance:
      commonlib.panels.generic.timeSeries.base.new(
        'Cursors by instance',
        targets=[signals.cluster.cursorsByInstance.asTarget()],
        description='Cursors per instance.'
      )
      + withBottomTableLegend
      + g.panel.timeSeries.standardOptions.withUnit('short'),

    // Additional info
    clusterReplicationLagBySet:
      commonlib.panels.generic.timeSeries.base.new(
        'Replication lag by set',
        targets=[signals.cluster.replicationLagBySet.asTarget()],
        description='Maximum replication lag per replica set.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('s'),

    clusterOplogRangeBySet:
      commonlib.panels.generic.timeSeries.base.new(
        'Replication lag by set oplog window',
        targets=[signals.cluster.oplogRangeBySet.asTarget()],
        description='Oplog time window per replica set.'
      )
      + g.panel.timeSeries.standardOptions.withUnit('s'),
  },
}
