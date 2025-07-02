local commonlib = import 'common-lib/common/main.libsonnet';

function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '2m',
    discoveryMetric: {
      prometheus: 'ClickHouseMetrics_InterserverConnection',
    },
    signals: {
      interserverConnections: {
        name: 'Interserver connections',
        nameShort: 'Interserver',
        type: 'gauge',
        description: 'Number of connections due to interserver communication.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_InterserverConnection{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Interserver connections',
          },
        },
      },
      replicasMaxQueueSize: {
        name: 'Replica queue size',
        nameShort: 'Queue size',
        type: 'gauge',
        description: 'Number of replica tasks in queue.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseAsyncMetrics_ReplicasMaxQueueSize{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Max queue size',
          },
        },
      },
      replicatedPartFetches: {
        name: 'Replicated part fetches',
        nameShort: 'Part fetches',
        type: 'counter',
        description: 'Rate of replicated part fetches per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_ReplicatedPartFetches{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Part fetches',
          },
        },
      },
      replicatedPartMerges: {
        name: 'Replicated part merges',
        nameShort: 'Part merges',
        type: 'counter',
        description: 'Rate of replicated part merges per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_ReplicatedPartMerges{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Part merges',
          },
        },
      },
      replicatedPartMutations: {
        name: 'Replicated part mutations',
        nameShort: 'Part mutations',
        type: 'counter',
        description: 'Rate of replicated part mutations per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_ReplicatedPartMutations{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Part mutations',
          },
        },
      },
      replicatedPartChecks: {
        name: 'Replicated part checks',
        nameShort: 'Part checks',
        type: 'counter',
        description: 'Rate of replicated part checks per second.',
        unit: '/ sec',
        sources: {
          prometheus: {
            expr: 'ClickHouseProfileEvents_ReplicatedPartChecks{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Part checks',
          },
        },
      },
      readonlyReplica: {
        name: 'Read-only replicas',
        nameShort: 'Read-only',
        type: 'gauge',
        description: 'Shows replicas in read-only state over time.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'ClickHouseMetrics_ReadonlyReplica{%(queriesSelector)s}',
            legendCustomTemplate: '{{ instance }} - Read only',
          },
        },
      },
    },
  }
