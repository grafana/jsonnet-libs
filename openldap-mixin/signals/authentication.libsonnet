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
      prometheus: 'openldap_bind',
    },
    signals: {
      authAttempts: {
        name: 'Authentication attempts / $__interval',
        nameShort: 'Auth attempts',
        type: 'raw',
        description: 'The total increase of authentication attempts over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'increase(openldap_bind{%(queriesSelector)s}[$__interval:])',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      authFailures: {
        name: 'Authentication failures',
        nameShort: 'Auth failures',
        type: 'raw',
        description: 'The rate of LDAP authentication failures (non-ok bind results).',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'increase(openldap_bind{%(queriesSelector)s, result!="ok"}[$__rate_interval])',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },

      dialFailures: {
        name: 'Dial failures',
        nameShort: 'Dial failures',
        type: 'raw',
        description: 'The rate of LDAP dial failures (non-ok dial results).',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'increase(openldap_dial{%(queriesSelector)s, result!="ok"}[$__rate_interval])',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
