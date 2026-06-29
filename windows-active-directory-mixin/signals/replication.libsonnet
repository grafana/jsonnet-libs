// Signals for Active Directory replication metrics
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'windows_ad_replication_pending_operations',
    },
    signals: {
      replicationPendingOperations: {
        name: 'AD pending replication operations',
        nameShort: 'Pending replication',
        type: 'gauge',
        description: 'Number of pending replication operations in Active Directory.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_pending_operations{%(queriesSelector)s}',
            legendCustomTemplate: 'Pending operations',
          },
        },
      },
      replicationPendingSynchronizations: {
        name: 'AD pending synchronizations',
        nameShort: 'Pending syncs',
        type: 'gauge',
        description: 'Number of pending replication synchronizations in Active Directory.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_pending_synchronizations{%(queriesSelector)s}',
            legendCustomTemplate: 'Pending syncs',
          },
        },
      },
      intrasiteReplicationTraffic: {
        name: 'AD intrasite replication traffic',
        nameShort: 'Intrasite traffic',
        type: 'raw',
        description: 'Rate of intrasite replication traffic in bits per second.',
        unit: 'bps',
        sources: {
          prometheus: {
            expr: 'rate(windows_ad_replication_data_intrasite_bytes_total{%(queriesSelector)s}[$__rate_interval]) * 8',
            aggKeepLabels: ['direction'],
            legendCustomTemplate: '{{instance}} - {{direction}}',
          },
        },
      },
      intersiteReplicationTraffic: {
        name: 'AD intersite replication traffic',
        nameShort: 'Intersite traffic',
        type: 'raw',
        description: 'Rate of intersite replication traffic in bits per second.',
        unit: 'bps',
        sources: {
          prometheus: {
            expr: 'rate(windows_ad_replication_data_intersite_bytes_total{%(queriesSelector)s}[$__rate_interval]) * 8',
            aggKeepLabels: ['direction'],
            legendCustomTemplate: '{{instance}} - {{direction}}',
          },
        },
      },
      inboundObjectsReplicationUpdates: {
        name: 'AD inbound object replication updates',
        nameShort: 'Object updates',
        type: 'counter',
        description: 'Rate of inbound object replication updates in Active Directory.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_inbound_objects_updated_total{%(queriesSelector)s}',
          },
        },
      },
      inboundPropertiesReplicationUpdates: {
        name: 'AD inbound property replication updates',
        nameShort: 'Property updates',
        type: 'counter',
        description: 'Rate of inbound property replication updates in Active Directory.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_inbound_properties_updated_total{%(queriesSelector)s}',
          },
        },
      },
      replicationSyncRequestFailures: {
        name: 'AD replication sync request failures',
        nameShort: 'Replication failures',
        type: 'counter',
        description: 'Rate of replication sync request failures due to schema mismatch.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_sync_requests_schema_mismatch_failure_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
    },
  }
