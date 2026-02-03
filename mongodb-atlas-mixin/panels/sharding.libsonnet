local g = import '../g.libsonnet';
local commonlib = import 'common-lib/common/main.libsonnet';

{
  new(signals, config): {

    //
    // Sharding Overview dashboard panels
    //

    staleConfigErrors:
      commonlib.panels.generic.timeSeries.base.new('Stale configs / $__interval', targets=[
        signals.sharding.staleConfigErrors.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('Number of times that a thread hit a stale config exception and triggered a metadata refresh.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    chunkMigrations:
      commonlib.panels.generic.timeSeries.base.new('Chunk migrations / $__interval', targets=[
        signals.sharding.moveChunksStarted.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('Chunk migration frequency for this node.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    docsCloned:
      commonlib.panels.generic.timeSeries.base.new('Docs cloned / $__interval', targets=[
        signals.sharding.docsClonedDonor.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.sharding.docsClonedRecipient.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of documents cloned on this node when it acted as primary for the donor and acted as primary for the recipient.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    criticalSectionTime:
      commonlib.panels.generic.timeSeries.base.new('Critical section time / $__interval', targets=[
        signals.sharding.criticalSectionTime.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The time taken by the catch-up and update metadata phases of a range migration, by this node.')
      + g.panel.timeSeries.standardOptions.withUnit('ms')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    // Catalog cache panels
    catalogCacheRefreshesStarted:
      commonlib.panels.generic.timeSeries.base.new('Refreshes started / $__interval', targets=[
        signals.sharding.catalogCacheIncrementalRefreshes.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.sharding.catalogCacheFullRefreshes.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of incremental and full refreshes that have started.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc')
      + g.panel.timeSeries.fieldConfig.defaults.custom.stacking.withMode('normal'),

    catalogCacheRefreshesFailed:
      commonlib.panels.generic.timeSeries.base.new('Refreshes failed / $__interval', targets=[
        signals.sharding.catalogCacheFailedRefreshes.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of full and incremental refreshes that have failed.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catalogCacheStaleConfigs:
      commonlib.panels.generic.timeSeries.base.new('Cache stale configs / $__interval', targets=[
        signals.sharding.catalogCacheStaleConfigErrors.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of times that a thread hit a stale config exception for the catalog cache and triggered a metadata refresh.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catalogCacheEntries:
      commonlib.panels.generic.timeSeries.base.new('Cache entries / $__interval', targets=[
        signals.sharding.catalogCacheDatabaseEntries.asTarget()
        + g.query.prometheus.withInterval('2m'),
        signals.sharding.catalogCacheCollectionEntries.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The number of database and collection entries that are currently in the catalog cache.')
      + g.panel.timeSeries.standardOptions.withUnit('none')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catalogCacheRefreshTime:
      commonlib.panels.generic.timeSeries.base.new('Cache refresh time / $__interval', targets=[
        signals.sharding.catalogCacheRefreshWaitTime.asTarget()
        + g.query.prometheus.withInterval('2m'),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The amount of time that threads had to wait for a refresh of the metadata.')
      + g.panel.timeSeries.standardOptions.withUnit('µs')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    catalogCacheOperationsBlocked:
      commonlib.panels.generic.timeSeries.base.new('Cache operations blocked', targets=[
        signals.sharding.catalogCacheOpsBlocked.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of operations that are blocked by a refresh of the catalog cache. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    // Shard targeting operations panels
    shardTargetingAllShards:
      commonlib.panels.generic.timeSeries.base.new('All shards', targets=[
        signals.sharding.targetingFindAllShards.asTarget(),
        signals.sharding.targetingInsertAllShards.asTarget(),
        signals.sharding.targetingUpdateAllShards.asTarget(),
        signals.sharding.targetingDeleteAllShards.asTarget(),
        signals.sharding.targetingAggregateAllShards.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of CRUD operations and aggregation commands run that targeted all shards. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    shardTargetingManyShards:
      commonlib.panels.generic.timeSeries.base.new('Many shards', targets=[
        signals.sharding.targetingFindManyShards.asTarget(),
        signals.sharding.targetingInsertManyShards.asTarget(),
        signals.sharding.targetingUpdateManyShards.asTarget(),
        signals.sharding.targetingDeleteManyShards.asTarget(),
        signals.sharding.targetingAggregateManyShards.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of CRUD operations and aggregation commands run that targeted more than 1 shard. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    shardTargetingOneShard:
      commonlib.panels.generic.timeSeries.base.new('One shard', targets=[
        signals.sharding.targetingFindOneShard.asTarget(),
        signals.sharding.targetingInsertOneShard.asTarget(),
        signals.sharding.targetingUpdateOneShard.asTarget(),
        signals.sharding.targetingDeleteOneShard.asTarget(),
        signals.sharding.targetingAggregateOneShard.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of CRUD operations and aggregation commands run that targeted 1 shard. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),

    shardTargetingUnsharded:
      commonlib.panels.generic.timeSeries.base.new('Unsharded', targets=[
        signals.sharding.targetingFindUnsharded.asTarget(),
        signals.sharding.targetingInsertUnsharded.asTarget(),
        signals.sharding.targetingUpdateUnsharded.asTarget(),
        signals.sharding.targetingDeleteUnsharded.asTarget(),
        signals.sharding.targetingAggregateUnsharded.asTarget(),
      ])
      + g.panel.timeSeries.panelOptions.withDescription('The rate of CRUD operations and aggregation commands run on an unsharded collection. Specific to mongos nodes found under replica set "none".')
      + g.panel.timeSeries.standardOptions.withUnit('ops')
      + g.panel.timeSeries.options.legend.withPlacement('right')
      + g.panel.timeSeries.options.tooltip.withSort('desc'),
  },
}
