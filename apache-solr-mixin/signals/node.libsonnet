function(this)
  {
    datasource: 'prometheus_datasource',
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'solr_metrics_node_connections',
    },
    signals: {
      connections: {
        name: 'Connections',
        nameShort: 'Connections',
        type: 'gauge',
        description: 'Number of connections to the Solr node.',
        unit: 'none',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_node_connections{%(queriesSelector)s}',
            aggKeepLabels: ['solr_cluster', 'base_url', 'item'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      threadPoolSubmitted: {
        name: 'Threads submitted',
        nameShort: 'Submitted',
        type: 'counter',
        description: 'Total number of tasks submitted in the updateOnlyExecutor thread pool.',
        unit: 'none',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_node_thread_pool_submitted_total{%(queriesSelector)s, executor="updateOnlyExecutor"}',
            rangeFunction: 'increase',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - submitted',
          },
        },
      },
      threadPoolCompleted: {
        name: 'Threads completed',
        nameShort: 'Completed',
        type: 'counter',
        description: 'Total number of tasks completed in the updateOnlyExecutor thread pool.',
        unit: 'none',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_node_thread_pool_completed_total{%(queriesSelector)s, executor="updateOnlyExecutor"}',
            rangeFunction: 'increase',
            aggKeepLabels: ['solr_cluster', 'base_url'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - completed',
          },
        },
      },
      coreRootFsBytes: {
        name: 'Node core FS usage',
        nameShort: 'Core FS',
        type: 'gauge',
        description: "Disk space used by Solr node's root file system.",
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_node_core_root_fs_bytes{%(queriesSelector)s}',
            aggKeepLabels: ['solr_cluster', 'base_url', 'item'],
            exprWrappers: [['', ' > 0']],
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      nodeErrors: {
        name: 'Top nodes by node errors / $__interval',
        nameShort: 'Node errors',
        type: 'counter',
        description: 'Top nodes by Solr node errors.',
        unit: 'none',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_node_errors_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
            aggKeepLabels: ['base_url', 'solr_cluster', 'collection'],
            legendCustomTemplate: '{{base_url}}',
          },
        },
      },
      coreErrors: {
        name: 'Top cores by core errors / $__interval',
        nameShort: 'Core errors',
        type: 'counter',
        description: 'Top cores by Solr core errors.',
        unit: 'none',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_core_errors_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
            // 'baseurl' (no underscore) is preserved from the legacy expression; it
            // does not match the 'base_url' label these metrics actually carry.
            aggKeepLabels: ['solr_cluster', 'collection', 'core', 'baseurl'],
            legendCustomTemplate: '{{collection}} - {{core}}',
          },
        },
      },
      coreErrorsAlert: {
        name: 'Core error spike',
        nameShort: 'Core errors %',
        type: 'raw',
        description: 'Spike in core errors relative to total (used for alerting).',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum without(base_url, category, collection, handler, replica, shard) (increase(solr_metrics_core_errors_total{%(queriesSelector)s}[10m]) / clamp_min(avg_over_time(solr_metrics_core_errors_total{%(queriesSelector)s}[10m]), 1))',
            legendCustomTemplate: '{{core}}',
          },
        },
      },
      documentIndexingSpike: {
        name: 'Document indexing spike',
        nameShort: 'Indexing spike %',
        type: 'raw',
        description: 'Spike in document indexing relative to total (used for alerting).',
        unit: 'percent',
        sources: {
          prometheus: {
            expr: '100 * sum without(base_url, category, collection, handler, replica, shard) (increase(solr_metrics_core_update_handler_adds_total{%(queriesSelector)s}[15m]) / clamp_min(avg_over_time(solr_metrics_core_update_handler_adds_total{%(queriesSelector)s}[15m]), 1))',
            legendCustomTemplate: '{{core}}',
          },
        },
      },
      indexSize: {
        name: 'Top cores by index size',
        nameShort: 'Index size',
        type: 'gauge',
        description: 'Top cores by the Solr index size.',
        unit: 'bytes',
        aggLevel: 'group',
        aggFunction: 'avg',
        sources: {
          prometheus: {
            expr: 'solr_metrics_core_index_size_bytes{%(queriesSelector)s}',
            aggKeepLabels: ['base_url', 'solr_cluster', 'collection', 'core'],
            legendCustomTemplate: '{{collection}} - {{core}}',
          },
        },
      },
    },
  }
