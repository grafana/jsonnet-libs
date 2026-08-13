function(this)
  local legendCustomTemplate = std.join(' ', std.map(function(label) '{{' + label + '}}', this.instanceLabels));
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    rangeFunction: 'increase',
    discoveryMetric: {
      prometheus: 'openldap_monitor_operation',
    },
    signals: {
      pduProcessed: {
        name: 'PDU processed / $__interval',
        nameShort: 'PDUs',
        type: 'counter',
        description: 'The number of LDAP Protocol Data Units (PDUs) processed over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=PDU,cn=Statistics,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      addOperations: {
        name: 'Add operations',
        nameShort: 'Add',
        type: 'counter',
        description: 'The number of LDAP Add operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Add,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Add',
          },
        },
      },

      bindOperations: {
        name: 'Bind operations',
        nameShort: 'Bind',
        type: 'counter',
        description: 'The number of LDAP Bind operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Bind,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Bind',
          },
        },
      },

      modifyOperations: {
        name: 'Modify operations',
        nameShort: 'Modify',
        type: 'counter',
        description: 'The number of LDAP Modify operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Modify,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Modify',
          },
        },
      },

      searchOperations: {
        name: 'Search operations',
        nameShort: 'Search',
        type: 'counter',
        description: 'The number of LDAP Search operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Search,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Search',
          },
        },
      },

      deleteOperations: {
        name: 'Delete operations',
        nameShort: 'Delete',
        type: 'counter',
        description: 'The number of LDAP Delete operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Delete,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Delete',
          },
        },
      },

      abandonOperations: {
        name: 'Abandon operations',
        nameShort: 'Abandon',
        type: 'counter',
        description: 'The number of LDAP Abandon operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Abandon,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Abandon',
          },
        },
      },

      compareOperations: {
        name: 'Compare operations',
        nameShort: 'Compare',
        type: 'counter',
        description: 'The number of LDAP Compare operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Compare,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Compare',
          },
        },
      },

      unbindOperations: {
        name: 'Unbind operations',
        nameShort: 'Unbind',
        type: 'counter',
        description: 'The number of LDAP Unbind operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Unbind,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Unbind',
          },
        },
      },

      extendedOperations: {
        name: 'Extended operations',
        nameShort: 'Extended',
        type: 'counter',
        description: 'The number of LDAP Extended operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Extended,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Extended',
          },
        },
      },

      modrdnOperations: {
        name: 'Modrdn operations',
        nameShort: 'Modrdn',
        type: 'counter',
        description: 'The number of LDAP Modify RDN operations over the selected interval.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Modrdn,cn=Operations,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Modrdn',
          },
        },
      },
    },
  }
