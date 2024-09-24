local g = import './g.libsonnet';
{
  new(this):
    {
      // Blob Storage
      overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.bucketCount
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.objectCountTotal
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.totalBytesTotal
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(4),
        this.grafana.panels.totalNetworkThroughput
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.objectCountByBucket
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
        this.grafana.panels.totalBytesByBucket
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(7),
      ],
      api: std.prune(
        [
          g.panel.row.new('API'),
        ] +
        [
          if this.config.blobStorage.enableAvailability then
            this.grafana.panels.availabilityTs
            + g.panel.timeSeries.gridPos.withW(24)
            + g.panel.timeSeries.gridPos.withH(6),
        ]
        +
        [
          this.grafana.panels.apiRequestCount
          + g.panel.timeSeries.gridPos.withW(12)
          + g.panel.timeSeries.gridPos.withH(12),
          this.grafana.panels.apiErrorRate
          + g.panel.timeSeries.gridPos.withW(12)
          + g.panel.timeSeries.gridPos.withH(12),
        ]
      ),
      network: [
        g.panel.row.new('Network'),
        this.grafana.panels.network
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(12),
      ],

      // Azure elasticpool
      aep_storage: [
        g.panel.row.new('Storage'),
        this.grafana.panels.aep_storage
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(6),
      ],

      aep_resources: [
        g.panel.row.new('Resources'),
        this.grafana.panels.aep_cpu
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.aep_mem
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.aep_dtu
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.aep_session
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),
      ],

      // Azure SQL Database
      asql_connections: [
        g.panel.row.new('Connections'),
        this.grafana.panels.asql_conns
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.asql_deadlocks
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.asql_sessions
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      asql_resources: [
        g.panel.row.new('Resources'),
        this.grafana.panels.asql_cpu
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.asql_storagebytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.asql_storagepercent
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.asql_dtuts
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.asql_dtutbl
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      // GCP Load Balancer
      glb_requests: [
        g.panel.row.new('Load balancer requests'),
        this.grafana.panels.glb_reqsec
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.glb_reqcountry
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.glb_reqcache
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.glb_reqprotocol
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.glb_errorrate
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(9),
      ],

      glb_latency: [
        g.panel.row.new('Latency'),
        this.grafana.panels.glb_reslatency
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(9),

        this.grafana.panels.glb_frontendlatency
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.glb_backendlatency
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      glb_traffic_metrics: [
        g.panel.row.new('Traffic'),
        this.grafana.panels.glb_req_bytes_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.glb_backend_req_bytes_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      // Azure Load balancer

      alb_summary: [
        g.panel.row.new('Summary'),
        this.grafana.panels.alb_sync_packets
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(2),

        this.grafana.panels.alb_total_packets
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(2),

        this.grafana.panels.alb_total_bytes
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(2),

        this.grafana.panels.alb_snat_connections
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(2),
      ],
      alb_details: [
        g.panel.row.new('Details'),
        this.grafana.panels.alb_details_sync_packets
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.alb_details_total_packets
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.alb_details_total_bytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.alb_details_snat_connections
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      alb_loadbalancers: [
        g.panel.row.new('SNAT Ports'),
        this.grafana.panels.alb_snatports
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.alb_used_snatports
        + g.panel.gauge.gridPos.withW(12)
        + g.panel.gauge.gridPos.withH(8),
      ],

      // Azure Virtual Network
      vn_overview: [
        g.panel.row.new('Overview'),
        this.grafana.panels.vn_under_ddos
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.vn_pingmesh_avg
        + g.panel.timeSeries.gridPos.withW(6)
        + g.panel.timeSeries.gridPos.withH(6),

        this.grafana.panels.vn_packet_trigger
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(6),
      ],

      vn_bytes: [
        g.panel.row.new('Bytes'),
        this.grafana.panels.vn_bytes_by_action
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.vn_bytes_dropped_by_protocol
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.vn_bytes_forwarded_by_protocol
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      vn_packets: [
        g.panel.row.new('Packets'),
        this.grafana.panels.vn_packets_by_action
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.vn_packets_dropped_by_protocol
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.vn_packets_forwarded_by_protocol
        + g.panel.timeSeries.gridPos.withW(8)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      // Gcp Compute Engine
      gce_overview: [
        g.panel.row.new('Overview'),

        this.grafana.panels.gce_instance_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(5),

        this.grafana.panels.gce_system_problem_count
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(5),

        this.grafana.panels.gce_top5_cpu_utilization
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gce_top5_system_problem
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gce_top5_disk_write_bytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gce_top5_disk_read_bytes
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gce_instances
        + g.panel.timeSeries.gridPos.withW(24)
        + g.panel.timeSeries.gridPos.withH(12),

        this.grafana.panels.gce_memory_utilization
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gce_total_packets_sent_received
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gce_network_send_received
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),

        this.grafana.panels.gce_bytes_read_write
        + g.panel.timeSeries.gridPos.withW(12)
        + g.panel.timeSeries.gridPos.withH(8),
      ],

      gce_instance: [
        g.panel.row.new('Instance')
        + g.panel.row.withCollapsed(true)
        + g.panel.row.withPanels(
          [

            this.grafana.panels.gce_cpu_utilization
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gce_cpu_usage_time
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gce_network_received
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gce_network_sent
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gce_count_disk_read_bytes
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gce_count_disk_write_bytes
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gce_count_disk_read_operations
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),

            this.grafana.panels.gce_count_disk_write_operations
            + g.panel.timeSeries.gridPos.withW(12)
            + g.panel.timeSeries.gridPos.withH(8),
          ]
        ),
      ],
    },
}
