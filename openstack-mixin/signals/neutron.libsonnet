function(this) {
  filteringSelector: this.filteringSelector,
  groupLabels: this.groupLabels,
  instanceLabels: this.instanceLabels,
  enableLokiLogs: this.enableLokiLogs,
  aggLevel: 'none',
  aggFunction: 'avg',
  alertsInterval: '5m',
  discoveryMetric: {
    prometheus: 'openstack_neutron_up',
  },
  signals: {
    neutron_up: {
      name: 'Neutron status',
      description: 'Reports the status of the Neutron networking service.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_up{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_networks: {
      name: 'Networks',
      description: 'The number of networks managed by Neutron.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_networks{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_subnets: {
      name: 'Subnets',
      description: 'The number of subnets managed by Neutron.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_subnets{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_routers: {
      name: 'Routers',
      description: 'The total number of routers managed by Neutron.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_routers{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_routers_not_active: {
      name: 'Inactive routers',
      description: 'The number of routers that are not active.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_routers_not_active{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_router_info: {
      name: 'Router info',
      description: 'Router details from Neutron.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_router{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{name}}',
        },
      },
    },
    neutron_ports: {
      name: 'Ports',
      description: 'The total number of ports managed by Neutron.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_ports{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_ports_lb_not_active: {
      name: 'Load balancer inactive ports',
      description: 'The number of load balancer ports that are not active.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_ports_lb_not_active{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_ports_no_ips: {
      name: 'Ports with no IPs',
      description: 'The number of ports with no IP addresses assigned.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_ports_no_ips{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_port_info: {
      name: 'Port info',
      description: 'Port details from Neutron.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_port{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{mac_address}}',
        },
      },
    },
    neutron_floating_ips: {
      name: 'Floating IPs',
      description: 'The total number of floating IP addresses managed by Neutron.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_floating_ips{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_floating_ips_associated_not_active: {
      name: 'Inactive associated floating IPs',
      description: 'The number of associated floating IP addresses that are not active.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_floating_ips_associated_not_active{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_ip_availabilities_used: {
      name: 'IPs used',
      description: 'The number of IP addresses used per network.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_network_ip_availabilities_used{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{network_name}}',
        },
      },
    },
    neutron_ip_availabilities_total: {
      name: 'IPs total',
      description: 'The total number of IP addresses available per network.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_network_ip_availabilities_total{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{network_name}}',
        },
      },
    },
    neutron_free_ips: {
      name: 'Free IPs',
      description: 'The number of free IP addresses per network.',
      type: 'raw',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_network_ip_availabilities_total{%(queriesSelector)s} - openstack_neutron_network_ip_availabilities_used{%(queriesSelector)s}',
          legendCustomTemplate: '{{network_name}}',
        },
      },
    },
    neutron_ip_usage_ratio: {
      name: 'IP pool usage',
      description: 'Percentage of IP pool used per subnet.',
      type: 'raw',
      unit: 'percentunit',
      sources: {
        prometheus: {
          expr: 'sum by (job, instance, ip_version, subnet_name) (openstack_neutron_network_ip_availabilities_used{%(queriesSelector)s}) / sum by (job, instance, ip_version, subnet_name) (openstack_neutron_network_ip_availabilities_total{%(queriesSelector)s})',
          legendCustomTemplate: '{{instance}} - {{subnet_name}}',
        },
      },
    },
    neutron_ip_usage_percent: {
      name: 'IP pool usage percent',
      description: 'Percentage of IP pool used per network.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * sum by (job, instance, network_name) (openstack_neutron_network_ip_availabilities_used{%(queriesSelector)s}) / (sum by (job, instance, network_name) (openstack_neutron_network_ip_availabilities_total{%(queriesSelector)s}) > 0)',
          legendCustomTemplate: '{{instance}} - {{network_name}}',
        },
      },
    },
    neutron_security_groups: {
      name: 'Security groups',
      description: 'The number of network security groups managed by Neutron.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_security_groups{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_agent_state: {
      name: 'Neutron agent state',
      description: 'The state of Neutron network agents.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_agent_state{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{service}} - {{hostname}}',
        },
      },
    },
    neutron_l3_agent_of_router: {
      name: 'L3 agent state',
      description: 'The state of the Neutron L3 agent per router.',
      type: 'gauge',
      unit: 'short',
      sources: {
        prometheus: {
          expr: 'openstack_neutron_l3_agent_of_router{%(queriesSelector)s}',
          legendCustomTemplate: '{{instance}} - {{agent_host}}',
        },
      },
    },
    neutron_disconnected_port_ratio: {
      name: 'Disconnected port ratio',
      description: 'Percentage of ports with no IP addresses assigned.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * openstack_neutron_ports_no_ips{%(queriesSelector)s} / clamp_min(openstack_neutron_ports{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
    neutron_inactive_router_ratio: {
      name: 'Inactive router ratio',
      description: 'Percentage of routers that are currently inactive.',
      type: 'raw',
      unit: 'percent',
      sources: {
        prometheus: {
          expr: '100 * openstack_neutron_routers_not_active{%(queriesSelector)s} / clamp_min(openstack_neutron_routers{%(queriesSelector)s}, 1)',
          legendCustomTemplate: '{{instance}}',
        },
      },
    },
  },
}
