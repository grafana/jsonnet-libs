function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: ['solr_cluster'],
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'solr_collections_live_nodes',
    },
    signals: {
      liveNodes: {
        name: 'Live nodes',
        nameShort: 'Live nodes',
        type: 'raw',
        description: 'Number of live nodes in the Solr cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'min by (job, solr_cluster) (solr_collections_live_nodes{%(queriesSelector)s})',
            legendCustomTemplate: '{{solr_cluster}}',
          },
        },
      },
      zookeeperStatus: {
        name: 'Zookeeper status',
        nameShort: 'ZK status',
        type: 'raw',
        description: 'Status of ZooKeeper, integral for cluster coordination.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'solr_zookeeper_status{%(queriesSelector)s}',
            legendCustomTemplate: '{{zk_host}}',
          },
        },
      },
      zookeeperEnsembleSize: {
        name: 'Zookeeper ensemble size',
        nameShort: 'ZK ensemble size',
        type: 'gauge',
        description: 'Size of the ZooKeeper ensemble.',
        unit: 'none',
        aggLevel: 'none',
        sources: {
          prometheus: {
            expr: 'solr_zookeeper_ensemble_size{%(queriesSelector)s}',
            legendCustomTemplate: '{{zk_host}}',
          },
        },
      },
      shardState: {
        name: 'Running shards',
        nameShort: 'Running shards',
        type: 'raw',
        description: 'Percent of running shards in the cluster.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum(solr_collections_shard_state{%(queriesSelector)s}) / count(solr_collections_shard_state{%(queriesSelector)s})',
            legendCustomTemplate: '{{solr_cluster}}',
          },
        },
      },
      shardStateTable: {
        name: 'Shard status',
        nameShort: 'Shard status',
        type: 'raw',
        description: 'Shows the state of various shards in the cluster.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'solr_collections_shard_state{%(queriesSelector)s}',
            legendCustomTemplate: '{{shard}}',
          },
        },
      },
      replicaState: {
        name: 'Running replicas',
        nameShort: 'Running replicas',
        type: 'raw',
        description: 'Shows the total percent of running replicas in the cluster.',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum(solr_collections_replica_state{%(queriesSelector)s}) / count(solr_collections_replica_state{%(queriesSelector)s})',
            legendCustomTemplate: '{{solr_cluster}}',
          },
        },
      },
      replicaStateTable: {
        name: 'Replica status',
        nameShort: 'Replica status',
        type: 'raw',
        description: 'State of replicas within a Solr collection.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'solr_collections_replica_state{%(queriesSelector)s}',
            legendCustomTemplate: '{{core}}',
          },
        },
      },
    },
  }
