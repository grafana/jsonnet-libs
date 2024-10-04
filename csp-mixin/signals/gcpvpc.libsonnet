local commonlib = import 'common-lib/common/main.libsonnet';
function(this)
  {
    local s = self,
    filteringSelector: this.filteringSelector,
    groupLabels: ['job'],
    instanceLabels: ['project_id'],
    aggLevel: 'group',
    discoveryMetric: {
      stackdriver: 'stackdriver_networking_googleapis_com_location_networking_googleapis_com_fixed_standard_tier_usage',
    },
    signals: {
      //
      // Fixed Usage Tier
      //
      // available labels: ['bandwidth_policy_id', 'location', 'project_id', 'traffic_source']
      gcpvpc_fixed_usage_tier_network_egress: {
        name: 'Fixed standard tier network egress',
        description: 'Rate in bytes of network egress on the fixed standard tier.',
        type: 'gauge',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_networking_googleapis_com_location_networking_googleapis_com_fixed_standard_tier_usage{%(queriesSelector)s}',
            aggKeepLabels: ['traffic_source'],
          },
        },
      },

      //
      // Overview counters
      //
      gcpvpc_services_in_use_count: {
        name: 'Total services in use',
        description: 'Count of unique service names (including "UNKNOWN") with ingress or egress traffic.',
        type: 'raw',
        unit: 'short',
        sources: {
          stackdriver: {
            expr: 'count(count by (service_name) (stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s} OR stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s}))',
          },
        },
      },

      gcpvpc_subnets_in_use_count: {
        name: 'Total subnets in use',
        description: 'Count of unique subnets (including the catch-all "LOCAL_IS_EXTERNAL") with ingress or egress traffic on services or a VPN tunnel.',
        type: 'raw',
        unit: 'short',
        sources: {
          stackdriver: {
            expr: 'count(count by (local_subnetwork) (stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s} OR stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s} OR stackdriver_vpn_tunnel_networking_googleapis_com_vpn_tunnel_egress_bytes_count{%(queriesSelector)s} OR stackdriver_vpn_tunnel_networking_googleapis_com_vpn_tunnel_ingress_bytes_count{%(queriesSelector)s}))',
          },
        },
      },

      //
      // Service Metrics
      //

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_request_bytes: {
        name: 'received',
        description: '',
        type: 'counter',
        unit: 'bps',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s}',
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_response_bytes: {
        name: 'transmitted',
        description: '',
        type: 'counter',
        unit: 'bps',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s}',
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_topk_throughput_bytes: {
        name: 'Top 5 services by network throughput.',
        description: '',
        type: 'gauge',
        unit: 'bps',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: 'stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s} + stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s}',
            exprWrappers: [['topk(5,', ')']],
            aggKeepLabels: ['service_name'],
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_topk_error_percent: {
        name: 'Top 5 services by network error response code',
        description: '',
        type: 'gauge',
        unit: 'percent',
        aggFunction: 'avg',
        sources: {
          stackdriver: {
            expr: '(stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s, response_code_class=~"500|400"} + stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s, response_code_class=~"500|400"}) / (stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s} + stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s})',
            exprWrappers: [['topk(5,', ')']],
            aggKeepLabels: ['service_name'],
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_request_by_responsecode_bytes: {
        name: 'received',
        description: '',
        type: 'counter',
        unit: 'bps',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s}',
            aggKeepLabels: ['response_code_class'],
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_response_by_responsecode_bytes: {
        name: 'transmitted',
        description: '',
        type: 'counter',
        unit: 'bps',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s}',
            aggKeepLabels: ['response_code_class'],
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_request_by_service_bytes: {
        name: 'received',
        description: '',
        type: 'counter',
        unit: 'bps',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s}',
            aggKeepLabels: ['service_name'],
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_response_by_service_bytes: {
        name: 'transmitted',
        description: '',
        type: 'counter',
        unit: 'bps',
        aggFunction: 'sum',
        sources: {
          stackdriver: {
            expr: 'stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s}',
            aggKeepLabels: ['service_name'],
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_request_by_service_error_bytes: {
        name: 'received',
        description: '',
        type: 'raw',
        unit: 'percent',
        sources: {
          stackdriver: {
            expr: 'sum by (service_name) (stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s, response_code_class=~"500|400"}) / sum by (service_name) (stackdriver_google_service_gce_client_networking_googleapis_com_google_service_request_bytes_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{service_name}}: received',
          },
        },
      },

      // available labels: ['instance_name', 'instance_id', 'local_network', 'local_network_interface', 'local_subnetwork', 'project_id', 'protocol', 'region', 'resource_type', 'response_code_class', 'service_name', 'service_region', 'zone']
      gcpvpc_service_response_by_service_error_bytes: {
        name: 'transmitted',
        description: '',
        type: 'raw',
        unit: 'percent',
        sources: {
          stackdriver: {
            expr: 'sum by (service_name) (stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s, response_code_class=~"500|400"}) / sum by (service_name) (stackdriver_google_service_gce_client_networking_googleapis_com_google_service_response_bytes_count{%(queriesSelector)s})',
            legendCustomTemplate: '{{service_name}}: transmitted',
          },
        },
      },      

      //
      // VPN Tunnel Metrics
      //

      // available labels: ['local_location_type', 'local_network', 'local_project_id', 'local_project_number', 'local_region', 'local_resource_type', 'local_subnetwork', 'local_zone', 'project_id', 'protocol', 'region', 'tunnel_id']
      gcpvpn_tunnel_egress_bytes: {
        name: 'transmitted',
        description: '',
        type: 'counter',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_vpn_tunnel_networking_googleapis_com_vpn_tunnel_egress_bytes_count{%(queriesSelector)s}',
          },
        },
      },

      // available labels: ['local_location_type', 'local_network', 'local_project_id', 'local_project_number', 'local_region', 'local_resource_type', 'local_subnetwork', 'local_zone', 'project_id', 'protocol', 'region', 'tunnel_id']
      gcpvpn_tunnel_ingress_bytes: {
        name: 'received',
        description: '',
        type: 'counter',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_vpn_tunnel_networking_googleapis_com_vpn_tunnel_ingress_bytes_count{%(queriesSelector)s}',
          },
        },
      },

      // available labels: ['local_location_type', 'local_network', 'local_project_id', 'local_project_number', 'local_region', 'local_resource_type', 'local_subnetwork', 'local_zone', 'project_id', 'protocol', 'region', 'tunnel_id']
      gcpvpn_tunnel_egress_by_protocol_bytes: {
        name: 'transmitted',
        description: '',
        type: 'counter',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_vpn_tunnel_networking_googleapis_com_vpn_tunnel_egress_bytes_count{%(queriesSelector)s}',
            aggKeepLabels: ['protocol'],
          },
        },
      },

      // available labels: ['local_location_type', 'local_network', 'local_project_id', 'local_project_number', 'local_region', 'local_resource_type', 'local_subnetwork', 'local_zone', 'project_id', 'protocol', 'region', 'tunnel_id']
      gcpvpn_tunnel_ingress_by_protocol_bytes: {
        name: 'received',
        description: '',
        type: 'counter',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_vpn_tunnel_networking_googleapis_com_vpn_tunnel_ingress_bytes_count{%(queriesSelector)s}',
            aggKeepLabels: ['protocol'],
          },
        },
      },

      // available labels: ['local_location_type', 'local_network', 'local_project_id', 'local_project_number', 'local_region', 'local_resource_type', 'local_subnetwork', 'local_zone', 'project_id', 'protocol', 'region', 'tunnel_id']
      gcpvpn_tunnel_egress_by_resource_type_bytes: {
        name: 'transmitted',
        description: '',
        type: 'counter',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_vpn_tunnel_networking_googleapis_com_vpn_tunnel_egress_bytes_count{%(queriesSelector)s}',
            aggKeepLabels: ['local_resource_type'],
          },
        },
      },

      // available labels: ['local_location_type', 'local_network', 'local_project_id', 'local_project_number', 'local_region', 'local_resource_type', 'local_subnetwork', 'local_zone', 'project_id', 'protocol', 'region', 'tunnel_id']
      gcpvpn_tunnel_ingress_by_resource_type_bytes: {
        name: 'received',
        description: '',
        type: 'counter',
        unit: 'bps',
        sources: {
          stackdriver: {
            expr: 'stackdriver_vpn_tunnel_networking_googleapis_com_vpn_tunnel_ingress_bytes_count{%(queriesSelector)s}',
            aggKeepLabels: ['local_resource_type'],
          },
        },
      },
    },
  }
