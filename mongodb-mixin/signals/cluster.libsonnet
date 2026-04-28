function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: [],
    enableLokiLogs: this.enableLokiLogs,

    aggLevel: 'group',
    aggFunction: 'avg',
    discoveryMetric: {
      percona_mongodb: 'mongodb_mongos_sharding_shards_total',
    },
    signals: {
      // Sharding overview
      shardsTotal: {
        name: '# of shards',
        description: 'Total number of shards.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_shards_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Shards',
          },
        },
      },
      shardedDbs: {
        name: 'Sharded DBs',
        description: 'Number of sharded databases.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_databases_total{%(queriesSelector)s, type="partitioned"}',
            legendCustomTemplate: 'Sharded DBs',
          },
        },
      },
      unshardedDbs: {
        name: 'Unsharded DBs',
        description: 'Number of unsharded databases.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_databases_total{%(queriesSelector)s, type="unpartitioned"}',
            legendCustomTemplate: 'Unsharded DBs',
          },
        },
      },
      drainingShards: {
        name: 'Draining shards',
        description: 'Number of shards currently being drained.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_shards_draining_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Draining shards',
          },
        },
      },
      shardedCollections: {
        name: 'Sharded collections',
        description: 'Total number of sharded collections.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_collections_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Sharded collections',
          },
        },
      },
      chunksTotal: {
        name: 'Chunks',
        description: 'Total number of chunks.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'sum',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_chunks_total{%(queriesSelector)s}',
            legendCustomTemplate: 'Chunks',
          },
        },
      },
      balancerEnabled: {
        name: 'Balancer enabled',
        description: 'Whether the balancer is enabled.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_balancer_enabled{%(queriesSelector)s}',
            legendCustomTemplate: 'Cluster balanced',
          },
        },
      },
      chunksBalanced: {
        name: 'Chunks balanced',
        description: 'Whether chunks are balanced across shards.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'min',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_chunks_is_balanced{%(queriesSelector)s}',
            legendCustomTemplate: 'Cluster balanced',
          },
        },
      },
      collectionsInShards: {
        name: 'Collections in shards',
        description: 'Number of collections per shard.',
        type: 'gauge',
        unit: 'short',
        aggFunction: 'max',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_db_collections_total{%(queriesSelector)s, db!~"admin|config"}',
            legendCustomTemplate: '{{db}} | {{shard}}',
            aggKeepLabels: ['db', 'shard'],
          },
        },
      },
      collectionSizeInShards: {
        name: 'Collection size in shards',
        description: 'Size of collections per shard.',
        type: 'gauge',
        unit: 'bytes',
        aggFunction: 'max',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_db_data_size_bytes{%(queriesSelector)s, db!~"admin|config"}',
            aggKeepLabels: ['db', 'shard'],
          },
        },
      },
      // QPS by service type
      shardServicesQps: {
        name: 'Shard services QPS',
        description: 'Queries per second for shard services.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: '(sum by (service_name) (irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval]))) * on (service_name) group_right avg by (service_name, set) (mongodb_mongod_replset_my_state{%(queriesSelector)s, set=~"$shard"} / mongodb_mongod_replset_my_state{%(queriesSelector)s, set=~"$shard"})',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      configServicesQps: {
        name: 'Config services QPS',
        description: 'Queries per second for config services.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: '(sum by (service_name) (irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval]))) * on (service_name) group_right avg by (service_name, set) (mongodb_mongod_replset_my_state{%(queriesSelector)s, set!~"$shard"} / mongodb_mongod_replset_my_state{%(queriesSelector)s, set!~"$shard"})',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      mongosServicesQps: {
        name: 'Mongos services QPS',
        description: 'Queries per second for mongos services.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: '(sum by (service_name) (rate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval]))) * on (service_name) group_right avg by (service_name) (avg by (service_name) (mongodb_mongos_db_collections_total{%(queriesSelector)s}) / avg by (service_name) (mongodb_mongos_db_collections_total{%(queriesSelector)s}))',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      // Chunks
      shardChunks: {
        name: '# of chunks in shards',
        description: 'Number of chunks per shard.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_sharding_shard_chunks_total{%(queriesSelector)s, db!~"admin|config"}',
            legendCustomTemplate: '{{shard}}',
            aggKeepLabels: ['shard', 'db'],
          },
        },
      },
      shardChunksDynamic: {
        name: 'Dynamic of chunks',
        description: 'Rate of change in chunk counts.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'irate(mongodb_mongos_sharding_shard_chunks_total{%(queriesSelector)s}[$__rate_interval])',
            legendCustomTemplate: '{{shard}}',
          },
        },
      },
      chunkSplitEvents: {
        name: 'Chunk split events',
        description: 'Rate of chunk split events.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'irate(mongodb_mongos_sharding_changelog_10min_total{%(queriesSelector)s, event=~".*split.*"}[$__rate_interval])',
            legendCustomTemplate: '{{event}}',
          },
        },
      },
      chunkMoveEvents: {
        name: 'Chunk move events',
        description: 'Rate of chunk move events.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'irate(mongodb_mongos_sharding_changelog_10min_total{%(queriesSelector)s, event=~".*moveChunk.*"}[$__rate_interval])',
            legendCustomTemplate: '{{event}}',
          },
        },
      },
      // Indexes
      indexesPerShard: {
        name: '# Indexes per shard',
        description: 'Number of indexes per shard and database.',
        type: 'gauge',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_db_indexes_total{%(queriesSelector)s, db!~"admin|config"}',
            legendCustomTemplate: '{{db}} | {{shard}}',
            aggKeepLabels: ['db', 'shard'],
          },
        },
      },
      indexesDynamic: {
        name: 'Dynamic of indexes',
        description: 'Rate of change in index counts.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'irate(mongodb_mongos_db_indexes_total{%(queriesSelector)s, db!~"admin|config"}[$__rate_interval])',
            legendCustomTemplate: '{{shard}}-{{db}}',
          },
        },
      },
      indexSizePerShard: {
        name: 'Size of indexes per shard',
        description: 'Size of indexes per shard and database.',
        type: 'gauge',
        unit: 'bytes',
        sources: {
          percona_mongodb: {
            expr: 'mongodb_mongos_db_index_size_bytes{%(queriesSelector)s, db!~"admin|config"}',
            legendCustomTemplate: '{{db}} | {{shard}}',
            aggKeepLabels: ['db', 'shard'],
          },
        },
      },
      indexSizeDynamic: {
        name: 'Dynamic of indexes size',
        description: 'Rate of change in index sizes.',
        type: 'raw',
        unit: 'Bps',
        sources: {
          percona_mongodb: {
            expr: 'rate(mongodb_mongos_db_index_size_bytes{%(queriesSelector)s, db!~"admin|config"}[$__rate_interval])',
            legendCustomTemplate: '{{shard}}-{{db}}',
          },
        },
      },
      // Connections
      connectionsCurrent: {
        name: 'Current connections',
        description: 'Current number of connections per instance.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'sum by (service_name) (max_over_time(mongodb_connections{%(queriesSelector)s, state="current"}[$__rate_interval]))',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      connectionsAvailable: {
        name: 'Available connections',
        description: 'Available connections per instance.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'sum by (service_name) (max_over_time(mongodb_connections{%(queriesSelector)s, state="available"}[$__rate_interval]))',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      connectionsPerShard: {
        name: 'Connections per shard',
        description: 'Current connections aggregated per shard.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'sum by (set) (avg by (service_name, set) (mongodb_connections{%(queriesSelector)s, state="current"}) * on (service_name) group_right avg by (service_name, set) (mongodb_mongod_replset_my_state{%(queriesSelector)s} / mongodb_mongod_replset_my_state{%(queriesSelector)s}))',
            legendCustomTemplate: '{{set}}',
          },
        },
      },
      // Operations
      opsPerShard: {
        name: 'Operations per shard',
        description: 'Operations per second aggregated by shard.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'sum(sum(irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval])) by (instance) * on (instance) group_right mongodb_mongod_replset_my_state{%(queriesSelector)s} / mongodb_mongod_replset_my_state{%(queriesSelector)s}) by (set)',
            legendCustomTemplate: '{{set}}',
          },
        },
      },
      opsByType: {
        name: 'Operations by type',
        description: 'Operations per second by type across the cluster.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'sum by (type) (irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command"}[$__rate_interval]))',
            legendCustomTemplate: '{{type}}',
          },
        },
      },
      opsByServiceName: {
        name: 'Operations by instance',
        description: 'Operations per second by instance.',
        type: 'raw',
        unit: 'ops',
        sources: {
          percona_mongodb: {
            expr: 'sum by (type) (irate(mongodb_op_counters_total{%(queriesSelector)s, type!="command", service_name=~"$service_name"}[$__rate_interval]))',
            legendCustomTemplate: '{{type}}',
          },
        },
      },
      // Cursors
      cursorsPerShard: {
        name: 'Cursors per shard',
        description: 'Total cursors aggregated by shard.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'sum(sum(mongodb_mongod_metrics_cursor_open{%(queriesSelector)s, state="total"} or mongodb_mongod_cursors{%(queriesSelector)s, state="total_open"}) by (service_name) * on (service_name) group_right mongodb_mongod_replset_my_state{%(queriesSelector)s} / mongodb_mongod_replset_my_state{%(queriesSelector)s}) by (set)',
            legendCustomTemplate: '{{set}}',
          },
        },
      },
      cursorsTotal: {
        name: 'MongoDB cursors',
        description: 'Total number of open cursors across the cluster.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'sum by () (max_over_time(mongodb_mongod_metrics_cursor_open{%(queriesSelector)s, state="total"}[$__rate_interval]) or max_over_time(mongodb_mongos_metrics_cursor_open{%(queriesSelector)s, state="total"}[$__rate_interval]) or max_over_time(mongodb_mongod_cursors{%(queriesSelector)s, state="total_open"}[$__rate_interval]) or max_over_time(mongodb_mongos_cursors{%(queriesSelector)s, state="total_open"}[$__rate_interval]))',
            legendCustomTemplate: 'Cursors',
          },
        },
      },
      cursorsByInstance: {
        name: 'Cursors by instance',
        description: 'Total cursors per instance.',
        type: 'raw',
        unit: 'short',
        sources: {
          percona_mongodb: {
            expr: 'sum by (service_name) (max_over_time(mongodb_mongod_metrics_cursor_open{%(queriesSelector)s, state="total"}[$__rate_interval]) or max_over_time(mongodb_mongos_metrics_cursor_open{%(queriesSelector)s, state="total"}[$__rate_interval]) or max_over_time(mongodb_mongod_cursors{%(queriesSelector)s, state="total_open"}[$__rate_interval]) or max_over_time(mongodb_mongos_cursors{%(queriesSelector)s, state="total_open"}[$__rate_interval]))',
            legendCustomTemplate: '{{service_name}}',
          },
        },
      },
      // Replication at cluster level
      replicationLagBySet: {
        name: 'Replication lag by set',
        description: 'Maximum replication lag per replica set.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'max by (set) (max(max_over_time(mongodb_mongod_replset_member_replication_lag{%(queriesSelector)s}[$__rate_interval]) > 0) by (service_name, set))',
            legendCustomTemplate: '{{set}}',
          },
        },
      },
      oplogRangeBySet: {
        name: 'Oplog window by set',
        description: 'Oplog time window per replica set.',
        type: 'raw',
        unit: 's',
        sources: {
          percona_mongodb: {
            expr: 'max(max(mongodb_mongod_replset_oplog_head_timestamp{%(queriesSelector)s} - mongodb_mongod_replset_oplog_tail_timestamp{%(queriesSelector)s}) by (service_name) * on (service_name) group_right mongodb_mongod_replset_my_state{%(queriesSelector)s} / mongodb_mongod_replset_my_state{%(queriesSelector)s}) by (set)',
            legendCustomTemplate: '{{set}}',
          },
        },
      },
    },
  }
