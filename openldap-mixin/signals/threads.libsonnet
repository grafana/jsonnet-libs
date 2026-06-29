function(this)
  local legendCustomTemplate = std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels));
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    discoveryMetric: {
      prometheus: 'openldap_monitored_object',
    },
    signals: {
      openThreads: {
        name: 'Open threads',
        nameShort: 'Open',
        type: 'gauge',
        description: 'The number of open threads in the LDAP server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Open,cn=Threads,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Open',
          },
        },
      },

      activeThreads: {
        name: 'Active threads',
        nameShort: 'Active',
        type: 'gauge',
        description: 'The number of active threads in the LDAP server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Active,cn=Threads,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Active',
          },
        },
      },

      maxThreads: {
        name: 'Max threads',
        nameShort: 'Max',
        type: 'gauge',
        description: 'The maximum number of threads configured for the LDAP server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Max,cn=Threads,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Max',
          },
        },
      },

      startingThreads: {
        name: 'Starting threads',
        nameShort: 'Starting',
        type: 'gauge',
        description: 'The number of threads currently starting in the LDAP server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Starting,cn=Threads,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Starting',
          },
        },
      },

      pendingThreads: {
        name: 'Pending threads',
        nameShort: 'Pending',
        type: 'gauge',
        description: 'The number of pending threads in the LDAP server queue.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Pending,cn=Threads,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Pending',
          },
        },
      },

      maxPendingThreads: {
        name: 'Max pending threads',
        nameShort: 'Max Pending',
        type: 'gauge',
        description: 'The maximum number of pending threads allowed in the LDAP server queue.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Max Pending,cn=Threads,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Max Pending',
          },
        },
      },

      backloadThreads: {
        name: 'Backload threads',
        nameShort: 'Backload',
        type: 'gauge',
        description: 'The number of pending threads that have been backloaded.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Backload,cn=Threads,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Backload',
          },
        },
      },
    },
  }
