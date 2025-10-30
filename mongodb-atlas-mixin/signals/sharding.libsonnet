function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'sum',
    signals: {

      // General sharding statistics
      staleConfigErrors: {
        name: 'Stale config errors',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Stale config errors triggering metadata refresh.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_countStaleConfigErrors{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      moveChunksStarted: {
        name: 'Chunk migrations started as recipient',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Chunk migrations started as recipient.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_countRecipientMoveChunkStarted{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      docsClonedDonor: {
        name: 'Documents cloned on donor',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Documents cloned when acting as donor.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_countDocsClonedOnDonor{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - donor',
          },
        },
      },

      docsClonedRecipient: {
        name: 'Documents cloned on recipient',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Documents cloned when acting as recipient.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_countDocsClonedOnRecipient{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - recipient',
          },
        },
      },

      criticalSectionTime: {
        name: 'Critical section time',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Time in critical section during chunk migration.',
        unit: 'ms',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_totalCriticalSectionTimeMillis{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Catalog cache refreshes
      catalogCacheIncrementalRefreshes: {
        name: 'Incremental catalog cache refreshes',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Incremental catalog cache refreshes started.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_catalogCache_countIncrementalRefreshesStarted{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - incremental',
          },
        },
      },

      catalogCacheFullRefreshes: {
        name: 'Full catalog cache refreshes',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Full catalog cache refreshes started.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_catalogCache_countFullRefreshesStarted{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - full',
          },
        },
      },

      catalogCacheFailedRefreshes: {
        name: 'Failed catalog cache refreshes',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Failed catalog cache refreshes.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_catalogCache_countFailedRefreshes{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      catalogCacheStaleConfigErrors: {
        name: 'Catalog cache stale config errors',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Stale config errors in catalog cache.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_catalogCache_countStaleConfigErrors{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      catalogCacheDatabaseEntries: {
        name: 'Database entries in catalog cache',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Database entries in catalog cache.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_catalogCache_numDatabaseEntries{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - database',
          },
        },
      },

      catalogCacheCollectionEntries: {
        name: 'Collection entries in catalog cache',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Collection entries in catalog cache.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_catalogCache_numCollectionEntries{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - collection',
          },
        },
      },

      catalogCacheRefreshWaitTime: {
        name: 'Catalog cache refresh wait time',
        type: 'counter',
        rangeFunction: 'increase',
        description: 'Total time waiting for catalog cache refresh.',
        unit: 'µs',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_catalogCache_totalRefreshWaitTimeMicros{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      catalogCacheOpsBlocked: {
        name: 'Operations blocked by catalog cache refresh',
        type: 'counter',
        description: 'Operations blocked by catalog cache refresh.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_catalogCache_operationsBlockedByRefresh_countAllOperations{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}}',
          },
        },
      },

      // Targeting - allShards
      targetingFindAllShards: {
        name: 'Find operations targeting all shards',
        type: 'counter',
        description: 'Find operations targeting all shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_find_allShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - find',
          },
        },
      },

      targetingInsertAllShards: {
        name: 'Insert operations targeting all shards',
        type: 'counter',
        description: 'Insert operations targeting all shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_insert_allShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - insert',
          },
        },
      },

      targetingUpdateAllShards: {
        name: 'Update operations targeting all shards',
        type: 'counter',
        description: 'Update operations targeting all shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_update_allShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - update',
          },
        },
      },

      targetingDeleteAllShards: {
        name: 'Delete operations targeting all shards',
        type: 'counter',
        description: 'Delete operations targeting all shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_delete_allShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - delete',
          },
        },
      },

      targetingAggregateAllShards: {
        name: 'Aggregate operations targeting all shards',
        type: 'counter',
        description: 'Aggregate operations targeting all shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_aggregate_allShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - aggregate',
          },
        },
      },

      // Targeting - manyShards
      targetingFindManyShards: {
        name: 'Find operations targeting many shards',
        type: 'counter',
        description: 'Find operations targeting many shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_find_manyShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - find',
          },
        },
      },

      targetingInsertManyShards: {
        name: 'Insert operations targeting many shards',
        type: 'counter',
        description: 'Insert operations targeting many shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_insert_manyShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - insert',
          },
        },
      },

      targetingUpdateManyShards: {
        name: 'Update operations targeting many shards',
        type: 'counter',
        description: 'Update operations targeting many shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_update_manyShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - update',
          },
        },
      },

      targetingDeleteManyShards: {
        name: 'Delete operations targeting many shards',
        type: 'counter',
        description: 'Delete operations targeting many shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_delete_manyShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - delete',
          },
        },
      },

      targetingAggregateManyShards: {
        name: 'Aggregate operations targeting many shards',
        type: 'counter',
        description: 'Aggregate operations targeting many shards.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_aggregate_manyShards{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - aggregate',
          },
        },
      },

      // Targeting - oneShard
      targetingFindOneShard: {
        name: 'Find operations targeting one shard',
        type: 'counter',
        description: 'Find operations targeting one shard.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_find_oneShard{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - find',
          },
        },
      },

      targetingInsertOneShard: {
        name: 'Insert operations targeting one shard',
        type: 'counter',
        description: 'Insert operations targeting one shard.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_insert_oneShard{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - insert',
          },
        },
      },

      targetingUpdateOneShard: {
        name: 'Update operations targeting one shard',
        type: 'counter',
        description: 'Update operations targeting one shard.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_update_oneShard{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - update',
          },
        },
      },

      targetingDeleteOneShard: {
        name: 'Delete operations targeting one shard',
        type: 'counter',
        description: 'Delete operations targeting one shard.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_delete_oneShard{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - delete',
          },
        },
      },

      targetingAggregateOneShard: {
        name: 'Aggregate operations targeting one shard',
        type: 'counter',
        description: 'Aggregate operations targeting one shard.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_aggregate_oneShard{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - aggregate',
          },
        },
      },

      // Targeting - unsharded
      targetingFindUnsharded: {
        name: 'Find operations on unsharded collections',
        type: 'counter',
        description: 'Find operations on unsharded collections.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_find_unsharded{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - find',
          },
        },
      },

      targetingInsertUnsharded: {
        name: 'Insert operations on unsharded collections',
        type: 'counter',
        description: 'Insert operations on unsharded collections.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_insert_unsharded{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - insert',
          },
        },
      },

      targetingUpdateUnsharded: {
        name: 'Update operations on unsharded collections',
        type: 'counter',
        description: 'Update operations on unsharded collections.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_update_unsharded{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - update',
          },
        },
      },

      targetingDeleteUnsharded: {
        name: 'Delete operations on unsharded collections',
        type: 'counter',
        description: 'Delete operations on unsharded collections.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_delete_unsharded{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - delete',
          },
        },
      },

      targetingAggregateUnsharded: {
        name: 'Aggregate operations on unsharded collections',
        type: 'counter',
        description: 'Aggregate operations on unsharded collections.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'mongodb_shardingStatistics_numHostsTargeted_aggregate_unsharded{%(queriesSelector)s, rs_nm=~"$rs"}',
            legendCustomTemplate: '{{instance}} - aggregate',
          },
        },
      },
    },
  }
