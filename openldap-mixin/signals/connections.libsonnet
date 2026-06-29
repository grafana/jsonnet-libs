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
      prometheus: 'openldap_monitor_counter_object',
    },
    signals: {
      connections: {
        name: 'Connections',
        nameShort: 'Connections',
        type: 'counter',
        description: 'The rate of new LDAP connections over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=Current,cn=Connections,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      readWaiters: {
        name: 'Read waiters',
        nameShort: 'Read waiters',
        type: 'gauge',
        description: 'The current number of read waiters in the LDAP server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=Read,cn=Waiters,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Read',
          },
        },
      },

      writeWaiters: {
        name: 'Write waiters',
        nameShort: 'Write waiters',
        type: 'gauge',
        description: 'The current number of write waiters in the LDAP server.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=Write,cn=Waiters,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate + ' - Write',
          },
        },
      },

      networkConnectivity: {
        name: 'Network connectivity',
        nameShort: 'Dial attempts',
        type: 'counter',
        description: 'The rate of LDAP network connection attempts over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_dial{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
