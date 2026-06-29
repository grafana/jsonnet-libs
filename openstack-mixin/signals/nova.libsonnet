function(this) {
  filteringSelector: this.filteringSelector,
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
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_nova_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    nova_total_vms: {
      name: 'Total VMs',
      description: 'The current number of total virtual machines.',
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
    nova_server_status: {
      name: 'Nova server status',
      description: 'Status of Nova virtual machine instances.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_nova_server_status{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{status}}',
        },
      },
    },
    nova_limits_instances_used: {
      name: 'Instances used',
      description: 'The number of instances in use per project.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_instances_used{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    nova_limits_instances_max: {
      name: 'Instances max',
      description: 'The maximum number of instances allowed per project.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_instances_max{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
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
    nova_limits_vcpus_used: {
      name: 'vCPUs used',
      description: 'The number of vCPUs in use per project.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_vcpus_used{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    nova_limits_vcpus_max: {
      name: 'vCPUs max',
      description: 'The maximum number of vCPUs allowed per project.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_vcpus_max{%(queriesSelector)s}',
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
    nova_limits_memory_used: {
      name: 'Memory used',
      description: 'The amount of memory in use in MB per project.',
      type: 'gauge',
      unit: 'decmbytes',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_memory_used{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    nova_limits_memory_max: {
      name: 'Memory max',
      description: 'The maximum amount of memory allowed in MB per project.',
      type: 'gauge',
      unit: 'decmbytes',
      sources: {
        prometheus: {
          expr: 'openstack_nova_limits_memory_max{%(queriesSelector)s}',
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
    nova_vm_memory_usage_percent: {
      name: 'VM memory usage',
      description: 'Percentage of allocated VM memory in use.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * openstack_nova_limits_memory_used{%(queriesSelector)s} / (openstack_nova_limits_memory_max{%(queriesSelector)s} > 0)',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    nova_vm_vcpu_usage_percent: {
      name: 'VM vCPU usage',
      description: 'Percentage of allocated VM vCPU in use.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * openstack_nova_limits_vcpus_used{%(queriesSelector)s} / (openstack_nova_limits_vcpus_max{%(queriesSelector)s} > 0)',
          legendCustomTemplate: '{{instance}} - {{tenant}}',
        },
      },
    },
    nova_vms_not_running: {
      name: 'VMs not running',
      description: 'Count of VMs in SHUTOFF or ERROR states per hypervisor.',
      type: 'raw',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'count by (job, instance, hypervisor_hostname, availability_zone) (openstack_nova_server_status{%(queriesSelector)s, status=~"SHUTOFF|ERROR", hypervisor_hostname!=""})',
          legendCustomTemplate: '{{instance}} - {{hypervisor_hostname}}',
        },
      },
    },
  },
}
