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
        name: 'PDU processed',
        nameShort: 'PDUs',
        type: 'counter',
        description: 'The rate of LDAP Protocol Data Units (PDUs) processed over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=PDU,cn=Statistics,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      addOperations: {
        name: 'Add operations',
        nameShort: 'Add',
        type: 'counter',
        description: 'The rate of LDAP Add operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Add,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Add',
          },
        },
      },

      bindOperations: {
        name: 'Bind operations',
        nameShort: 'Bind',
        type: 'counter',
        description: 'The rate of LDAP Bind operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Bind,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Bind',
          },
        },
      },

      modifyOperations: {
        name: 'Modify operations',
        nameShort: 'Modify',
        type: 'counter',
        description: 'The rate of LDAP Modify operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Modify,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Modify',
          },
        },
      },

      searchOperations: {
        name: 'Search operations',
        nameShort: 'Search',
        type: 'counter',
        description: 'The rate of LDAP Search operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Search,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Search',
          },
        },
      },

      deleteOperations: {
        name: 'Delete operations',
        nameShort: 'Delete',
        type: 'counter',
        description: 'The rate of LDAP Delete operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Delete,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Delete',
          },
        },
      },

      abandonOperations: {
        name: 'Abandon operations',
        nameShort: 'Abandon',
        type: 'counter',
        description: 'The rate of LDAP Abandon operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Abandon,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Abandon',
          },
        },
      },

      compareOperations: {
        name: 'Compare operations',
        nameShort: 'Compare',
        type: 'counter',
        description: 'The rate of LDAP Compare operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Compare,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Compare',
          },
        },
      },

      unbindOperations: {
        name: 'Unbind operations',
        nameShort: 'Unbind',
        type: 'counter',
        description: 'The rate of LDAP Unbind operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Unbind,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Unbind',
          },
        },
      },

      extendedOperations: {
        name: 'Extended operations',
        nameShort: 'Extended',
        type: 'counter',
        description: 'The rate of LDAP Extended operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Extended,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Extended',
          },
        },
      },

      modrdnOperations: {
        name: 'Modrdn operations',
        nameShort: 'Modrdn',
        type: 'counter',
        description: 'The rate of LDAP Modify RDN operations.',
        unit: 'ops',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_operation{%(queriesSelector)s, dn="cn=Modrdn,cn=Operations,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate + ' - Modrdn',
          },
        },
      },
    },
  }
