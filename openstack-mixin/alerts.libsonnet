{
  new(this): {
    groups: [
      {
        name: 'openstack-alerts-' + this.config.uid,
        rules: [
          {
            alert: 'OpenStackGlanceIsDown',
            expr: |||
              openstack_glance_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Glance is down.',
              description: 'OpenStack Glance service is down on cluster {{ $labels.%(instanceFirstLabel)s }}.' % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackHeatIsDown',
            expr: |||
              openstack_heat_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Heat is down.',
              description: 'OpenStack Heat service is down on cluster {{ $labels.%(instanceFirstLabel)s }}.' % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackIdentityIsDown',
            expr: |||
              openstack_identity_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Identity is down.',
              description: 'OpenStack Identity service is down on cluster {{ $labels.%(instanceFirstLabel)s }}.' % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackPlacementIsDown',
            expr: |||
              openstack_placement_up{%(filteringSelector)s} == 0
              openstack_placement_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Placement is down.',
              description: 'OpenStack Placement service is down on cluster {{ $labels.%(instanceFirstLabel)s }}.'
                           % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackPlacementHighMemoryUsageWarning',
            expr: |||
              100 * sum by (%(agg)s) (openstack_placement_resource_usage{%(filteringSelector)s, resourcetype="MEMORY_MB"})
              /
              (sum by (%(agg)s) (openstack_placement_resource_total{%(filteringSelector)s, resourcetype="MEMORY_MB"}) > 0)
              > %(alertsWarningPlacementHighMemoryUsage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            keep_firing_for: '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'OpenStack is using a significant percentage of its allocated memory.',
              description: |||
                OpenStack {{$labels.%(instanceFirstLabel)s}} is using {{ printf "%%.0f" $value }} percent of its allocated memory,
                which is above the threshold of %(alertsWarningPlacementHighMemoryUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNovaAgentDown',
            expr: |||
              100 * sum by (%(agg)s) (openstack_placement_resource_usage{%(filteringSelector)s, resourcetype="MEMORY_MB"})
              /
              (sum by (%(agg)s) (openstack_placement_resource_total{%(filteringSelector)s, resourcetype="MEMORY_MB"}) > 0)
              > %(alertsCriticalPlacementHighMemoryUsage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            keep_firing_for: '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack is using a large percentage of its allocated memory, consider allocating more resources.',
              description: |||
                OpenStack {{$labels.%(instanceFirstLabel)s}} is using {{ printf "%%.0f" $value }} percent of its allocated memory,
                which is above the threshold of %(alertsCriticalPlacementHighMemoryUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackPlacementHighVCPUUsageWarning',
            expr: |||
              100 * sum by (%(agg)s) (openstack_placement_resource_usage{%(filteringSelector)s, resourcetype="VCPU"})
              /
              (sum by (%(agg)s) (openstack_placement_resource_total{%(filteringSelector)s, resourcetype="VCPU"}) > 0)
              > %(alertsWarningPlacementHighVCPUUsage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            keep_firing_for: '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'OpenStack is using a significant percentage of its allocated vCPU.',
              description: |||
                OpenStack {{$labels.%(instanceFirstLabel)s}} is using {{ printf "%%.0f" $value }} percent of its allocated vCPU,
                which is above the threshold of %(alertsWarningPlacementHighVCPUUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackPlacementHighVCPUUsageCritical',

            expr: |||
              100 * sum by (%(agg)s) (openstack_placement_resource_usage{%(filteringSelector)s, resourcetype="VCPU"})
              /
              (sum by (%(agg)s) (openstack_placement_resource_total{%(filteringSelector)s, resourcetype="VCPU"}) > 0)
              > %(alertsCriticalPlacementHighVCPUUsage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            keep_firing_for: '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack is using a large percentage of its allocated vCPU, consider allocating more resources.',
              description: |||
                OpenStack {{$labels.%(instanceFirstLabel)s}} is using {{ printf "%%.0f" $value }} percent of its allocated vCPU,
                which is above the threshold of %(alertsCriticalPlacementHighVCPUUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNeutronHighIPsUsageWarning',
            expr: |||
              100 * 
              sum by (%(agg)s, network_name) (openstack_neutron_network_ip_availabilities_used{%(filteringSelector)s, network_name=~"%(alertsIPutilizationNetworksMatcher)s"}) 
              /
              (sum by (%(agg)s, network_name) (openstack_neutron_network_ip_availabilities_total{%(filteringSelector)s, network_name=~"%(alertsIPutilizationNetworksMatcher)s"})
              > 0)
              > %(alertsWarningNeutronHighIPsUsage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            keep_firing_for: '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Free IP addresses are running out.',
              description: |||
                Network {{$labels.network_name}} is running out of free IP addresses on OpenStack {{$labels.%(instanceFirstLabel)s}},
                {{ printf "%%.0f" $value }} percent of the pool used,
                {{ with printf `sum(openstack_neutron_network_ip_availabilities_total{%(filteringSelector)s, %(instanceFirstLabel)s=~"%%s", network_name=~"%%s"}) - (sum(openstack_neutron_network_ip_availabilities_used{%(filteringSelector)s, %(instanceFirstLabel)s=~"%%s", network_name=~"%%s"}))` .Labels.%(instanceFirstLabel)s .Labels.network_name .Labels.%(instanceFirstLabel)s .Labels.network_name | query -}}{{ . | first | value | humanize }}{{ end }} IP addresses available.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNeutronHighIPsUsageCritical',
            expr: |||
              100 * 
              sum by (%(agg)s, network_name) (openstack_neutron_network_ip_availabilities_used{%(filteringSelector)s, network_name=~"%(alertsIPutilizationNetworksMatcher)s"}) 
              /
              (sum by (%(agg)s, network_name) (openstack_neutron_network_ip_availabilities_total{%(filteringSelector)s, network_name=~"%(alertsIPutilizationNetworksMatcher)s"})
              > 0)
              > %(alertsCriticalNeutronHighIPsUsage)s
            ||| % this.config { agg: std.join(',', this.config.groupLabels + this.config.instanceLabels) },
            'for': '5m',
            keep_firing_for: '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'There are practically no free IP addresses left.',
              description: |||
                Network {{$labels.network_name}} is running out of free IP addresses on OpenStack {{$labels.%(instanceFirstLabel)s}},
                {{ printf "%%.0f" $value }} percent of the pool used,
                {{ with printf `sum(openstack_neutron_network_ip_availabilities_total{%(filteringSelector)s, %(instanceFirstLabel)s=~"%%s", network_name=~"%%s"}) - (sum(openstack_neutron_network_ip_availabilities_used{%(filteringSelector)s, %(instanceFirstLabel)s=~"%%s", network_name=~"%%s"}))` .Labels.%(instanceFirstLabel)s .Labels.network_name .Labels.%(instanceFirstLabel)s .Labels.network_name | query -}}{{ . | first | value | humanize }}{{ end }} IP addresses available.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
        ],
      },
      {
        name: 'openstack-nova-alerts' + this.config.uid,
        rules: [
          {
            alert: 'OpenStackNovaIsDown',
            expr: |||
              openstack_nova_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Nova service is down.',
              description: (
                'OpenStack Nova is down on {{ $labels.%(instanceFirstLabel)s }}.'
              ) % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNovaAgentIsDown',
            expr: |||
              openstack_nova_agent_state{%(filteringSelector)s,adminState="enabled"} != 1
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Nova agent is down on the specific node.',
              summary: 'OpenStack Nova agent is down on the specific node.',
              description:
                'An OpenStack Nova agent is down on hostname {{ $labels.hostname }} on OpenStack cluster {{ $labels.%(instanceFirstLabel)s }}.'
                % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNovaHighVMMemoryUsage',
            expr: |||
              100 * openstack_nova_limits_memory_used{%(filteringSelector)s} / (openstack_nova_limits_memory_max{%(filteringSelector)s} > 0) > %(alertsWarningNovaHighVMMemoryUsage)s
              100 * openstack_nova_limits_memory_used{%(filteringSelector)s} / (openstack_nova_limits_memory_max{%(filteringSelector)s} > 0) > %(alertsWarningNovaHighVMMemoryUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'VMs are using a high percentage of their allocated memory.',
              description: |||
                Virtual machines on OpenStack {{ $labels.%(instanceFirstLabel)s }} are using {{ printf "%%.0f" $value }} percent of their allocated memory,
                which is above the threshold of %(alertsWarningNovaHighVMMemoryUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
              description: |||
                Virtual machines on OpenStack {{ $labels.%(instanceFirstLabel)s }} are using {{ printf "%%.0f" $value }} percent of their allocated memory,
                which is above the threshold of %(alertsWarningNovaHighVMMemoryUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNovaHighVMVCPUUsage',
            expr: |||
              100 * openstack_nova_limits_vcpus_used{%(filteringSelector)s} / (openstack_nova_limits_vcpus_max{%(filteringSelector)s} > 0) > %(alertsWarningNovaHighVMVCPUUsage)s
              100 * openstack_nova_limits_vcpus_used{%(filteringSelector)s} / (openstack_nova_limits_vcpus_max{%(filteringSelector)s} > 0) > %(alertsWarningNovaHighVMVCPUUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'VMs are using a high percentage of their allocated virtual CPUs.',
              description: |||
                Virtual machines on OpenStack {{$labels.%(instanceFirstLabel)s}} are using {{ printf "%%.0f" $value }} percent of their allocated virtual CPUs,
                which is above the threshold of %(alertsWarningNovaHighVMVCPUUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
        ],
      },
      {
        name: 'openstack-neutron-alerts' + this.config.uid,
        rules: [
          {
            alert: 'OpenStackNeutronIsDown',
            expr: |||
              openstack_neutron_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Neutron is down.',
              description:
                'OpenStack Neutron service is down on cluster {{ $labels.%(instanceFirstLabel)s }}.'
                % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNeutronAgentIsDown',
            expr: |||
              openstack_neutron_agent_state{%(filteringSelector)s,adminState="up"} != 1
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Neutron agent is down on the specific node.',
              description: |||
                OpenStack Neutron agent`s service {{ $labels.service }} is down on hostname {{ $labels.hostname }} on OpenStack cluster {{ $labels.%(instanceFirstLabel)s }}.
                If {{ $labels.service }} is no longer required on this host, disable it administratively by running:
                OpenStack network agent set {{ $labels.id }} --disable
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
              runbook_url: 'https://docs.openstack.org/neutron/zed/admin/config-services-agent.html#agent-s-admin-state-specific-config-options',
            },
          },
          {
            alert: 'OpenStackNeutronL3AgentIsDown',
            expr: |||
              openstack_neutron_l3_agent_of_router{%(filteringSelector)s,agent_admin_up="true"} != 1
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Neutron L3 agent is down on the specific node.',
              description: (
                'OpenStack Neutron L3 agent is down on hostname {{ $labels.agent_host }} on OpenStack cluster {{ $labels.%(instanceFirstLabel)s }}.'
              ) % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNeutronHighDisconnectedPortRate',
            expr: |||
              100 * openstack_neutron_ports_no_ips{%(filteringSelector)s} / clamp_min(openstack_neutron_ports{%(filteringSelector)s}, 1) > %(alertsCriticalNeutronHighDisconnectedPortRate)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A high rate of ports have no IP addresses assigned to them.',
              description: |||
                {{ printf "%%.0f" $value }} percent of ports managed by the Neutron service on OpenStack cluster {{$labels.%(instanceFirstLabel)s}} have no IP addresses assigned to them,
                which is above the threshold of %(alertsCriticalNeutronHighDisconnectedPortRate)s.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
              description: |||
                {{ printf "%%.0f" $value }} percent of ports managed by the Neutron service on OpenStack cluster {{$labels.%(instanceFirstLabel)s}} have no IP addresses assigned to them,
                which is above the threshold of %(alertsCriticalNeutronHighDisconnectedPortRate)s.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackNeutronHighInactiveRouterRate',
            expr: |||
              100 * openstack_neutron_routers_not_active{%(filteringSelector)s} / clamp_min(openstack_neutron_routers{%(filteringSelector)s}, 1) > %(alertsCriticalNeutronHighInactiveRouterRate)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'A high rate of routers are currently inactive.',
              description: |||
                {{ printf "%%.0f" $value }} percent of routers managed by the Neutron service on cluster {{$labels.%(instanceFirstLabel)s}} are currently inactive,
                which is above the threshold of %(alertsCriticalNeutronHighInactiveRouterRate)s.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
        ],
      },
      {
        name: 'openstack-cinder-alerts' + this.config.uid,
        rules: [
          {
            alert: 'OpenStackCinderIsDown',
            expr: |||
              openstack_cinder_up{%(filteringSelector)s} == 0
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Cinder is down.',
              description: (
                'OpenStack Cinder service is down on cluster {{ $labels.%(instanceFirstLabel)s }}.'
              ) % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
                'OpenStack Cinder service is down on cluster {{ $labels.%(instanceFirstLabel)s }}.'
              ) % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackCinderAgentIsDown',
            expr: |||
              openstack_cinder_agent_state{%(filteringSelector)s,adminState="enabled"} != 1
              openstack_cinder_agent_state{%(filteringSelector)s,adminState="enabled"} != 1
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'OpenStack Cinder agent is down on the specific node.',
              description: (
                'OpenStack Cinder agent is down on hostname {{ $labels.hostname }} on OpenStack cluster {{ $labels.%(instanceFirstLabel)s }}.'
              ) % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackCinderHighPoolCapacityUsage',
            expr: |||
              100 * (openstack_cinder_pool_capacity_total_gb{%(filteringSelector)s} - openstack_cinder_pool_capacity_free_gb{%(filteringSelector)s}) / clamp_min(openstack_cinder_pool_capacity_total_gb{%(filteringSelector)s}, 1) > %(alertsWarningCinderHighPoolCapacityUsage)s
            ||| % this.config,
            'for': '10m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Cinder pools are using a large amount of their maximum capacity.',
              description: |||
                Pools managed by the Cinder service on cluster {{$labels.%(instanceFirstLabel)s}} are using {{ printf "%%.0f" $value }} percent of their allocated capacity,
                which is above the threshold of %(alertsWarningCinderHighPoolCapacityUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
              summary: 'Cinder pools are using a large amount of their maximum capacity.',
              description: |||
                Pools managed by the Cinder service on cluster {{$labels.%(instanceFirstLabel)s}} are using {{ printf "%%.0f" $value }} percent of their allocated capacity,
                which is above the threshold of %(alertsWarningCinderHighPoolCapacityUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackCinderHighVolumeMemoryUsage',
            expr: |||
              100 * openstack_cinder_limits_volume_used_gb{%(filteringSelector)s} / (openstack_cinder_limits_volume_max_gb{%(filteringSelector)s} > 0) > %(alertsWarningCinderHighVolumeMemoryUsage)s
              100 * openstack_cinder_limits_volume_used_gb{%(filteringSelector)s} / (openstack_cinder_limits_volume_max_gb{%(filteringSelector)s} > 0) > %(alertsWarningCinderHighVolumeMemoryUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Cinder volumes are using a large amount of their maximum memory.',
              description: |||
                Volumes managed by the Cinder service on cluster {{$labels.%(instanceFirstLabel)s}} are using {{ printf "%%.0f" $value }} percent of their allocated memory,
                which is above the threshold of %(alertsWarningCinderHighVolumeMemoryUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
              description: |||
                Volumes managed by the Cinder service on cluster {{$labels.%(instanceFirstLabel)s}} are using {{ printf "%%.0f" $value }} percent of their allocated memory,
                which is above the threshold of %(alertsWarningCinderHighVolumeMemoryUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
          {
            alert: 'OpenStackCinderHighBackupMemoryUsage',
            alert: 'OpenStackCinderHighBackupMemoryUsage',
            expr: |||
              100 * openstack_cinder_limits_backup_used_gb{%(filteringSelector)s} / (openstack_cinder_limits_backup_max_gb{%(filteringSelector)s} > 0) > %(alertsWarningCinderHighBackupMemoryUsage)s
              100 * openstack_cinder_limits_backup_used_gb{%(filteringSelector)s} / (openstack_cinder_limits_backup_max_gb{%(filteringSelector)s} > 0) > %(alertsWarningCinderHighBackupMemoryUsage)s
            ||| % this.config,
            'for': '5m',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: 'Cinder backups are using a large amount of their maximum memory.',
              description: |||
                Backups managed by the Cinder service on cluster {{$labels.%(instanceFirstLabel)s}} are using {{ printf "%%.0f" $value }} percent of their allocated memory,
                which is above the threshold of %(alertsWarningCinderHighBackupMemoryUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
              summary: 'Cinder backups are using a large amount of their maximum memory.',
              description: |||
                Backups managed by the Cinder service on cluster {{$labels.%(instanceFirstLabel)s}} are using {{ printf "%%.0f" $value }} percent of their allocated memory,
                which is above the threshold of %(alertsWarningCinderHighBackupMemoryUsage)s percent.
              ||| % this.config { instanceFirstLabel: this.config.instanceLabels[0] },
            },
          },
        ],
      },
    ],
  },
}
