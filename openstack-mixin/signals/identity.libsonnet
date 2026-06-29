function(this) {
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'openstack_identity_up',
  },
  signals: {
    identity_up: {
      name: 'Keystone status',
      description: 'Reports the status of the Keystone identity service.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_identity_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    identity_domains: {
      name: 'Domains',
      description: 'The number of domains for the OpenStack cloud.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_identity_domains{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    identity_projects: {
      name: 'Projects',
      description: 'The number of projects for the OpenStack cloud.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_identity_projects{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    identity_regions: {
      name: 'Regions',
      description: 'The number of regions for the OpenStack cloud.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_identity_regions{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    identity_users: {
      name: 'Users',
      description: 'The number of users for the OpenStack cloud.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_identity_users{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
  },
}
