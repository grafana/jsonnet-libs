function(this) {
  filteringSelector: this.filteringSelector,
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
    placement_up: {
      name: 'Placement status',
      description: 'Reports the status of the Placement resource-scheduling service.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_placement_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    placement_resource_total_disk: {
      name: 'Placement disk capacity',
      description: 'Total disk capacity available for placement in GB.',
      type: 'gauge',
      unit: 'decgbytes',
      sources: {
        prometheus: {
          expr: 'openstack_placement_resource_total{%(queriesSelector)s, resourcetype="DISK_GB"}',
          legendCustomTemplate: '{{instance}} - {{hostname}}',
        },
      },
    },
    placement_resource_usage_disk: {
      name: 'Placement disk usage',
      description: 'Current disk usage reported by placement in GB.',
      type: 'gauge',
      unit: 'decgbytes',
      sources: {
        prometheus: {
          expr: 'openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="DISK_GB"}',
          legendCustomTemplate: '{{instance}} - {{hostname}}',
        },
      },
    },
    placement_resource_total_memory: {
      name: 'Placement memory capacity',
      description: 'Total memory capacity available for placement in MB.',
      type: 'gauge',
      unit: 'decmbytes',
      sources: {
        prometheus: {
          expr: 'openstack_placement_resource_total{%(queriesSelector)s, resourcetype="MEMORY_MB"}',
          legendCustomTemplate: '{{instance}} - {{hostname}}',
        },
      },
    },
    placement_resource_usage_memory: {
      name: 'Placement memory usage',
      description: 'Current memory usage reported by placement in MB.',
      type: 'gauge',
      unit: 'decmbytes',
      sources: {
        prometheus: {
          expr: 'openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="MEMORY_MB"}',
          legendCustomTemplate: '{{instance}} - {{hostname}}',
        },
      },
    },
    placement_resource_total_vcpu: {
      name: 'Placement vCPU capacity',
      description: 'Total vCPU capacity available for placement.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_placement_resource_total{%(queriesSelector)s, resourcetype="VCPU"}',
          legendCustomTemplate: '{{instance}} - {{hostname}}',
        },
      },
    },
    placement_resource_usage_vcpu: {
      name: 'Placement vCPU usage',
      description: 'Current vCPU usage reported by placement.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="VCPU"}',
          legendCustomTemplate: '{{instance}} - {{hostname}}',
        },
      },
    },
    placement_vcpu_usage_ratio: {
      name: 'vCPU usage ratio',
      description: 'Percentage of vCPU capacity in use across all placement nodes.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum(openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="VCPU"}) / sum(openstack_placement_resource_total{%(queriesSelector)s, resourcetype="VCPU"})',
          legendCustomTemplate: 'vCPU used %',
        },
      },
    },
    placement_memory_usage_ratio: {
      name: 'Memory usage ratio',
      description: 'Percentage of memory capacity in use across all placement nodes.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum(openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="MEMORY_MB"}) / sum(openstack_placement_resource_total{%(queriesSelector)s, resourcetype="MEMORY_MB"})',
          legendCustomTemplate: 'Memory used %',
        },
      },
    },
    placement_node_memory_usage_percent: {
      name: 'Node memory usage',
      description: 'Percentage of allocated memory in use per node, accounting for allocation ratio.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="MEMORY_MB"} / (openstack_placement_resource_total{%(queriesSelector)s, resourcetype="MEMORY_MB"} * openstack_placement_resource_allocation_ratio{%(queriesSelector)s, resourcetype="MEMORY_MB"} > 0)',
          legendCustomTemplate: '{{hostname}}',
        },
      },
    },
    placement_node_vcpu_usage_percent: {
      name: 'Node vCPU usage',
      description: 'Percentage of allocated vCPU in use per node, accounting for allocation ratio.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * openstack_placement_resource_usage{%(queriesSelector)s, resourcetype="VCPU"} / (openstack_placement_resource_total{%(queriesSelector)s, resourcetype="VCPU"} * openstack_placement_resource_allocation_ratio{%(queriesSelector)s, resourcetype="VCPU"} > 0)',
          legendCustomTemplate: '{{hostname}}',
        },
      },
    },
  },
}
