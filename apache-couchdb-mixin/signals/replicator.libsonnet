function(this) {
  local legendCustomTemplate = '{{ couchdb_cluster}}',
  local groupLabelAggTerm = std.join(', ', this.groupLabels),
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  legendCustomTemplate: legendCustomTemplate,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  discoveryMetric: {
    prometheus: 'couchdb_couch_replicator_cluster_is_stable',
  },
  signals: {
    changesManagerDeaths: {
      name: 'Changes manager deaths',
      nameShort: 'Changes manager deaths',
      type: 'raw',
      description: 'The total number of changes manager deaths aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_changes_manager_deaths_total{%(queriesSelector)s})',
        },
      },
    },

    changesQueueDeaths: {
      name: 'Changes queue deaths',
      nameShort: 'Changes queue deaths',
      type: 'raw',
      description: 'The total number of changes queue deaths aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_changes_queue_deaths_total{%(queriesSelector)s})',
        },
      },
    },

    changesReaderDeaths: {
      name: 'Changes reader deaths',
      nameShort: 'Changes reader deaths',
      type: 'raw',
      description: 'The total number of changes reader deaths aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_changes_reader_deaths_total{%(queriesSelector)s})',
        },
      },
    },

    connectionOwnerCrashes: {
      name: 'Connection owner crashes',
      nameShort: 'Connection owner crashes',
      type: 'raw',
      description: 'The total number of connection owner crashes aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_connection_owner_crashes_total{%(queriesSelector)s})',
        },
      },
    },

    connectionWorkerCrashes: {
      name: 'Connection worker crashes',
      nameShort: 'Connection worker crashes',
      type: 'raw',
      description: 'The total number of connection worker crashes aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_connection_worker_crashes_total{%(queriesSelector)s})',
        },
      },
    },

    jobsCrashes: {
      name: 'Jobs crashes',
      nameShort: 'Jobs crashes',
      type: 'raw',
      description: 'The total number of jobs crashes aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_jobs_crashes_total{%(queriesSelector)s})',
        },
      },
    },

    jobsQueued: {
      name: 'Jobs queued',
      nameShort: 'Jobs queued',
      type: 'raw',
      description: 'The total number of jobs queued aggregated across all nodes.',
      unit: 'none',
      sources: {
        prometheus: {
          expr: 'sum by(' + groupLabelAggTerm + ') (couchdb_couch_replicator_jobs_pending{%(queriesSelector)s})',
        },
      },
    },
  },
}
