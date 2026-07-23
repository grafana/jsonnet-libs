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
      prometheus: 'openldap_monitor_operation',
    },
    signals: {
      pduProcessed: {
        name: 'PDU processed / $__interval',
        nameShort: 'PDUs',
        type: 'raw',
        description: 'The number of LDAP Protocol Data Units (PDUs) processed over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=PDU,cn=Statistics,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      addOperations: {
        name: 'Add operations',
        nameShort: 'Add',
        type: 'raw',
        description: 'The rate of LDAP Add operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Add,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Add',
          },
        },
      },

      bindOperations: {
        name: 'Bind operations',
        nameShort: 'Bind',
        type: 'raw',
        description: 'The rate of LDAP Bind operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Bind,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Bind',
          },
        },
      },

      modifyOperations: {
        name: 'Modify operations',
        nameShort: 'Modify',
        type: 'raw',
        description: 'The rate of LDAP Modify operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Modify,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Modify',
          },
        },
      },

      searchOperations: {
        name: 'Search operations',
        nameShort: 'Search',
        type: 'raw',
        description: 'The rate of LDAP Search operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Search,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Search',
          },
        },
      },

      deleteOperations: {
        name: 'Delete operations',
        nameShort: 'Delete',
        type: 'raw',
        description: 'The rate of LDAP Delete operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Delete,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Delete',
          },
        },
      },

      abandonOperations: {
        name: 'Abandon operations',
        nameShort: 'Abandon',
        type: 'raw',
        description: 'The rate of LDAP Abandon operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Abandon,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Abandon',
          },
        },
      },

      compareOperations: {
        name: 'Compare operations',
        nameShort: 'Compare',
        type: 'raw',
        description: 'The rate of LDAP Compare operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Compare,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Compare',
          },
        },
      },

      unbindOperations: {
        name: 'Unbind operations',
        nameShort: 'Unbind',
        type: 'raw',
        description: 'The rate of LDAP Unbind operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Unbind,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Unbind',
          },
        },
      },

      extendedOperations: {
        name: 'Extended operations',
        nameShort: 'Extended',
        type: 'raw',
        description: 'The rate of LDAP Extended operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Extended,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Extended',
          },
        },
      },

      modrdnOperations: {
        name: 'Modrdn operations',
        nameShort: 'Modrdn',
        type: 'raw',
        description: 'The rate of LDAP Modify RDN operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'increase(openldap_monitor_operation{%(queriesSelector)s, dn="cn=Modrdn,cn=Operations,cn=Monitor"}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate + ' - Modrdn',
          },
        },
      },
    },
  }
