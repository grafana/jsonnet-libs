// Signals for Active Directory LDAP and bind operations
function(this)
  {
    filteringSelector: this.filteringSelector,
    groupLabels: this.groupLabels,
    instanceLabels: this.instanceLabels,
    enableLokiLogs: this.enableLokiLogs,
    aggLevel: 'none',
    aggFunction: 'avg',
    signals: {
      ldapBindRequests: {
        name: 'AD LDAP bind requests',
        nameShort: 'LDAP binds',
        type: 'counter',
        description: 'Rate of LDAP bind requests in Active Directory.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_binds_total{%(queriesSelector)s, bind_method=~"ldap"}',
            legendCustomTemplate: '{{instance}} - LDAP',
          },
        },
      },
      ldapOperations: {
        name: 'AD LDAP operations',
        nameShort: 'LDAP operations',
        type: 'counter',
        description: 'Rate of LDAP directory operations in Active Directory.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_directory_operations_total{%(queriesSelector)s, origin=~"ldap"}',
            aggKeepLabels: ['operation'],
            legendCustomTemplate: '{{instance}} - {{operation}}',
          },
        },
      },
      bindOperations: {
        name: 'AD bind operations',
        nameShort: 'Bind operations',
        type: 'counter',
        description: 'Rate of bind operations by method in Active Directory.',
        unit: 'reqps',
        sources: {
          prometheus: {
            expr: 'windows_ad_binds_total{%(queriesSelector)s}',
            aggKeepLabels: ['bind_method'],
            legendCustomTemplate: '{{instance}} - {{bind_method}}',
          },
        },
      },
    },
  }
