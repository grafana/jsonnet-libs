// Node role signals for OpenSearch
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    alertsInterval: '5m',
    discoveryMetric: {
      prometheus: 'opensearch_node_role_bool',
    },
    signals: {
      node_role_data: {
        name: 'Node role: data',
        description: 'Data role present flag.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max by (node, role) (max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="data"}[1m]) == 1) * 2',
            legendCustomTemplate: '{{ node }} / data',
          },
        },
      },
      node_role_master: {
        name: 'Node role: master',
        description: 'Master role present flag.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max by (node, role) (max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="master"}[1m]) == 1) * 3',
            legendCustomTemplate: '{{ node }} / master',
          },
        },
      },
      node_role_ingest: {
        name: 'Node role: ingest',
        description: 'Ingest role present flag.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max by (node, role) (max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="ingest"}[1m]) == 1) * 4',
            legendCustomTemplate: '{{ node }} / ingest',
          },
        },
      },
      node_role_cluster_manager: {
        name: 'Node role: cluster_manager',
        description: 'Cluster manager role present flag.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max by (node, role) (max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="cluster_manager"}[1m]) == 1) * 5',
            legendCustomTemplate: '{{ node }} / cluster_manager',
          },
        },
      },
      node_role_remote_cluster_client: {
        name: 'Node role: remote_cluster_client',
        description: 'Remote cluster client role present flag.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max by (node, role) (max_over_time(opensearch_node_role_bool{%(queriesSelector)s, role="remote_cluster_client"}[1m]) == 1) * 6',
            legendCustomTemplate: '{{ node }} / remote_client',
          },
        },
      },
      node_role_last_seen: {
        name: 'Node role bool last seen',
        description: 'Last seen role bool within 1d.',
        type: 'raw',
        sources: {
          prometheus: {
            expr: 'max by (' + this.groupAggList + ', nodeid, role, primary_ip) (last_over_time(opensearch_node_role_bool{%(queriesSelector)s}[1d]))',
          },
        },
      },
    },
  }
