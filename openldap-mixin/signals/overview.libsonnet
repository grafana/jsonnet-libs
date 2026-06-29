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
      uptime: {
        name: 'Uptime',
        nameShort: 'Uptime',
        type: 'gauge',
        description: 'The total time since the LDAP server was last started.',
        unit: 's',
        sources: {
          prometheus: {
            expr: 'openldap_monitored_object{%(queriesSelector)s, dn="cn=Uptime,cn=Time,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      referrals: {
        name: 'Referrals',
        nameShort: 'Referrals',
        type: 'gauge',
        description: 'The current number of LDAP referrals.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=Referrals,cn=Statistics,cn=Monitor"}',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      directoryEntries: {
        name: 'Directory entries',
        nameShort: 'Entries',
        type: 'counter',
        description: 'The rate of new directory entries added over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_monitor_counter_object{%(queriesSelector)s, dn="cn=Entries,cn=Statistics,cn=Monitor"}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
