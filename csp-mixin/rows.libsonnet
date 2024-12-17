local g = import './g.libsonnet';
{
  new(this):
    {
      // Blob Storage
      overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.blobstore.bucketCount
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.blobstore.objectCountTotal
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.blobstore.totalBytesTotal
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.blobstore.totalNetworkThroughput
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.blobstore.objectCountByBucket
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.blobstore.totalBytesByBucket
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
      ],
      api: std.prune(
        [
          g.panel.row.new('API'),
        ] +
        [
          if this.config.blobStorage.enableAvailability then
            this.grafana.panels.blobstore.availabilityTs
            + g.panel.timeSeries.gridPos.withW(24)
            + g.panel.timeSeries.gridPos.withH(6),
        ]
        +
        [
          this.grafana.panels.blobstore.apiRequestCount
          + g.panel.timeSeries.gridPos.withW(12)
          + g.panel.timeSeries.gridPos.withH(12),
          this.grafana.panels.blobstore.apiErrorRate
          + g.panel.timeSeries.gridPos.withW(12)
          + g.panel.timeSeries.gridPos.withH(12),
        ]
      ),
      network: [
        g.panel.row.new('Network'),
        this.grafana.panels.blobstore.network
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(12),
      ],

      // Azure elasticpool
      aep_storage: [
        g.panel.row.new('Storage'),
        this.grafana.panels.azureelasticpool.aep_storage
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(6),
      ],

      aep_resources: [
        g.panel.row.new('Resources'),
        this.grafana.panels.azureelasticpool.aep_cpu
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.azureelasticpool.aep_mem
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.azureelasticpool.aep_dtu
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.azureelasticpool.aep_session
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),
      ],

      // Azure SQL Database
      asql_connections: [
        g.panel.row.new('Connections'),
        this.grafana.panels.azuresqldb.asql_conns
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azuresqldb.asql_deadlocks
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azuresqldb.asql_sessions
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      asql_resources: [
        g.panel.row.new('Resources'),
        this.grafana.panels.azuresqldb.asql_cpu
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azuresqldb.asql_storagebytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azuresqldb.asql_storagepercent
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azuresqldb.asql_dtuts
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azuresqldb.asql_dtutbl
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      // GCP Load Balancer
      glb_requests: [
        g.panel.row.new('Load balancer requests'),
        this.grafana.panels.gcploadbalancer.glb_reqsec
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcploadbalancer.glb_reqcountry
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcploadbalancer.glb_reqcache
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcploadbalancer.glb_reqprotocol
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcploadbalancer.glb_errorrate
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(9),
      ],

      glb_latency: [
        g.panel.row.new('Latency'),
        this.grafana.panels.gcploadbalancer.glb_reslatency
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(9),

        this.grafana.panels.gcploadbalancer.glb_frontendlatency
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcploadbalancer.glb_backendlatency
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      glb_traffic_metrics: [
        g.panel.row.new('Traffic'),
        this.grafana.panels.gcploadbalancer.glb_req_bytes_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcploadbalancer.glb_backend_req_bytes_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      // Azure Load balancer

      alb_summary: [
        g.panel.row.new('Summary'),
        this.grafana.panels.azureloadbalancer.alb_sync_packets
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(2),

        this.grafana.panels.azureloadbalancer.alb_total_packets
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(2),

        this.grafana.panels.azureloadbalancer.alb_total_bytes
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(2),

        this.grafana.panels.azureloadbalancer.alb_snat_connections
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(2),
      ],
      alb_details: [
        g.panel.row.new('Details'),
        this.grafana.panels.azureloadbalancer.alb_details_sync_packets
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azureloadbalancer.alb_details_total_packets
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azureloadbalancer.alb_details_total_bytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azureloadbalancer.alb_details_snat_connections
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      alb_loadbalancers: [
        g.panel.row.new('SNAT Ports'),
        this.grafana.panels.azureloadbalancer.alb_snatports
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azureloadbalancer.alb_used_snatports
        + g.panel.gauge.gridPos.withW(12)
        + g.panel.gauge.gridPos.withH(8),
      ],

      // Azure Virtual Network
      vn_overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.azurevirtualnetwork.vn_under_ddos
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.azurevirtualnetwork.vn_pingmesh_avg
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.azurevirtualnetwork.vn_packet_trigger
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),
      ],

      vn_bytes: [
        g.panel.row.new('Bytes'),
        this.grafana.panels.azurevirtualnetwork.vn_bytes_by_action
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevirtualnetwork.vn_bytes_dropped_by_protocol
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevirtualnetwork.vn_bytes_forwarded_by_protocol
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      vn_packets: [
        g.panel.row.new('Packets'),
        this.grafana.panels.azurevirtualnetwork.vn_packets_by_action
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevirtualnetwork.vn_packets_dropped_by_protocol
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevirtualnetwork.vn_packets_forwarded_by_protocol
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),
      ],


      // Azure Virtual Machines
      avm_overview: [
        g.panel.row.new('Overview'),

        this.grafana.panels.azurevm.avm_instance_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(5),

        this.grafana.panels.azurevm.avm_availability
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(5),

        this.grafana.panels.azurevm.avm_top5_cpu_utilization
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevm.avm_bottom5_memory_available
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevm.avm_top5_disk_read
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevm.avm_top5_disk_write
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevm.avm_instances_table
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevm.avm_disk_total_bytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevm.avm_disk_operations
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevm.avm_network_total
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurevm.avm_connections
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      avm_instance: [
        g.panel.row.new('Instance')
        + g.panel.row.withCollapsed(true)
        + g.panel.row.withPanels(
          [
            this.grafana.panels.azurevm.avm_text_instances
            + g.panel.timeSeries.gridPos.withW(24)
            + g.panel.timeSeries.gridPos.withH(2),

            this.grafana.panels.azurevm.avm_cpu_utilization
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_available_memory
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_cpu_credits_consumed
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_cpu_credits_remaining
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_network_in_by_instance
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_network_out_by_instance
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_disk_read_by_instance
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_disk_write_by_instance
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_disk_read_operations_by_instance
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_disk_write_operations_by_instance
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_inbound_flows_by_instance
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurevm.avm_outbound_flows_by_instance
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),
          ]
        ),
      ],

      // Azure Queue Storage
      azqueuestore_overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.azurequeuestore.queueCount
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.azurequeuestore.messageCountTotal
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.azurequeuestore.totalBytesTotal
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.azurequeuestore.totalNetworkThroughput
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.azurequeuestore.messageCountByQueue
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.azurequeuestore.totalBytesByBucket
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.azurequeuestore.messageCountTs
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(7),
      ],
      azqueuestore_api: [
        g.panel.row.new('API'),
        this.grafana.panels.azurequeuestore.availabilityTs
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(6),
        this.grafana.panels.azurequeuestore.apiRequestCount
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(12),
        this.grafana.panels.azurequeuestore.apiErrorRate
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(12),
      ],
      azqueuestore_network: [
        g.panel.row.new('Network'),
        this.grafana.panels.azurequeuestore.network
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(12),
      ],

      // Gcp Compute Engine
      gce_overview: [
        g.panel.row.new('Overview'),

        this.grafana.panels.gcpce.gce_instance_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(5),

        this.grafana.panels.gcpce.gce_system_problem_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(5),

        this.grafana.panels.gcpce.gce_top5_cpu_utilization
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpce.gce_top5_system_problem
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpce.gce_top5_disk_read_bytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpce.gce_top5_disk_write_bytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpce.gce_instances
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(12),

        this.grafana.panels.gcpce.gce_memory_utilization
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpce.gce_total_packets_sent_received
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpce.gce_network_send_received
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpce.gce_bytes_read_write
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      gce_instance: [
        g.panel.row.new('Instance')
        + g.panel.row.withCollapsed(true)
        + g.panel.row.withPanels(
          [
            this.grafana.panels.gcpce.gce_text_instances
            + g.panel.timeSeries.gridPos.withW(24)
            + g.panel.timeSeries.gridPos.withH(2),

            this.grafana.panels.gcpce.gce_cpu_utilization
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gcpce.gce_cpu_usage_time
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gcpce.gce_network_received
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gcpce.gce_network_sent
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gcpce.gce_count_disk_read_bytes
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gcpce.gce_count_disk_write_bytes
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gcpce.gce_count_disk_read_operations
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gcpce.gce_count_disk_write_operations
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),
          ]
        ),
      ],

      gcpvpc_overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.gcpvpc.gcpvpc_services_in_use_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(4),

        this.grafana.panels.gcpvpc.gcpvpc_subnets_in_use_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(4),

        this.grafana.panels.gcpvpc.gcpvpc_fixed_usage_tier_network_egress
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      gcpvpc_service: [
        g.panel.row.new('Services'),
        this.grafana.panels.gcpvpc.gcpvpc_service_topk_throughput
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpvpc.gcpvpc_service_topk_error
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpvpc.gcpvpc_service_throughput
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpvpc.gcpvpc_service_by_service_error_throughput
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpvpc.gcpvpc_service_by_service_throughput
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpvpc.gcpvpc_service_by_responsecode_throughput
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      gcpvpc_tunnel: [
        g.panel.row.new('VPN tunnels'),
        this.grafana.panels.gcpvpc.gcpvpc_tunnel_throughput
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpvpc.gcpvpc_tunnel_by_protocol_throughput
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gcpvpc.gcpvpc_tunnel_by_resource_type_throughput
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      // Azure Front Door
      afd_overview: [
        g.panel.row.new('Overview'),

        this.grafana.panels.azurefrontdoor.afd_endpoint_count
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(5),

        this.grafana.panels.azurefrontdoor.afd_top5_errors
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurefrontdoor.afd_total_requests
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurefrontdoor.afd_requests_by_country
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurefrontdoor.afd_requests_by_status
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurefrontdoor.afd_requests_by_errors
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurefrontdoor.afd_requests_responses_size
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurefrontdoor.afd_total_latency
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurefrontdoor.afd_origin_health
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.azurefrontdoor.afd_origin_latency
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      afd_endpoints: [
        g.panel.row.new('Endpoints')
        + g.panel.row.withCollapsed(true)
        + g.panel.row.withPanels(
          [
            this.grafana.panels.azurefrontdoor.afd_requests_by_endpoint
            + g.panel.timeSeries.gridPos.withW(24)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurefrontdoor.afd_requests_size_by_endpoint
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurefrontdoor.afd_responses_size_by_endpoint
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurefrontdoor.afd_total_latency_by_endpoint
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurefrontdoor.afd_errors_by_endpoint
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurefrontdoor.afd_origin_requests_by_endpoint
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.azurefrontdoor.afd_origin_latency_by_endpoint
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),
          ]
        ),
      ],
    },
}
