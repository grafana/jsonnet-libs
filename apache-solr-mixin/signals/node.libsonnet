function(this)
  {
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
        type: 'raw',
        description: 'Number of connections to the Solr node.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url, item) (solr_metrics_node_connections{%(queriesSelector)s}) > 0',
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      threadPoolSubmitted: {
        name: 'Threads submitted',
        nameShort: 'Submitted',
        type: 'raw',
        description: 'Total number of tasks submitted in the updateOnlyExecutor thread pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (increase(solr_metrics_node_thread_pool_submitted_total{%(queriesSelector)s, executor="updateOnlyExecutor"}[$__interval:])) > 0',
            legendCustomTemplate: '{{base_url}} - submitted',
          },
        },
      },
      threadPoolCompleted: {
        name: 'Threads completed',
        nameShort: 'Completed',
        type: 'raw',
        description: 'Total number of tasks completed in the updateOnlyExecutor thread pool.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url) (increase(solr_metrics_node_thread_pool_completed_total{%(queriesSelector)s, executor="updateOnlyExecutor"}[$__interval:])) > 0',
            legendCustomTemplate: '{{base_url}} - completed',
          },
        },
      },
      coreRootFsBytes: {
        name: 'Node core FS usage',
        nameShort: 'Core FS',
        type: 'raw',
        description: "Disk space used by Solr node's root file system.",
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, base_url, item) (solr_metrics_node_core_root_fs_bytes{%(queriesSelector)s}) > 0',
            legendCustomTemplate: '{{base_url}} - {{item}}',
          },
        },
      },
      nodeErrors: {
        name: 'Node errors',
        nameShort: 'Node errors',
        type: 'raw',
        description: 'Solr node errors.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by (job, base_url, solr_cluster, collection) (increase(solr_metrics_node_errors_total{%(queriesSelector)s}[$__interval:]))',
            legendCustomTemplate: '{{base_url}}',
          },
        },
      },
      coreErrors: {
        name: 'Core errors',
        nameShort: 'Core errors',
        type: 'raw',
        description: 'Solr core errors.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'avg by (job, solr_cluster, collection, core, baseurl) (increase(solr_metrics_core_errors_total{%(queriesSelector)s}[$__interval:]))',
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
        name: 'Index size',
        nameShort: 'Index size',
        type: 'raw',
        description: 'Solr core index size.',
        unit: 'bytes',
        sources: {
          prometheus: {
            expr: 'avg by (job, base_url, solr_cluster, collection, core) (solr_metrics_core_index_size_bytes{%(queriesSelector)s})',
            legendCustomTemplate: '{{collection}} - {{core}}',
          },
        },
      },
    },
  }
