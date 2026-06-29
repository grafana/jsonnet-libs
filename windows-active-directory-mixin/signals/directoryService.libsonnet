// Signals for Active Directory directory service, database, and health metrics
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      directoryServiceThreads: {
        name: 'AD directory service threads',
        nameShort: 'Service threads',
        type: 'gauge',
        description: 'Number of active directory service threads in Active Directory.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_directory_service_threads{%(queriesSelector)s}',
            legendCustomTemplate: 'Directory service threads',
          },
        },
      },
      databaseOperations: {
        name: 'AD database operations',
        nameShort: 'DB operations',
        type: 'counter',
        description: 'Rate of Active Directory database operations.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_database_operations_total{%(queriesSelector)s}',
            aggKeepLabels: ['operation'],
            legendCustomTemplate: '{{instance}} - {{operation}}',
          },
        },
      },
      passwordChanges: {
        name: 'AD password changes',
        nameShort: 'Password changes',
        type: 'counter',
        description: 'Rate of password changes in Active Directory.',
        unit: 'short',
        sources: {
          prometheus: {
            expr: 'windows_ad_sam_password_changes_total{%(queriesSelector)s}',
            rangeFunction: 'increase',
          },
        },
      },
      adMetricsDown: {
        name: 'AD metrics down',
        nameShort: 'Metrics down',
        type: 'gauge',
        description: 'Active Directory metrics availability (1=up, 0=down).',
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
                },
              },
            ],
          },
        },
      },
    },
  }
