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
        type: 'counter',
        description: 'The total increase of authentication attempts over time.',
        unit: 'none',
        sources: {
          prometheus: {
            expr: 'openldap_bind{%(queriesSelector)s}',
            rangeFunction: 'increase',
            legendCustomTemplate: legendCustomTemplate,
          },
        },
      },
    },
  }
