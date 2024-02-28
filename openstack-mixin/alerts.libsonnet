{
  new(this): {
    local OpenStackAlerts = [
      {
        alert: 'OpenStackPlacementHighMemoryUsageWarning',
        expr: |||
          100 * openstack_placement_resource_usage{resourcetype="MEMORY_MB"} / clamp_min(openstack_placement_resource_total{resourcetype="MEMORY_MB"}, 1) > %(alertsWarningPlacementHighMemoryUsage)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'The cloud is using a significant percentage of its allocated memory.',
          description:
            (
              'The cloud on instance {{$labels.instance}} is using {{ printf "%%.0f" $value }} percent of its allocated memory, ' +
              'which is above the threshold of %(alertsWarningPlacementHighMemoryUsage)s percent.'
            ) % this.config,
        },
      },
      {
        alert: 'OpenStackPlacementHighMemoryUsageCritical',
        expr: |||
          100 * openstack_placement_resource_usage{resourcetype="MEMORY_MB"} / clamp_min(openstack_placement_resource_total{resourcetype="MEMORY_MB"}, 1)> %(alertsCriticalPlacementHighMemoryUsage)s 
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'critical',
        },
        annotations: {
          summary: 'The cloud is using a large percentage of its allocated memory, consider allocating more resources.',
          description:
            (
              'The cloud on instance {{$labels.instance}} is using {{ printf "%%.0f" $value }} percent of its allocated memory, ' +
              'which is above the threshold of %(alertsCriticalPlacementHighMemoryUsage)s percent.'
            ) % this.config,
        },
      },
      {
        alert: 'OpenStackNovaHighVMMemoryUsage',
        expr: |||
          100 * openstack_nova_limits_memory_used / clamp_min(openstack_nova_limits_memory_max, 1) > %(alertsWarningNovaHighVMMemoryUsage)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'VMs are using a high percentage of their allocated memory.',
          description:
            (
              'Virtual machines on the cloud on {{$labels.instance}} are using {{ printf "%%.0f" $value }} percent of their allocated memory, ' +
              'which is above the threshold of %(alertsWarningNovaHighVMMemoryUsage)s percent.'
            ) % this.config,
        },
      },
      {
        alert: 'OpenStackNovaHighVMVCPUUsage',
        expr: |||
          100 * openstack_nova_limits_vcpus_used / clamp_min(openstack_nova_limits_vcpus_max, 1) > %(alertsWarningNovaHighVMVCPUUsage)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'VMs are using a high percentage of their allocated virtual CPUs.',
          description:
            (
              'Virtual machines on the cloud on {{$labels.instance}} are using {{ printf "%%.0f" $value }} percent of their allocated virtual CPUs, ' +
              'which is above the threshold of %(alertsWarningNovaHighVMVCPUUsage)s percent.'
            ) % this.config,
        },
      },
      {
        alert: 'OpenStackNeutronHighDisconnectedPortRate',
        expr: |||
          100 * openstack_neutron_ports_no_ips / clamp_min(openstack_neutron_ports, 1) > %(alertsCriticalNeutronHighDisconnectedPortRate)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'critical',
        },
        annotations: {
          summary: 'A high rate of ports have no IP addresses assigned to them.',
          description: (
            '{{ printf "%%.0f" $value }} percent of ports managed by the Neutron service on instance {{$labels.instance}} have no IP addresses assigned to them, ' +
            'which is above the threshold of %(alertsCriticalNeutronHighDisconnectedPortRate)s'
          ) % this.config,
        },
      },
      {
        alert: 'OpenStackNeutronHighInactiveRouterRate',
        expr: |||
          100 * openstack_neutron_routers_not_active / clamp_min(openstack_neutron_routers, 1) > %(alertsCriticalNeutronHighInactiveRouterRate)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'critical',
        },
        annotations: {
          summary: 'A high rate of routers are currently inactive.',
          description: (
            '{{ printf "%%.0f" $value }} percent of routers managed by the Neutron service on instance {{$labels.instance}} are currently inactive, ' +
            'which is above the threshold of %(alertsCriticalNeutronHighInactiveRouterRate)s'
          ) % this.config,
        },
      },
      {
        alert: 'OpenStackCinderHighBackupMemoryUsage',
        expr: |||
          100 * openstack_cinder_limits_backup_used_gb / clamp_min(openstack_cinder_limits_backup_max_gb, 1) > %(alertsWarningCinderHighBackupMemoryUsage)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'Cinder backups are using a large amount of their maximum memory.',
          description: (
            'Backups managed by the Cinder service on instance {{$labels.instance}} are using {{ printf "%%.0f" $value }} percent of their allocated memory, ' +
            'which is above the threshold of %(alertsWarningCinderHighBackupMemoryUsage)s percent.'
          ) % this.config,
        },
      },
      {
        alert: 'OpenStackCinderHighVolumeMemoryUsage',
        expr: |||
          100 * openstack_cinder_limits_volume_used_gb / clamp_min(openstack_cinder_limits_volume_max_gb, 1) > %(alertsWarningCinderHighVolumeMemoryUsage)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'Cinder volumes are using a large amount of their maximum memory.',
          description: (
            'Volumes managed by the Cinder service on instance {{$labels.instance}} are using {{ printf "%%.0f" $value }} percent of their allocated memory, ' +
            'which is above the threshold of %(alertsWarningCinderHighVolumeMemoryUsage)s percent.'
          ) % this.config,
        },
      },
      {
        alert: 'OpenStackCinderHighPoolCapacityUsage',
        expr: |||
          100 * (openstack_cinder_pool_capacity_total_gb - openstack_cinder_pool_capacity_free_gb) / clamp_min(openstack_cinder_pool_capacity_total_gb, 1) > %(alertsWarningCinderHighPoolCapacityUsage)s
        ||| % this.config,
        'for': '5m',
        labels: {
          severity: 'warning',
        },
        annotations: {
          summary: 'Cinder pools are using a large amount of their maximum capacity.',
          description: (
            'Pools managed by the Cinder service on instance {{$labels.instance}} are using {{ printf "%%.0f" $value }} percent of their allocated capacity, ' +
            'which is above the threshold of %(alertsWarningCinderHighPoolCapacityUsage)s percent.'
          ) % this.config,
        },
      },
    ],
  },
}
