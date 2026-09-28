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
    prometheus: 'openstack_nova_up',
  },
  signals: {
    nova_up: {
      name: 'Nova status',
      description: 'Reports the status of the Nova compute service.',
      type: 'gauge',
      unit: 'string',
      sources: {
        prometheus: {
          expr: 'openstack_nova_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    nova_total_vms: {
      name: 'VMs',
      description: 'The current number of total and running virtual machines.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_nova_total_vms{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    nova_agent_state: {
      name: 'Nova agent state',
      description: 'The state of Nova compute agents.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_nova_agent_state{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{service}} - {{hostname}}',
        },
      },
    },
    nova_instance_usage: {
      name: 'Instance usage',
      description: 'Percentage of the maximum number of instances in use for each project.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_instances_used{%(queriesSelector)s} / clamp_min(openstack_nova_limits_instances_max{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    nova_vcpu_usage: {
      name: 'vCPU usage',
      description: 'Percentage of the maximum number of virtual CPUs in use for each project.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_vcpus_used{%(queriesSelector)s} / clamp_min(openstack_nova_limits_vcpus_max{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    nova_memory_usage: {
      name: 'Memory usage',
      description: 'Percentage of the maximum amount of memory in use for each project.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_memory_used{%(queriesSelector)s} / clamp_min(openstack_nova_limits_memory_max{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
  },
}
