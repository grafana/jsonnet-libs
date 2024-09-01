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

      glb_requests: [
        g.panel.row.new('Load Balancer Requests'),
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
    },
}
