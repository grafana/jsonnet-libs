function(this) {
  // Left empty so panel queries are driven by the $job/$instance variables alone.
  // The static filteringSelector still constrains the dashboard variable queries.
  filteringSelector: '',
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'openstack_placement_up',
  },
  signals: {
    identity_up: {
      name: 'Keystone status',
      description: 'Reports the status of the Keystone identity service.',
      type: 'gauge',
      unit: 'string',
      sources: {
        prometheus: {
          expr: 'openstack_placement_up{%(queriesSelector)s}',
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
    identity_project_info: {
      name: 'Project details',
      description: 'Details for the projects in the OpenStack cloud.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_identity_project_info{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{name}}',
        },
      },
    },
    identity_users: {
      name: 'Users',
      description: 'The number of users for the OpenStack cloud.',
      type: 'gauge',
      unit: '',
      sources: {
        prometheus: {
          expr: 'openstack_identity_users{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
  },
}
