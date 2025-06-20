local commonlib = import 'common-lib/common/main.libsonnet';
local xtd = import 'github.com/jsonnet-libs/xtd/main.libsonnet';

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
        description: 'Number of pending replication operations in Active Directory',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_pending_operations{%(queriesSelector)s}',
            legendCustomTemplate: 'Pending operations',
          },
        },
      },
      adReplicationSyncRequestFailures: {
        name: 'AD replication sync request failures',
        nameShort: 'Replication failures',
        type: 'counter',
        description: 'Number of replication synchronization request failures',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_sync_requests_schema_mismatch_failure_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
      adPasswordChanges: {
        name: 'AD password changes',
        nameShort: 'Password changes',
        type: 'counter',
        description: 'Number of password changes in Active Directory',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_sam_password_changes_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
      directoryServiceThreads: {
        name: 'AD directory service threads',
        nameShort: 'Service threads',
        type: 'gauge',
        description: 'Number of directory service threads in Active Directory',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_directory_service_threads{%(queriesSelector)s}',
            legendCustomTemplate: 'Directory service threads',
          },
        },
      },
      replicationPendingSynchronizations: {
        name: 'AD pending synchronizations',
        nameShort: 'Pending syncs',
        type: 'gauge',
        description: 'Number of pending synchronizations in Active Directory',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_pending_synchronizations{%(queriesSelector)s}',
            legendCustomTemplate: 'Pending syncs',
          },
        },
      },
      ldapBindRequests: {
        name: 'AD LDAP bind requests',
        nameShort: 'LDAP binds',
        type: 'counter',
        description: 'Rate of LDAP bind requests in Active Directory',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_binds_total{bind_method=~"ldap", %(queriesSelector)s}',
            legendCustomTemplate: '{{ %s }}' % xtd.array.slice(this.instanceLabels, -1),
          },
        },
      },
      ldapOperations: {
        name: 'AD LDAP operations',
        nameShort: 'LDAP operations',
        type: 'counter',
        description: 'Rate of LDAP operations in Active Directory',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_directory_operations_total{origin=~"ldap", %(queriesSelector)s}',
            aggKeepLabels: ['operation'],
            legendCustomTemplate: '{{ %s }} - {{ operation }}' % xtd.array.slice(this.instanceLabels, -1),
          },
        },
      },
      bindOperations: {
        name: 'AD bind operations',
        nameShort: 'Bind operations',
        type: 'counter',
        description: 'Rate of bind operations in Active Directory',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_binds_total{%(queriesSelector)s}',
            aggKeepLabels: ['operation'],
            legendCustomTemplate: '{{ %s }} - {{ operation }}' % xtd.array.slice(this.instanceLabels, -1),
          },
        },
      },
      intrasiteReplicationTraffic: {
        name: 'AD intrasite replication traffic',
        nameShort: 'Intrasite traffic',
        type: 'counter',
        description: 'Rate of intrasite replication traffic in Active Directory',
        unit: 'bps',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_data_intrasite_bytes_total{%(queriesSelector)s} * 8',
            aggKeepLabels: ['direction'],
            legendCustomTemplate: '{{ %s }} - {{ direction }}' % xtd.array.slice(this.instanceLabels, -1),
          },
        },
      },
      intersiteReplicationTraffic: {
        name: 'AD intersite replication traffic',
        nameShort: 'Intersite traffic',
        type: 'counter',
        description: 'Rate of intersite replication traffic in Active Directory',
        unit: 'bps',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_data_intersite_bytes_total{%(queriesSelector)s} * 8',
            aggKeepLabels: ['direction'],
            legendCustomTemplate: '{{ %s }} - {{ direction }}' % xtd.array.slice(this.instanceLabels, -1),
          },
        },
      },
      inboundObjectsReplicationUpdates: {
        name: 'AD inbound object replication updates',
        nameShort: 'Object updates',
        type: 'counter',
        description: 'Rate of inbound object replication updates in Active Directory',
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
        description: 'Rate of inbound property replication updates in Active Directory',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_replication_inbound_properties_updated_total{%(queriesSelector)s}',
          },
        },
      },
      databaseOperations: {
        name: 'AD database operations',
        nameShort: 'DB operations',
        type: 'counter',
        description: 'Rate of database operations in Active Directory',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_database_operations_total{%(queriesSelector)s}',
            legendCustomTemplate: '{{ %s }} - {{ operation }}' % xtd.array.slice(this.instanceLabels, -1),
            aggKeepLabels: ['operation'],
          },
        },
      },
      adMetricsDown: {
        name: 'AD metrics down',
        nameShort: 'Metrics down',
        type: 'gauge',
        description: 'Active Directory metrics availability',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'up{job="' + this.alertsMetricsDownJobName + '"}',
            valueMappings: [
              {
                type: 'value',
                options: {
                  '1': {
                    text: 'Up',
                    color: 'light-green',
                    index: 1,
                  },
                  '0': {
                    text: 'Down',
                    color: 'light-red',
                    index: 0,
                  },
                }
              },
            ],
          },
        },
      },
    },
  } 